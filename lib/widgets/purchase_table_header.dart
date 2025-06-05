import 'package:flutter/material.dart';

class PurchaseTableHeader extends StatelessWidget {
  final String sortField;
  final String sortDirection;
  final Function(String) onSort;

  const PurchaseTableHeader({
    super.key,
    required this.sortField,
    required this.sortDirection,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1e293b),
            const Color(0xFF334155),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Product Info (40%)
          Expanded(
            flex: 4,
            child: _buildSortableHeader(
              'Product',
              'product_name',
              Icons.inventory_2_outlined,
            ),
          ),
          
          // Batch & Quantity (20%)
          Expanded(
            flex: 2,
            child: _buildSortableHeader(
              'Batch/Qty',
              'batch_number',
              Icons.qr_code,
            ),
          ),
          
          // Supplier (20%)
          Expanded(
            flex: 2,
            child: _buildSortableHeader(
              'Batch',
              'supplier_id',
              Icons.business,
            ),
          ),
          
          // Total Value (15%)
          Expanded(
            flex: 2,
            child: _buildSortableHeader(
              'Total Value',
              'total_value',
              Icons.attach_money,
            ),
          ),
          
          // Status (5%)
          Container(
            width: 24,
            alignment: Alignment.center,
            child: Icon(
              Icons.info_outline,
              size: 16,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSortableHeader(String title, String field, IconData icon) {
    final isActive = sortField == field;
    final isAscending = sortDirection == 'asc';
    
    return InkWell(
      onTap: () => onSort(field),
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isActive 
                  ? Colors.white 
                  : Colors.white.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: isActive 
                      ? Colors.white 
                      : Colors.white.withValues(alpha: 0.8),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isActive) ...[
              const SizedBox(width: 4),
              Icon(
                isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 12,
                color: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }
}