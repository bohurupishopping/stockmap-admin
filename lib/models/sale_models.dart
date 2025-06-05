
class SaleTransaction {
  final String saleId;
  final String? saleGroupId;
  final String productId;
  final String productName;
  final String productCode;
  final String? genericName;
  final String batchId;
  final String batchNumber;
  final DateTime expiryDate;
  final String transactionType;
  final int quantityStrips;
  final String? locationTypeSource;
  final String? locationIdSource;
  final String? locationTypeDestination;
  final String? locationIdDestination;
  final DateTime saleDate;
  final String? referenceDocumentId;
  final double costPerStrip;
  final String? notes;
  final String? createdBy;
  final DateTime createdAt;

  SaleTransaction({
    required this.saleId,
    this.saleGroupId,
    required this.productId,
    required this.productName,
    required this.productCode,
    this.genericName,
    required this.batchId,
    required this.batchNumber,
    required this.expiryDate,
    required this.transactionType,
    required this.quantityStrips,
    this.locationTypeSource,
    this.locationIdSource,
    this.locationTypeDestination,
    this.locationIdDestination,
    required this.saleDate,
    this.referenceDocumentId,
    required this.costPerStrip,
    this.notes,
    this.createdBy,
    required this.createdAt,
  });

  factory SaleTransaction.fromJson(Map<String, dynamic> json) {
    return SaleTransaction(
      saleId: json['sale_id'] ?? '',
      saleGroupId: json['sale_group_id'],
      productId: json['product_id'] ?? '',
      productName: json['product_name'] ?? '',
      productCode: json['product_code'] ?? '',
      genericName: json['generic_name'],
      batchId: json['batch_id'] ?? '',
      batchNumber: json['batch_number'] ?? '',
      expiryDate: DateTime.parse(json['expiry_date'] ?? DateTime.now().toIso8601String()),
      transactionType: json['transaction_type'] ?? '',
      quantityStrips: json['quantity_strips'] ?? 0,
      locationTypeSource: json['location_type_source'],
      locationIdSource: json['location_id_source'],
      locationTypeDestination: json['location_type_destination'],
      locationIdDestination: json['location_id_destination'],
      saleDate: DateTime.parse(json['sale_date'] ?? DateTime.now().toIso8601String()),
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
      'sale_id': saleId,
      'sale_group_id': saleGroupId,
      'product_id': productId,
      'product_name': productName,
      'product_code': productCode,
      'generic_name': genericName,
      'batch_id': batchId,
      'batch_number': batchNumber,
      'expiry_date': expiryDate.toIso8601String(),
      'transaction_type': transactionType,
      'quantity_strips': quantityStrips,
      'location_type_source': locationTypeSource,
      'location_id_source': locationIdSource,
      'location_type_destination': locationTypeDestination,
      'location_id_destination': locationIdDestination,
      'sale_date': saleDate.toIso8601String(),
      'reference_document_id': referenceDocumentId,
      'cost_per_strip': costPerStrip,
      'notes': notes,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class SaleFilters {
  final String? productName;
  final String? batchNumber;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? referenceDocumentId;
  final String? createdBy;
  final String? transactionType;

  SaleFilters({
    this.productName,
    this.batchNumber,
    this.dateFrom,
    this.dateTo,
    this.referenceDocumentId,
    this.createdBy,
    this.transactionType,
  });

  bool get hasActiveFilters =>
      productName?.isNotEmpty == true ||
      batchNumber?.isNotEmpty == true ||
      dateFrom != null ||
      dateTo != null ||
      referenceDocumentId?.isNotEmpty == true ||
      createdBy?.isNotEmpty == true ||
      transactionType?.isNotEmpty == true;
}

class SaleSummary {
  final int totalTransactions;
  final double totalAmount;
  final int totalQuantity;
  final DateTime? lastSaleDate;

  SaleSummary({
    required this.totalTransactions,
    required this.totalAmount,
    required this.totalQuantity,
    this.lastSaleDate,
  });

  factory SaleSummary.fromJson(Map<String, dynamic> json) {
    return SaleSummary(
      totalTransactions: json['total_transactions'] ?? 0,
      totalAmount: (json['total_amount'] ?? 0.0).toDouble(),
      totalQuantity: json['total_quantity'] ?? 0,
      lastSaleDate: json['last_sale_date'] != null
          ? DateTime.parse(json['last_sale_date'])
          : null,
    );
  }
}