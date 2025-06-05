import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/product_models.dart';
import '../services/product_service.dart';

class ReportSummaryCards extends StatelessWidget {
  final int totalProducts;
  final int lowStockProducts;
  final int outOfStockProducts;
  final double totalStockValue;
  final NumberFormat currencyFormat;

  const ReportSummaryCards({
    super.key,
    required this.totalProducts,
    required this.lowStockProducts,
    required this.outOfStockProducts,
    required this.totalStockValue,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [

          // Status cards row
          Row(
            children: [
              Expanded(
                child: _buildStatusCard(
                  'Out of Stock',
                  outOfStockProducts.toString(),
                  Icons.warning_amber_rounded,
                  Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatusCard(
                  'Low Stock',
                  lowStockProducts.toString(),
                  Icons.trending_down_rounded,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatusCard(
                  'In Stock',
                  (totalProducts - outOfStockProducts - lowStockProducts).toString(),
                  Icons.check_circle_rounded,
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748b),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ReportFilters extends StatefulWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final String sortField;
  final String sortDirection;
  final String selectedCategory;
  final String stockFilter;
  final Function(String) onSearchChanged;
  final Function(String, String) onSortChanged;
  final Function(String) onCategoryChanged;
  final Function(String) onStockFilterChanged;

  const ReportFilters({
    super.key,
    required this.searchController,
    required this.searchQuery,
    required this.sortField,
    required this.sortDirection,
    required this.selectedCategory,
    required this.stockFilter,
    required this.onSearchChanged,
    required this.onSortChanged,
    required this.onCategoryChanged,
    required this.onStockFilterChanged,
  });

  @override
  State<ReportFilters> createState() => _ReportFiltersState();
}

class _ReportFiltersState extends State<ReportFilters> {
  List<ProductCategory> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
    });

    try {
      final categories = await ProductService.getCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        children: [
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: widget.searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF6366f1),
                  size: 22,
                ),
                suffixIcon: widget.searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: Color(0xFF94A3B8),
                          size: 20,
                        ),
                        onPressed: () {
                          widget.searchController.clear();
                          widget.onSearchChanged('');
                        },
                      )
                    : null,
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: widget.onSearchChanged,
            ),
          ),
          const SizedBox(height: 12),
          // Filter chips
          Row(
            children: [
              Expanded(
                child: _buildCategoryFilter(),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStockFilter(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Sort options
          Row(
            children: [
              Expanded(
                child: _buildSortButton(
                  'Name',
                  'product_name',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSortButton(
                  'Stock',
                  'total_stock',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSortButton(
                  'Value',
                  'stock_value',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSortButton(
                  'Category',
                  'category',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.6),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: widget.selectedCategory,
          isExpanded: true,
          style: const TextStyle(
            color: Color(0xFF64748b),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          items: [
            const DropdownMenuItem(
              value: 'all',
              child: Text('All Categories'),
            ),
            ..._categories.map((category) => DropdownMenuItem(
              value: category.id,
              child: Text(
                category.categoryName,
                overflow: TextOverflow.ellipsis,
              ),
            )),
          ],
          onChanged: (value) {
            if (value != null) {
              widget.onCategoryChanged(value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildStockFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.6),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: widget.stockFilter,
          isExpanded: true,
          style: const TextStyle(
            color: Color(0xFF64748b),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          items: const [
            DropdownMenuItem(
              value: 'all',
              child: Text('All Stock'),
            ),
            DropdownMenuItem(
              value: 'in_stock',
              child: Text('In Stock'),
            ),
            DropdownMenuItem(
              value: 'low_stock',
              child: Text('Low Stock'),
            ),
            DropdownMenuItem(
              value: 'out_of_stock',
              child: Text('Out of Stock'),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              widget.onStockFilterChanged(value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildSortButton(String label, String field) {
    final isActive = widget.sortField == field;
    final isAsc = widget.sortDirection == 'asc';
    
    return GestureDetector(
      onTap: () {
        final newDirection = isActive && isAsc ? 'desc' : 'asc';
        widget.onSortChanged(field, newDirection);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? const Color(0xFF6366f1) : Colors.white.withValues(alpha: 0.6),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isActive ? const Color(0xFF6366f1) : const Color(0xFF64748b),
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
            ),
            if (isActive) ...[
              const SizedBox(width: 2),
              Icon(
                isAsc ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: const Color(0xFF6366f1),
                size: 14,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class StockReportCard extends StatelessWidget {
  final Product product;
  final NumberFormat currencyFormat;

  const StockReportCard({
    super.key,
    required this.product,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
    final totalStock = product.totalClosingStock;
    final minStock = product.minStockLevelGodown + product.minStockLevelMr;
    final stockValue = totalStock * product.baseCostPerStrip;
    
    // Determine stock status
    Color statusColor;
    String statusText;
    IconData statusIcon;
    
    if (totalStock == 0) {
      statusColor = Colors.red;
      statusText = 'Out of Stock';
      statusIcon = Icons.warning_amber_rounded;
    } else if (totalStock <= minStock) {
      statusColor = Colors.orange;
      statusText = 'Low Stock';
      statusIcon = Icons.trending_down_rounded;
    } else {
      statusColor = Colors.green;
      statusText = 'In Stock';
      statusIcon = Icons.check_circle_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with product info and status
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product code
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        product.productCode,
                        style: const TextStyle(
                          color: Color(0xFF2563EB),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Product name
                    Text(
                      product.productName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Color(0xFF1e293b),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Generic name
                    Text(
                      product.genericName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF64748b),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      statusIcon,
                      color: statusColor,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Stock details grid
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
               
                // Total and value row
                Row(
                  children: [
                    Expanded(
                      child: _buildStockDetail(
                        'Total Stock',
                        product.formattedTotalStock,
                        Icons.inventory_rounded,
                        Colors.purple,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey.shade300,
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    Expanded(
                      child: _buildStockDetail(
                        'Stock Value',
                        currencyFormat.format(stockValue),
                        Icons.currency_rupee_rounded,
                        Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildStockDetail(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xFF64748b),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1e293b),
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

}