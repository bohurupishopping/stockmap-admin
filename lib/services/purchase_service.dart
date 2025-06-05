// ignore_for_file: deprecated_member_use

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/purchase_models.dart';

class PurchaseService {
  final _supabase = Supabase.instance.client;

  // Fetch purchase transactions
  Future<List<PurchaseTransaction>> fetchPurchases({
    PurchaseFilters? filters,
    String sortField = 'purchase_date',
    String sortDirection = 'desc',
    int page = 1,
    int limit = 20,
  }) async {
    try {
      var query = _supabase
          .from('stock_purchases')
          .select('''
            purchase_id,
            purchase_group_id,
            product_id,
            batch_id,
            quantity_strips,
            supplier_id,
            purchase_date,
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

      // Apply filters
      if (filters != null) {
        if (filters.productName != null && filters.productName!.isNotEmpty) {
          query = query.ilike('products.product_name', '%${filters.productName}%');
        }
        if (filters.batchNumber != null && filters.batchNumber!.isNotEmpty) {
          query = query.ilike('product_batches.batch_number', '%${filters.batchNumber}%');
        }
        if (filters.dateFrom != null) {
          query = query.gte('purchase_date', filters.dateFrom!.toIso8601String());
        }
        if (filters.dateTo != null) {
          query = query.lte('purchase_date', filters.dateTo!.toIso8601String());
        }
        if (filters.referenceDocumentId != null && filters.referenceDocumentId!.isNotEmpty) {
          query = query.ilike('reference_document_id', '%${filters.referenceDocumentId}%');
        }
        if (filters.createdBy != null && filters.createdBy!.isNotEmpty) {
          query = query.eq('created_by', filters.createdBy!);
        }
        if (filters.supplierName != null && filters.supplierName!.isNotEmpty) {
          query = query.ilike('supplier_id', '%${filters.supplierName}%');
        }
      }

      // Apply sorting and pagination
      final offset = (page - 1) * limit;
      final response = await query
          .order(sortField, ascending: sortDirection == 'asc')
          .range(offset, offset + limit - 1);
      
      return (response as List).map((purchase) {
        final productData = purchase['products'] as Map<String, dynamic>;
        final batchData = purchase['product_batches'] as Map<String, dynamic>;
        
        return PurchaseTransaction.fromJson({
          ...purchase,
          'product_name': productData['product_name'],
          'product_code': productData['product_code'],
          'generic_name': productData['generic_name'],
          'batch_number': batchData['batch_number'],
          'expiry_date': batchData['expiry_date'],
          'supplier_name': purchase['supplier_id'] ?? 'Unknown Supplier',
        });
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch purchases: $e');
    }
  }

  // Get purchase summary
  Future<PurchaseSummary> getPurchaseSummary({
    PurchaseFilters? filters,
  }) async {
    try {
      var query = _supabase
          .from('stock_purchases')
          .select('''
            purchase_id,
            quantity_strips,
            cost_per_strip,
            purchase_date,
            products!inner(
              product_name
            ),
            product_batches!inner(
              batch_number
            )

          ''');

      // Apply same filters as main query
      if (filters != null) {
        if (filters.productName != null && filters.productName!.isNotEmpty) {
          query = query.ilike('products.product_name', '%${filters.productName}%');
        }
        if (filters.batchNumber != null && filters.batchNumber!.isNotEmpty) {
          query = query.ilike('product_batches.batch_number', '%${filters.batchNumber}%');
        }
        if (filters.dateFrom != null) {
          query = query.gte('purchase_date', filters.dateFrom!.toIso8601String());
        }
        if (filters.dateTo != null) {
          query = query.lte('purchase_date', filters.dateTo!.toIso8601String());
        }
        if (filters.referenceDocumentId != null && filters.referenceDocumentId!.isNotEmpty) {
          query = query.ilike('reference_document_id', '%${filters.referenceDocumentId}%');
        }
        if (filters.createdBy != null && filters.createdBy!.isNotEmpty) {
          query = query.eq('created_by', filters.createdBy!);
        }
        if (filters.supplierName != null && filters.supplierName!.isNotEmpty) {
          query = query.ilike('supplier_id', '%${filters.supplierName}%');
        }
      }

      final response = await query;
      final purchases = response as List;

      if (purchases.isEmpty) {
        return PurchaseSummary(
          totalTransactions: 0,
          totalAmount: 0.0,
          totalQuantity: 0,
        );
      }

      double totalAmount = 0.0;
      int totalQuantity = 0;
      DateTime? lastPurchaseDate;

      for (final purchase in purchases) {
        final quantity = (purchase['quantity_strips'] ?? 0) as int;
        final cost = (purchase['cost_per_strip'] ?? 0.0).toDouble();
        totalAmount += quantity * cost;
        totalQuantity += quantity;

        final purchaseDate = DateTime.parse(purchase['purchase_date']);
        if (lastPurchaseDate == null || purchaseDate.isAfter(lastPurchaseDate)) {
          lastPurchaseDate = purchaseDate;
        }
      }

      return PurchaseSummary(
        totalTransactions: purchases.length,
        totalAmount: totalAmount,
        totalQuantity: totalQuantity,
        lastPurchaseDate: lastPurchaseDate,
      );
    } catch (e) {
      throw Exception('Failed to fetch purchase summary: $e');
    }
  }

  // Get total count for pagination
  Future<int> getPurchaseCount({
    PurchaseFilters? filters,
  }) async {
    try {
      var countQuery = _supabase
          .from('stock_purchases')
          .select('purchase_id');

      // Apply same filters to count query
      if (filters != null) {
        if (filters.productName != null && filters.productName!.isNotEmpty) {
          countQuery = countQuery.ilike('products.product_name', '%${filters.productName}%');
        }
        if (filters.batchNumber != null && filters.batchNumber!.isNotEmpty) {
          countQuery = countQuery.ilike('product_batches.batch_number', '%${filters.batchNumber}%');
        }
        if (filters.dateFrom != null) {
          countQuery = countQuery.gte('purchase_date', filters.dateFrom!.toIso8601String());
        }
        if (filters.dateTo != null) {
          countQuery = countQuery.lte('purchase_date', filters.dateTo!.toIso8601String());
        }
        if (filters.referenceDocumentId != null && filters.referenceDocumentId!.isNotEmpty) {
          countQuery = countQuery.ilike('reference_document_id', '%${filters.referenceDocumentId}%');
        }
        if (filters.createdBy != null && filters.createdBy!.isNotEmpty) {
          countQuery = countQuery.eq('created_by', filters.createdBy!);
        }
        if (filters.supplierName != null && filters.supplierName!.isNotEmpty) {
          countQuery = countQuery.ilike('supplier_id', '%${filters.supplierName}%');
        }
      }

      final response = await countQuery;
      return response.length;
    } catch (e) {
      throw Exception('Failed to fetch purchase count: $e');
    }
  }
}