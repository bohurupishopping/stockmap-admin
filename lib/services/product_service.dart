import 'package:flutter/foundation.dart';
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
      // Build the main query
      dynamic query = _supabase
          .from('products')
          .select('''
            *,
            product_categories(category_name),
            product_sub_categories(sub_category_name),
            product_formulations(formulation_name)
          ''');

      // Apply filters to main query
       if (filters != null) {
         // Search filter
         if (filters.searchQuery?.isNotEmpty == true) {
           final searchFilter = 'product_name.ilike.%${filters.searchQuery}%,'
               'product_code.ilike.%${filters.searchQuery}%,'
               'generic_name.ilike.%${filters.searchQuery}%,'
               'manufacturer.ilike.%${filters.searchQuery}%';
           query = query.or(searchFilter);
         }

         // Category filter
         if (filters.categoryId?.isNotEmpty == true) {
           query = query.eq('category_id', filters.categoryId!);
         }

         // Sub-category filter
         if (filters.subCategoryId?.isNotEmpty == true) {
           query = query.eq('sub_category_id', filters.subCategoryId!);
         }

         // Formulation filter
         if (filters.formulationId?.isNotEmpty == true) {
           query = query.eq('formulation_id', filters.formulationId!);
         }

         // Manufacturer filter
         if (filters.manufacturer?.isNotEmpty == true) {
           query = query.eq('manufacturer', filters.manufacturer!);
         }

         // Active status filter
         if (filters.isActive != null) {
           query = query.eq('is_active', filters.isActive!);
         }

         // Cost range filters
         if (filters.minCost != null) {
           query = query.gte('base_cost_per_strip', filters.minCost!);
         }

         if (filters.maxCost != null) {
           query = query.lte('base_cost_per_strip', filters.maxCost!);
         }
       }

      // Apply sorting
      query = query.order(sortField, ascending: sortDirection == 'asc');

      // Apply pagination
      final offset = (page - 1) * limit;
      query = query.range(offset, offset + limit - 1);

      // Execute the main query
       final data = await query as List<dynamic>;
       
       // For total count, we'll use the length of current page data
       // In a real app, you might want to do a separate count query
       final totalCount = data.length + (page > 1 ? (page - 1) * limit : 0);

      final products = data.map((json) => Product.fromJson(json)).toList();
      
      // Fetch closing stock data for all products (optimized)
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
      
      // Fetch all required data in parallel for better performance
      final results = await Future.wait([
        // Fetch packaging units for box conversion
        _supabase
            .from('product_packaging_units')
            .select('product_id, unit_name, conversion_factor_to_strips')
            .inFilter('product_id', productIds)
            .eq('unit_name', 'Box'),
        
        // Fetch all transactions for these products in one query
        _supabase
            .from('stock_transactions_view')
            .select('''
              product_id,
              batch_id,
              transaction_type,
              quantity_strips,
              location_type_source,
              location_id_source,
              location_type_destination,
              location_id_destination,
              cost_per_strip_at_transaction
            ''')
            .inFilter('product_id', productIds)
            .order('transaction_date', ascending: true),
      ]);
      
      final packagingUnits = results[0] as List<dynamic>;
      final allTransactions = results[1] as List<dynamic>;
      
      // Create maps for quick lookup
      final packagingMap = <String, int>{};
      final transactionsByProduct = <String, List<Map<String, dynamic>>>{};
      
      // Process packaging units
      for (final unit in packagingUnits) {
        final productId = unit['product_id'] as String;
        final conversionFactor = (unit['conversion_factor_to_strips'] ?? 10) as int;
        packagingMap[productId] = conversionFactor;
      }
      
      // Group transactions by product
      for (final transaction in allTransactions) {
        final productId = transaction['product_id'] as String;
        transactionsByProduct.putIfAbsent(productId, () => []);
        transactionsByProduct[productId]!.add(transaction);
      }
      
      // Update products with calculated stock data
      for (int i = 0; i < products.length; i++) {
        final product = products[i];
        final productTransactions = transactionsByProduct[product.id] ?? [];
        
        // Calculate current stock from transactions
        final stockData = _calculateProductStockFromTransactions(productTransactions);
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
      // Log error for debugging
       debugPrint('Error enriching products with stock data: $e');
    }
  }

  /// Calculates current stock from a list of transactions
  /// Note: The stock_transactions_view already applies correct signs:
  /// - Positive for incoming stocks (purchases, returns, opening stock)
  /// - Negative for outgoing stocks (sales, dispatches, adjustments)
  static Map<String, int> _calculateProductStockFromTransactions(List<Map<String, dynamic>> transactions) {
    int godownStock = 0;
    int mrStock = 0;

    // Process each transaction to calculate current stock
    for (final transaction in transactions) {
      final txType = transaction['transaction_type'] as String;
      final quantityStrips = transaction['quantity_strips'] as int? ?? 0;
      final locationTypeSource = transaction['location_type_source'] as String?;
      final locationTypeDestination = transaction['location_type_destination'] as String?;

      // Process transaction based on type - following the TypeScript implementation logic
      if (txType == 'STOCK_IN_GODOWN' || txType == 'OPENING_STOCK_GODOWN') {
        // Stock coming into godown - ADD to godown (always positive from view)
        godownStock += quantityStrips;
      } else if (txType == 'DISPATCH_TO_MR') {
        // Dispatch from godown to MR (positive quantity in view)
        if (locationTypeSource == 'GODOWN') {
          // SUBTRACT from godown
          godownStock -= quantityStrips;
        }
        if (locationTypeDestination == 'MR') {
          // ADD to MR stock
          mrStock += quantityStrips;
        }
      } else if (txType == 'SALE_DIRECT_GODOWN') {
        // Sale directly from godown (negative quantity in view)
        if (locationTypeSource == 'GODOWN') {
          godownStock += quantityStrips; // Add negative quantity (subtract)
        }
      } else if (txType == 'SALE_BY_MR') {
        // Sale by MR (negative quantity in view)
        if (locationTypeSource == 'MR') {
          mrStock += quantityStrips; // Add negative quantity (subtract)
        }
      } else if (txType.contains('RETURN_TO_GODOWN')) {
        // Return to godown (positive quantity in view)
        if (locationTypeDestination == 'GODOWN') {
          // ADD to godown
          godownStock += quantityStrips;
        }
        if (locationTypeSource == 'MR') {
          // SUBTRACT from MR (view stores as negative for MR source)
          mrStock += quantityStrips;
        }
      } else if (txType.contains('REPLACEMENT_FROM_GODOWN')) {
        // Replacement from godown (negative quantity in view)
        if (locationTypeSource == 'GODOWN') {
          godownStock += quantityStrips; // Add negative quantity (subtract)
        }
      } else if (txType.contains('REPLACEMENT_FROM_MR')) {
        // Replacement from MR (negative quantity in view)
        if (locationTypeSource == 'MR') {
          mrStock += quantityStrips; // Add negative quantity (subtract)
        }
      } else if (txType.contains('ADJUST_DAMAGE_GODOWN') || 
                 txType.contains('ADJUST_LOSS_GODOWN') || 
                 txType.contains('ADJUST_EXPIRED_GODOWN')) {
        // Adjustments for damage/loss/expiry in godown (negative quantity in view)
        godownStock += quantityStrips; // Add negative quantity (subtract)
      } else if (txType.contains('ADJUST_DAMAGE_MR') || 
                 txType.contains('ADJUST_LOSS_MR') || 
                 txType.contains('ADJUST_EXPIRED_MR')) {
        // Adjustments for damage/loss/expiry in MR (negative quantity in view)
        mrStock += quantityStrips; // Add negative quantity (subtract)
      } else if (txType == 'OPENING_STOCK_MR') {
        // Opening stock for MR (positive quantity in view)
        if (locationTypeDestination == 'MR') {
          mrStock += quantityStrips;
        }
      }
    }

    return {
      'godownStock': godownStock > 0 ? godownStock : 0,
      'mrStock': mrStock > 0 ? mrStock : 0,
    };
  }
}