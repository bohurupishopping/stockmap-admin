import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_models.dart';

class ProductService {
  static final _supabase = Supabase.instance.client;

  static Future<Map<String, dynamic>> getProducts({
    ProductFilters? filters,
    int page = 1,
    int limit = 20,
    String sortField = 'product_name',
    String sortDirection = 'asc',
  }) async {
    try {
      dynamic query = _supabase
          .from('products')
          .select('''
            *,
            product_categories(category_name),
            product_sub_categories(sub_category_name),
            product_formulations(formulation_name)
          ''');

      // Apply filters
      if (filters != null) {
        if (filters.searchQuery?.isNotEmpty == true) {
          query = query.or(
            'product_name.ilike.%${filters.searchQuery}%,'
            'product_code.ilike.%${filters.searchQuery}%,'
            'generic_name.ilike.%${filters.searchQuery}%,'
            'manufacturer.ilike.%${filters.searchQuery}%'
          );
        }

        if (filters.categoryId?.isNotEmpty == true) {
          query = query.eq('category_id', filters.categoryId!);
        }

        if (filters.subCategoryId?.isNotEmpty == true) {
          query = query.eq('sub_category_id', filters.subCategoryId!);
        }

        if (filters.formulationId?.isNotEmpty == true) {
          query = query.eq('formulation_id', filters.formulationId!);
        }

        if (filters.manufacturer?.isNotEmpty == true) {
          query = query.eq('manufacturer', filters.manufacturer!);
        }

        if (filters.isActive != null) {
          query = query.eq('is_active', filters.isActive!);
        }

        if (filters.minCost != null) {
          query = query.gte('base_cost_per_strip', filters.minCost!);
        }

        if (filters.maxCost != null) {
          query = query.lte('base_cost_per_strip', filters.maxCost!);
        }
      }

      // Apply sorting
      query = query.order(sortField, ascending: sortDirection == 'asc');

      // Get total count
      dynamic countQuery = _supabase
          .from('products')
          .select('*');
      
      if (filters != null) {
        if (filters.searchQuery?.isNotEmpty == true) {
          countQuery.or(
            'product_name.ilike.%${filters.searchQuery}%,'
            'product_code.ilike.%${filters.searchQuery}%,'
            'generic_name.ilike.%${filters.searchQuery}%,'
            'manufacturer.ilike.%${filters.searchQuery}%'
          );
        }
        if (filters.categoryId?.isNotEmpty == true) {
          countQuery.eq('category_id', filters.categoryId!);
        }
        if (filters.subCategoryId?.isNotEmpty == true) {
          countQuery.eq('sub_category_id', filters.subCategoryId!);
        }
        if (filters.formulationId?.isNotEmpty == true) {
          countQuery.eq('formulation_id', filters.formulationId!);
        }
        if (filters.manufacturer?.isNotEmpty == true) {
          countQuery.eq('manufacturer', filters.manufacturer!);
        }
        if (filters.isActive != null) {
          countQuery.eq('is_active', filters.isActive!);
        }
        if (filters.minCost != null) {
          countQuery.gte('base_cost_per_strip', filters.minCost!);
        }
        if (filters.maxCost != null) {
          countQuery.lte('base_cost_per_strip', filters.maxCost!);
        }
      }

      // Apply pagination
      final offset = (page - 1) * limit;
      query = query.range(offset, offset + limit - 1);

      final results = await Future.wait<dynamic>([
        query,
        countQuery,
      ]);

      final data = results[0] as List<dynamic>;
      final countData = results[1] as List<dynamic>;
      final totalCount = countData.length;

      final products = data.map((json) => Product.fromJson(json)).toList();
      
      // Fetch closing stock data for all products
      await _enrichWithClosingStock(products);

      return {
        'products': products,
        'totalCount': totalCount,
        'hasMore': (page * limit) < totalCount,
      };
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  static Future<List<ProductCategory>> getCategories() async {
    try {
      final response = await _supabase
          .from('product_categories')
          .select()
          .eq('is_active', true)
          .order('category_name');

      return response.map((json) => ProductCategory.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  static Future<List<ProductSubCategory>> getSubCategories(String? categoryId) async {
    try {
      var query = _supabase
          .from('product_sub_categories')
          .select()
          .eq('is_active', true);

      if (categoryId?.isNotEmpty == true) {
        query = query.eq('category_id', categoryId!);
      }

      final response = await query.order('sub_category_name');

      return response.map((json) => ProductSubCategory.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch sub-categories: $e');
    }
  }

  static Future<List<ProductFormulation>> getFormulations() async {
    try {
      final response = await _supabase
          .from('product_formulations')
          .select()
          .eq('is_active', true)
          .order('formulation_name');

      return response.map((json) => ProductFormulation.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch formulations: $e');
    }
  }

  static Future<List<String>> getManufacturers() async {
    try {
      final response = await _supabase
          .from('products')
          .select('manufacturer')
          .eq('is_active', true)
          .order('manufacturer');

      final manufacturers = response
          .map((item) => item['manufacturer'] as String)
          .where((manufacturer) => manufacturer.isNotEmpty)
          .toSet()
          .toList();

      return manufacturers;
    } catch (e) {
      throw Exception('Failed to fetch manufacturers: $e');
    }
  }

  /// Enriches products with closing stock data calculated from stock transactions
  static Future<void> _enrichWithClosingStock(List<Product> products) async {
    try {
      if (products.isEmpty) return;
      
      final productIds = products.map((p) => p.id).toList();
      
      // Fetch packaging units for box conversion
      final packagingUnits = await _supabase
          .from('product_packaging_units')
          .select('product_id, unit_name, conversion_factor_to_strips')
          .inFilter('product_id', productIds)
          .eq('unit_name', 'Box');
      
      // Create maps for quick lookup
      final packagingMap = <String, int>{};
      
      // Process packaging units
      for (final unit in packagingUnits) {
        final productId = unit['product_id'] as String;
        final conversionFactor = (unit['conversion_factor_to_strips'] ?? 10) as int;
        packagingMap[productId] = conversionFactor;
      }
      
      // Update products with calculated stock data
      for (int i = 0; i < products.length; i++) {
        final product = products[i];
        
        // Calculate current stock from transactions
        final stockData = await _calculateProductStock(product.id);
        final stripsPerBox = packagingMap[product.id] ?? 10; // Default to 10 strips per box
        
        // Create a new product instance with calculated stock data
        products[i] = Product(
          id: product.id,
          productCode: product.productCode,
          productName: product.productName,
          genericName: product.genericName,
          manufacturer: product.manufacturer,
          categoryId: product.categoryId,
          subCategoryId: product.subCategoryId,
          formulationId: product.formulationId,
          unitOfMeasureSmallest: product.unitOfMeasureSmallest,
          baseCostPerStrip: product.baseCostPerStrip,
          isActive: product.isActive,
          storageConditions: product.storageConditions,
          imageUrl: product.imageUrl,
          minStockLevelGodown: product.minStockLevelGodown,
          minStockLevelMr: product.minStockLevelMr,
          leadTimeDays: product.leadTimeDays,
          createdAt: product.createdAt,
          updatedAt: product.updatedAt,
          categoryName: product.categoryName,
          subCategoryName: product.subCategoryName,
          formulationName: product.formulationName,
          closingStockGodown: stockData['godownStock'] ?? 0,
          closingStockMr: stockData['mrStock'] ?? 0,
          stripsPerBox: stripsPerBox,
        );
      }
    } catch (e) {
      // If calculating stock fails, continue with default values (0)
    }
  }

  /// Calculates current stock for a product from stock transactions
  static Future<Map<String, int>> _calculateProductStock(String productId) async {
    try {
      // Fetch all transactions for this product
      final transactionsResponse = await _supabase
          .from('stock_transactions_view')
          .select('''
            transaction_type,
            quantity_strips,
            location_type_source,
            location_id_source,
            location_type_destination,
            location_id_destination
          ''')
          .eq('product_id', productId);

      int godownStock = 0;
      int mrStock = 0;

      // Process each transaction to calculate current stock
      for (final transaction in transactionsResponse) {
        final txType = transaction['transaction_type'] as String;
        final quantityStrips = transaction['quantity_strips'] as int? ?? 0;
        final locationTypeSource = transaction['location_type_source'] as String?;
        final locationTypeDestination = transaction['location_type_destination'] as String?;

        // Process transaction based on type
        if (txType == 'STOCK_IN_GODOWN') {
          // Stock coming into godown
          godownStock += quantityStrips;
        } else if (txType == 'DISPATCH_TO_MR') {
          // Dispatch from godown to MR
          if (locationTypeSource == 'GODOWN') {
            godownStock += quantityStrips; // DB stores as negative for outflow
          }
          if (locationTypeDestination == 'MR') {
            mrStock += quantityStrips.abs(); // Add to MR stock
          }
        } else if (txType == 'SALE_DIRECT_GODOWN') {
          // Sale directly from godown
          if (locationTypeSource == 'GODOWN') {
            godownStock += quantityStrips; // DB stores as negative for sales
          }
        } else if (txType == 'SALE_BY_MR') {
          // Sale by MR
          if (locationTypeSource == 'MR') {
            mrStock += quantityStrips; // DB stores as negative for sales
          }
        } else if (txType.contains('RETURN_TO_GODOWN')) {
          // Return to godown
          if (locationTypeDestination == 'GODOWN') {
            godownStock += quantityStrips; // Positive for godown
          }
          if (locationTypeSource == 'MR') {
            mrStock += quantityStrips; // Negative for MR source
          }
        } else if (txType.contains('ADJUST_') || txType.contains('OPENING_STOCK_')) {
          // Adjustments and opening stock
          if (txType.contains('_GODOWN') || locationTypeDestination == 'GODOWN') {
            godownStock += quantityStrips;
          } else if (txType.contains('_MR') || locationTypeDestination == 'MR') {
            mrStock += quantityStrips;
          }
        }
      }

      return {
        'godownStock': godownStock > 0 ? godownStock : 0,
        'mrStock': mrStock > 0 ? mrStock : 0,
      };
    } catch (e) {
      return {
        'godownStock': 0,
        'mrStock': 0,
      };
    }
  }
}