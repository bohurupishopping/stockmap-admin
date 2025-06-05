// ignore_for_file: deprecated_member_use

class PurchaseTransaction {
  final String purchaseId;
  final String? purchaseGroupId;
  final String productId;
  final String productName;
  final String productCode;
  final String? genericName;
  final String batchId;
  final String batchNumber;
  final DateTime expiryDate;
  final int quantityStrips;
  final String supplierId;
  final String? supplierName;
  final DateTime purchaseDate;
  final String? referenceDocumentId;
  final double costPerStrip;
  final String? notes;
  final String? createdBy;
  final DateTime createdAt;

  PurchaseTransaction({
    required this.purchaseId,
    this.purchaseGroupId,
    required this.productId,
    required this.productName,
    required this.productCode,
    this.genericName,
    required this.batchId,
    required this.batchNumber,
    required this.expiryDate,
    required this.quantityStrips,
    required this.supplierId,
    this.supplierName,
    required this.purchaseDate,
    this.referenceDocumentId,
    required this.costPerStrip,
    this.notes,
    this.createdBy,
    required this.createdAt,
  });

  factory PurchaseTransaction.fromJson(Map<String, dynamic> json) {
    return PurchaseTransaction(
      purchaseId: json['purchase_id'] ?? '',
      purchaseGroupId: json['purchase_group_id'],
      productId: json['product_id'] ?? '',
      productName: json['product_name'] ?? '',
      productCode: json['product_code'] ?? '',
      genericName: json['generic_name'],
      batchId: json['batch_id'] ?? '',
      batchNumber: json['batch_number'] ?? '',
      expiryDate: DateTime.parse(json['expiry_date'] ?? DateTime.now().toIso8601String()),
      quantityStrips: json['quantity_strips'] ?? 0,
      supplierId: json['supplier_id'] ?? '',
      supplierName: json['supplier_name'],
      purchaseDate: DateTime.parse(json['purchase_date'] ?? DateTime.now().toIso8601String()),
      referenceDocumentId: json['reference_document_id'],
      costPerStrip: (json['cost_per_strip'] ?? 0.0).toDouble(),
      notes: json['notes'],
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  double get totalValue => quantityStrips * costPerStrip;

  Map<String, dynamic> toJson() {
    return {
      'purchase_id': purchaseId,
      'purchase_group_id': purchaseGroupId,
      'product_id': productId,
      'product_name': productName,
      'product_code': productCode,
      'generic_name': genericName,
      'batch_id': batchId,
      'batch_number': batchNumber,
      'expiry_date': expiryDate.toIso8601String(),
      'quantity_strips': quantityStrips,
      'supplier_id': supplierId,
      'supplier_name': supplierName,
      'purchase_date': purchaseDate.toIso8601String(),
      'reference_document_id': referenceDocumentId,
      'cost_per_strip': costPerStrip,
      'notes': notes,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class PurchaseFilters {
  final String? productName;
  final String? batchNumber;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? referenceDocumentId;
  final String? createdBy;
  final String? supplierName;

  PurchaseFilters({
    this.productName,
    this.batchNumber,
    this.dateFrom,
    this.dateTo,
    this.referenceDocumentId,
    this.createdBy,
    this.supplierName,
  });

  bool get hasActiveFilters =>
      productName?.isNotEmpty == true ||
      batchNumber?.isNotEmpty == true ||
      dateFrom != null ||
      dateTo != null ||
      referenceDocumentId?.isNotEmpty == true ||
      createdBy?.isNotEmpty == true ||
      supplierName?.isNotEmpty == true;
}

class PurchaseSummary {
  final int totalTransactions;
  final double totalAmount;
  final int totalQuantity;
  final DateTime? lastPurchaseDate;

  PurchaseSummary({
    required this.totalTransactions,
    required this.totalAmount,
    required this.totalQuantity,
    this.lastPurchaseDate,
  });

  factory PurchaseSummary.fromJson(Map<String, dynamic> json) {
    return PurchaseSummary(
      totalTransactions: json['total_transactions'] ?? 0,
      totalAmount: (json['total_amount'] ?? 0.0).toDouble(),
      totalQuantity: json['total_quantity'] ?? 0,
      lastPurchaseDate: json['last_purchase_date'] != null
          ? DateTime.parse(json['last_purchase_date'])
          : null,
    );
  }
}