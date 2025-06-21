import 'package:flutter/material.dart';

class MRSalesOrder {
  final String id;
  final String mrUserId;
  final String customerName;
  final String? customerPhone;
  final String? customerAddress;
  final DateTime orderDate;
  final double totalAmount;
  final double paidAmount;
  final String paymentStatus;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<MRSalesOrderItem>? items;
  final String? mrUserName; // For display purposes

  // Getter for orderId (alias for id)
  String get orderId => id;

  MRSalesOrder({
    required this.id,
    required this.mrUserId,
    required this.customerName,
    this.customerPhone,
    this.customerAddress,
    required this.orderDate,
    required this.totalAmount,
    required this.paidAmount,
    required this.paymentStatus,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.items,
    this.mrUserName,
  });

  factory MRSalesOrder.fromJson(Map<String, dynamic> json) {
    return MRSalesOrder(
      id: json['id'] ?? '',
      mrUserId: json['mr_user_id'] ?? '',
      customerName: json['customer_name'] ?? '',
      customerPhone: json['customer_phone'],
      customerAddress: json['customer_address'],
      orderDate: DateTime.parse(json['order_date'] ?? DateTime.now().toIso8601String()),
      totalAmount: (json['total_amount'] ?? 0.0).toDouble(),
      paidAmount: (json['paid_amount'] ?? 0.0).toDouble(),
      paymentStatus: json['payment_status'] ?? 'pending',
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      items: json['mr_sales_order_items'] != null
          ? (json['mr_sales_order_items'] as List)
              .map((item) => MRSalesOrderItem.fromJson(item))
              .toList()
          : null,
      mrUserName: json['profiles']?['name'] ?? json['mr_user_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mr_user_id': mrUserId,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'customer_address': customerAddress,
      'order_date': orderDate.toIso8601String(),
      'total_amount': totalAmount,
      'paid_amount': paidAmount,
      'payment_status': paymentStatus,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Color get paymentStatusColor {
    switch (paymentStatus.toLowerCase()) {
      case 'paid':
        return const Color(0xFF059669); // Green
      case 'pending':
        return const Color(0xFFF59E0B); // Yellow
      case 'partial':
        return const Color(0xFFF59E0B); // Yellow
      case 'overdue':
        return const Color(0xFFDC2626); // Red
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }

  String get paymentStatusDisplay {
    switch (paymentStatus.toLowerCase()) {
      case 'paid':
        return 'Paid';
      case 'pending':
        return 'Pending';
      case 'partial':
        return 'Partial';
      case 'overdue':
        return 'Overdue';
      default:
        return paymentStatus;
    }
  }
}

class MRSalesOrderItem {
  final String id;
  final String orderId;
  final String productId;
  final String batchId;
  final int quantityStripsSold;
  final double pricePerStrip;
  final double lineItemTotal;
  final DateTime createdAt;
  final String? productName;
  final String? productCode;
  final String? batchNumber;
  final DateTime? expiryDate;

  // Getters for compatibility
  int get quantity => quantityStripsSold;
  double get unitPrice => pricePerStrip;
  double get totalPrice => lineItemTotal;

  MRSalesOrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.batchId,
    required this.quantityStripsSold,
    required this.pricePerStrip,
    required this.lineItemTotal,
    required this.createdAt,
    this.productName,
    this.productCode,
    this.batchNumber,
    this.expiryDate,
  });

  factory MRSalesOrderItem.fromJson(Map<String, dynamic> json) {
    return MRSalesOrderItem(
      id: json['id'] ?? '',
      orderId: json['order_id'] ?? '',
      productId: json['product_id'] ?? '',
      batchId: json['batch_id'] ?? '',
      quantityStripsSold: json['quantity_strips_sold'] ?? 0,
      pricePerStrip: (json['price_per_strip'] ?? 0.0).toDouble(),
      lineItemTotal: (json['line_item_total'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      productName: json['products']?['product_name'] ?? json['product_name'],
      productCode: json['products']?['product_code'] ?? json['product_code'],
      batchNumber: json['product_batches']?['batch_number'] ?? json['batch_number'],
      expiryDate: json['product_batches']?['expiry_date'] != null
          ? DateTime.parse(json['product_batches']['expiry_date'])
          : (json['expiry_date'] != null ? DateTime.parse(json['expiry_date']) : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'batch_id': batchId,
      'quantity_strips_sold': quantityStripsSold,
      'price_per_strip': pricePerStrip,
      'line_item_total': lineItemTotal,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class MRSalesFilters {
  final String? customerName;
  final String? mrUserId;
  final String? paymentStatus;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? productName;
  final double? minAmount;
  final double? maxAmount;

  MRSalesFilters({
    this.customerName,
    this.mrUserId,
    this.paymentStatus,
    this.dateFrom,
    this.dateTo,
    this.productName,
    this.minAmount,
    this.maxAmount,
  });

  bool get hasActiveFilters {
    return customerName?.isNotEmpty == true ||
        mrUserId?.isNotEmpty == true ||
        paymentStatus?.isNotEmpty == true ||
        dateFrom != null ||
        dateTo != null ||
        productName?.isNotEmpty == true ||
        minAmount != null ||
        maxAmount != null;
  }

  MRSalesFilters copyWith({
    String? customerName,
    String? mrUserId,
    String? paymentStatus,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? productName,
    double? minAmount,
    double? maxAmount,
  }) {
    return MRSalesFilters(
      customerName: customerName ?? this.customerName,
      mrUserId: mrUserId ?? this.mrUserId,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      productName: productName ?? this.productName,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
    );
  }

  MRSalesFilters clear() {
    return MRSalesFilters();
  }
}