import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/mr_sale_models.dart';

class MRSaleService {
  final _supabase = Supabase.instance.client;

  // Fetch MR sales orders
  Future<List<MRSalesOrder>> fetchMRSales({
    String? searchQuery,
    MRSalesFilters? filters,
    String sortField = 'order_date',
    String sortDirection = 'desc',
    int page = 1,
    int limit = 20,
  }) async {
    try {
      var query = _supabase
          .from('mr_sales_orders')
          .select('''
            id,
            mr_user_id,
            customer_name,
            order_date,
            total_amount,
            payment_status,
            notes,
            created_at,
            updated_at,
            profiles!mr_sales_orders_mr_user_id_fkey(
              name
            ),
            mr_sales_order_items(
              id,
              product_id,
              batch_id,
              quantity_strips_sold,
              price_per_strip,
              line_item_total,
              created_at,
              products(
                product_name,
                product_code
              ),
              product_batches(
                batch_number,
                expiry_date
              )
            )
          ''');

      // Apply search query
      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.or('customer_name.ilike.%$searchQuery%,profiles.name.ilike.%$searchQuery%');
      }

      // Apply filters
      if (filters != null) {
        if (filters.customerName != null && filters.customerName!.isNotEmpty) {
          query = query.ilike('customer_name', '%${filters.customerName}%');
        }
        if (filters.mrUserId != null && filters.mrUserId!.isNotEmpty) {
          query = query.eq('mr_user_id', filters.mrUserId!);
        }
        if (filters.paymentStatus != null && filters.paymentStatus!.isNotEmpty) {
          query = query.eq('payment_status', filters.paymentStatus!);
        }
        if (filters.dateFrom != null) {
          query = query.gte('order_date', filters.dateFrom!.toIso8601String());
        }
        if (filters.dateTo != null) {
          query = query.lte('order_date', filters.dateTo!.toIso8601String());
        }
        if (filters.minAmount != null) {
          query = query.gte('total_amount', filters.minAmount!);
        }
        if (filters.maxAmount != null) {
          query = query.lte('total_amount', filters.maxAmount!);
        }
      }

      // Apply sorting and pagination
      final offset = (page - 1) * limit;
      final response = await query
          .order(sortField, ascending: sortDirection == 'asc')
          .range(offset, offset + limit - 1);
      
      return (response as List).map((order) {
        final profileData = order['profiles'] as Map<String, dynamic>?;
        
        return MRSalesOrder.fromJson({
          ...order,
          'mr_user_name': profileData?['name'],
        });
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch MR sales: $e');
    }
  }

  // Fetch single MR sales order with details
  Future<MRSalesOrder?> fetchMRSalesOrderById(String orderId) async {
    try {
      final response = await _supabase
          .from('mr_sales_orders')
          .select('''
            id,
            mr_user_id,
            customer_name,
            order_date,
            total_amount,
            payment_status,
            notes,
            created_at,
            updated_at,
            profiles!mr_sales_orders_mr_user_id_fkey(
              name
            ),
            mr_sales_order_items(
              id,
              product_id,
              batch_id,
              quantity_strips_sold,
              price_per_strip,
              line_item_total,
              created_at,
              products(
                product_name,
                product_code
              ),
              product_batches(
                batch_number,
                expiry_date
              )
            )
          ''')
          .eq('id', orderId)
          .single();

      final profileData = response['profiles'] as Map<String, dynamic>?;
      
      return MRSalesOrder.fromJson({
        ...response,
        'mr_user_name': profileData?['name'],
      });
    } catch (e) {
      throw Exception('Failed to fetch MR sales order: $e');
    }
  }

  // Get MR sales summary/statistics
  Future<Map<String, dynamic>> getMRSalesSummary({
    DateTime? dateFrom,
    DateTime? dateTo,
    String? mrUserId,
  }) async {
    try {
      var query = _supabase
          .from('mr_sales_orders')
          .select('total_amount, payment_status, order_date');

      if (dateFrom != null) {
        query = query.gte('order_date', dateFrom.toIso8601String());
      }
      if (dateTo != null) {
        query = query.lte('order_date', dateTo.toIso8601String());
      }
      if (mrUserId != null) {
        query = query.eq('mr_user_id', mrUserId);
      }

      final response = await query;
      final orders = response as List;

      double totalSales = 0;
      double paidAmount = 0;
      double pendingAmount = 0;
      int totalOrders = orders.length;
      int paidOrders = 0;
      int pendingOrders = 0;

      for (final order in orders) {
        final amount = (order['total_amount'] ?? 0.0).toDouble();
        final status = order['payment_status'] ?? 'Pending';
        
        totalSales += amount;
        
        if (status.toLowerCase() == 'paid') {
          paidAmount += amount;
          paidOrders++;
        } else {
          pendingAmount += amount;
          pendingOrders++;
        }
      }

      return {
        'total_sales': totalSales,
        'paid_amount': paidAmount,
        'pending_amount': pendingAmount,
        'total_orders': totalOrders,
        'paid_orders': paidOrders,
        'pending_orders': pendingOrders,
        'collection_percentage': totalSales > 0 ? (paidAmount / totalSales) * 100 : 0,
      };
    } catch (e) {
      throw Exception('Failed to fetch MR sales summary: $e');
    }
  }

  // Get list of MR users for filtering
  Future<List<Map<String, dynamic>>> getMRUsers() async {
    try {
      final response = await _supabase
          .from('profiles')
          .select('user_id, name')
        .eq('role', 'mr')
        .order('name');

      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to fetch MR users: $e');
    }
  }

  // Update payment status
  Future<void> updatePaymentStatus(String orderId, String paymentStatus) async {
    try {
      await _supabase
          .from('mr_sales_orders')
          .update({
            'payment_status': paymentStatus,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', orderId);
    } catch (e) {
      throw Exception('Failed to update payment status: $e');
    }
  }
}