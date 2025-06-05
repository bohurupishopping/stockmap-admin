class Product {
  final String id;
  final String productCode;
  final String productName;
  final String genericName;
  final String manufacturer;
  final String categoryId;
  final String? subCategoryId;
  final String formulationId;
  final String unitOfMeasureSmallest;
  final double baseCostPerStrip;
  final bool isActive;
  final String? storageConditions;
  final String? imageUrl;
  final int minStockLevelGodown;
  final int minStockLevelMr;
  final int leadTimeDays;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? categoryName;
  final String? subCategoryName;
  final String? formulationName;
  final int closingStockGodown;
  final int closingStockMr;
  final int stripsPerBox;

  Product({
    required this.id,
    required this.productCode,
    required this.productName,
    required this.genericName,
    required this.manufacturer,
    required this.categoryId,
    this.subCategoryId,
    required this.formulationId,
    required this.unitOfMeasureSmallest,
    required this.baseCostPerStrip,
    required this.isActive,
    this.storageConditions,
    this.imageUrl,
    required this.minStockLevelGodown,
    required this.minStockLevelMr,
    required this.leadTimeDays,
    required this.createdAt,
    required this.updatedAt,
    this.categoryName,
    this.subCategoryName,
    this.formulationName,
    this.closingStockGodown = 0,
    this.closingStockMr = 0,
    this.stripsPerBox = 10,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      productCode: json['product_code'] ?? '',
      productName: json['product_name'] ?? '',
      genericName: json['generic_name'] ?? '',
      manufacturer: json['manufacturer'] ?? '',
      categoryId: json['category_id'] ?? '',
      subCategoryId: json['sub_category_id'],
      formulationId: json['formulation_id'] ?? '',
      unitOfMeasureSmallest: json['unit_of_measure_smallest'] ?? 'Strip',
      baseCostPerStrip: (json['base_cost_per_strip'] ?? 0.0).toDouble(),
      isActive: json['is_active'] ?? true,
      storageConditions: json['storage_conditions'],
      imageUrl: json['image_url'],
      minStockLevelGodown: json['min_stock_level_godown'] ?? 0,
      minStockLevelMr: json['min_stock_level_mr'] ?? 0,
      leadTimeDays: json['lead_time_days'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      categoryName: json['product_categories']?['category_name'] ?? json['category_name'],
      subCategoryName: json['product_sub_categories']?['sub_category_name'] ?? json['sub_category_name'],
      formulationName: json['product_formulations']?['formulation_name'] ?? json['formulation_name'],
      closingStockGodown: json['closing_stock_godown'] ?? 0,
      closingStockMr: json['closing_stock_mr'] ?? 0,
      stripsPerBox: json['strips_per_box'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_code': productCode,
      'product_name': productName,
      'generic_name': genericName,
      'manufacturer': manufacturer,
      'category_id': categoryId,
      'sub_category_id': subCategoryId,
      'formulation_id': formulationId,
      'unit_of_measure_smallest': unitOfMeasureSmallest,
      'base_cost_per_strip': baseCostPerStrip,
      'is_active': isActive,
      'storage_conditions': storageConditions,
      'image_url': imageUrl,
      'min_stock_level_godown': minStockLevelGodown,
      'min_stock_level_mr': minStockLevelMr,
      'lead_time_days': leadTimeDays,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'closing_stock_godown': closingStockGodown,
      'closing_stock_mr': closingStockMr,
      'strips_per_box': stripsPerBox,
    };
  }

  // Helper methods for stock calculations
  String getFormattedStock(int strips) {
    if (strips == 0) return '0 strips';
    
    final boxes = strips ~/ stripsPerBox;
    final remainingStrips = strips % stripsPerBox;
    
    if (boxes == 0) {
      return '$strips strips';
    } else if (remainingStrips == 0) {
      return '$boxes ${boxes == 1 ? 'box' : 'boxes'}';
    } else {
      return '$boxes ${boxes == 1 ? 'box' : 'boxes'} + $remainingStrips strips';
    }
  }

  String get formattedGodownStock => getFormattedStock(closingStockGodown);
  String get formattedMrStock => getFormattedStock(closingStockMr);
  String get formattedTotalStock => getFormattedStock(closingStockGodown + closingStockMr);
  
  int get totalClosingStock => closingStockGodown + closingStockMr;
}

class ProductFilters {
  String? searchQuery;
  String? categoryId;
  String? subCategoryId;
  String? formulationId;
  String? manufacturer;
  bool? isActive;
  double? minCost;
  double? maxCost;
  String? stockStatus;

  ProductFilters({
    this.searchQuery,
    this.categoryId,
    this.subCategoryId,
    this.formulationId,
    this.manufacturer,
    this.isActive,
    this.minCost,
    this.maxCost,
    this.stockStatus,
  });

  bool get hasActiveFilters {
    return searchQuery?.isNotEmpty == true ||
        categoryId?.isNotEmpty == true ||
        subCategoryId?.isNotEmpty == true ||
        formulationId?.isNotEmpty == true ||
        manufacturer?.isNotEmpty == true ||
        isActive != null ||
        minCost != null ||
        maxCost != null ||
        stockStatus?.isNotEmpty == true;
  }

  void clear() {
    searchQuery = null;
    categoryId = null;
    subCategoryId = null;
    formulationId = null;
    manufacturer = null;
    isActive = null;
    minCost = null;
    maxCost = null;
    stockStatus = null;
  }
}

class ProductCategory {
  final String id;
  final String categoryName;
  final String? description;
  final bool isActive;

  ProductCategory({
    required this.id,
    required this.categoryName,
    this.description,
    required this.isActive,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] ?? '',
      categoryName: json['category_name'] ?? '',
      description: json['description'],
      isActive: json['is_active'] ?? true,
    );
  }
}

class ProductSubCategory {
  final String id;
  final String subCategoryName;
  final String categoryId;
  final String? description;
  final bool isActive;

  ProductSubCategory({
    required this.id,
    required this.subCategoryName,
    required this.categoryId,
    this.description,
    required this.isActive,
  });

  factory ProductSubCategory.fromJson(Map<String, dynamic> json) {
    return ProductSubCategory(
      id: json['id'] ?? '',
      subCategoryName: json['sub_category_name'] ?? '',
      categoryId: json['category_id'] ?? '',
      description: json['description'],
      isActive: json['is_active'] ?? true,
    );
  }
}

class ProductFormulation {
  final String id;
  final String formulationName;
  final bool isActive;

  ProductFormulation({
    required this.id,
    required this.formulationName,
    required this.isActive,
  });

  factory ProductFormulation.fromJson(Map<String, dynamic> json) {
    return ProductFormulation(
      id: json['id'] ?? '',
      formulationName: json['formulation_name'] ?? '',
      isActive: json['is_active'] ?? true,
    );
  }
}