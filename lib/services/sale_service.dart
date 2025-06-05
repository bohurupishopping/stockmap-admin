import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/sale_models.dart';

class SaleService {
  final _supabase = Supabase.instance.client;

  // Fetch sale transactions
  Future<List<SaleTransaction>> fetchSales({
    String? searchQuery,
    SaleFilters? filters,
    String sortField = 'sale_date',
    String sortDirection = 'desc',
    int page = 1,
    int limit = 20,
  }) async {
    try {
      var query = _supabase
          .from('stock_sales')
          .select('''
            sale_id,
            sale_group_id,
            product_id,
            batch_id,
            transaction_type,
            quantity_strips,
            location_type_source,
            location_id_source,
            location_type_destination,
            location_id_destination,
            sale_date,
            reference_document_id,
            cost_per_strip,
            notes,
            created_by,
            created_at,
            products!inner(
              product_name,
              product_code,
              generic_name
            ),
            product_batches!inner(
              batch_number,
              expiry_date
            )
          ''');

      // Apply search query
      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.or('products.product_name.ilike.%$searchQuery%,products.product_code.ilike.%$searchQuery%,product_batches.batch_number.ilike.%$searchQuery%');
      }

      // Apply filters
      if (filters != null) {
        if (filters.productName != null && filters.productName!.isNotEmpty) {
          query = query.ilike('products.product_name', '%${filters.productName}%');
        }
        if (filters.batchNumber != null && filters.batchNumber!.isNotEmpty) {
          query = query.ilike('product_batches.batch_number', '%${filters.batchNumber}%');
        }
        if (filters.dateFrom != null) {
          query = query.gte('sale_date', filters.dateFrom!.toIso8601String());
        }
        if (filters.dateTo != null) {
          query = query.lte('sale_date', filters.dateTo!.toIso8601String());
        }
        if (filters.transactionType != null && filters.transactionType!.isNotEmpty) {
          query = query.eq('transaction_type', filters.transactionType!);
        }
        if (filters.referenceDocumentId != null && filters.referenceDocumentId!.isNotEmpty) {
          query = query.ilike('reference_document_id', '%${filters.referenceDocumentId}%');
        }
        if (filters.createdBy != null && filters.createdBy!.isNotEmpty) {
          query = query.eq('created_by', filters.createdBy!);
        }
      }

      // Apply sorting and pagination
      final offset = (page - 1) * limit;
      final response = await query
          .order(sortField, ascending: sortDirection == 'asc')
          .range(offset, offset + limit - 1);
      
      return (response as List).map((sale) {
        final productData = sale['products'] as Map<String, dynamic>;
        final batchData = sale['product_batches'] as Map<String, dynamic>;
        
        return SaleTransaction.fromJson({
          ...sale,
          'product_name': productData['product_name'],
          'product_code': productData['product_code'],
          'generic_name': productData['generic_name'],
          'batch_number': batchData['batch_number'],
          'expiry_date': batchData['expiry_date'],
        });
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch sales: $e');
    }
  }

  // Get sale summary
  Future<SaleSummary> getSaleSummary({
    String? searchQuery,
    SaleFilters? filters,
  }) async {
    try {
      var query = _supabase
          .from('stock_sales')
          .select('''
            sale_id,
            quantity_strips,
            cost_per_strip,
            sale_date,
            products!inner(
              product_name,
              product_code
            ),
            product_batches!inner(
              batch_number
            )
          ''');

      // Apply search query
      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.or('products.product_name.ilike.%$searchQuery%,products.product_code.ilike.%$searchQuery%,product_batches.batch_number.ilike.%$searchQuery%');
      }

      // Apply the same filters as in fetchSales
      if (filters != null) {
        if (filters.productName != null && filters.productName!.isNotEmpty) {
          query = query.ilike('products.product_name', '%${filters.productName}%');
        }
        if (filters.batchNumber != null && filters.batchNumber!.isNotEmpty) {
          query = query.ilike('product_batches.batch_number', '%${filters.batchNumber}%');
        }
        if (filters.dateFrom != null) {
          query = query.gte('sale_date', filters.dateFrom!.toIso8601String());
        }
        if (filters.dateTo != null) {
          query = query.lte('sale_date', filters.dateTo!.toIso8601String());
        }
        if (filters.transactionType != null && filters.transactionType!.isNotEmpty) {
          query = query.eq('transaction_type', filters.transactionType!);
        }
        if (filters.referenceDocumentId != null && filters.referenceDocumentId!.isNotEmpty) {
          query = query.ilike('reference_document_id', '%${filters.referenceDocumentId}%');
        }
        if (filters.createdBy != null && filters.createdBy!.isNotEmpty) {
          query = query.eq('created_by', filters.createdBy!);
        }
      }

      final response = await query;
      final sales = response as List;

      if (sales.isEmpty) {
        return SaleSummary(
          totalTransactions: 0,
          totalAmount: 0.0,
          totalQuantity: 0,
          lastSaleDate: null,
        );
      }

      // Calculate summary
      int totalTransactions = sales.length;
      double totalAmount = 0.0;
      int totalQuantity = 0;
      DateTime? lastSaleDate;

      for (final sale in sales) {
        final quantity = (sale['quantity_strips'] ?? 0) as int;
        final costPerStrip = (sale['cost_per_strip'] ?? 0.0).toDouble();
        
        totalQuantity += quantity;
        totalAmount += quantity * costPerStrip;
        
        final saleDate = DateTime.parse(sale['sale_date']);
        if (lastSaleDate == null || saleDate.isAfter(lastSaleDate)) {
          lastSaleDate = saleDate;
        }
      }

      return SaleSummary(
        totalTransactions: totalTransactions,
        totalAmount: totalAmount,
        totalQuantity: totalQuantity,
        lastSaleDate: lastSaleDate,
      );
    } catch (e) {
      throw Exception('Failed to get sale summary: $e');
    }
  }

  // Get sale transaction by ID
  Future<SaleTransaction?> getSaleById(String saleId) async {
    try {
      final response = await _supabase
          .from('stock_sales')
          .select('''
            sale_id,
            sale_group_id,
            product_id,
            batch_id,
            transaction_type,
            quantity_strips,
            location_type_source,
            location_id_source,
            location_type_destination,
            location_id_destination,
            sale_date,
            reference_document_id,
            cost_per_strip,
            notes,
            created_by,
            created_at,
            products!inner(
              product_name,
              product_code,
              generic_name
            ),
            product_batches!inner(
              batch_number,
              expiry_date
            )
          ''')
          .eq('sale_id', saleId)
          .single();

      final productData = response['products'] as Map<String, dynamic>;
      final batchData = response['product_batches'] as Map<String, dynamic>;
      
      return SaleTransaction.fromJson({
        ...response,
        'product_name': productData['product_name'],
        'product_code': productData['product_code'],
        'generic_name': productData['generic_name'],
        'batch_number': batchData['batch_number'],
        'expiry_date': batchData['expiry_date'],
      });
    } catch (e) {
      throw Exception('Failed to fetch sale: $e');
    }
  }
}