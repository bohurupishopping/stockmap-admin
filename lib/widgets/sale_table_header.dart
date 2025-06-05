import 'package:flutter/material.dart';

class SaleTableHeader extends StatelessWidget {
  final String sortField;
  final String sortDirection;
  final Function(String) onSort;

  const SaleTableHeader({
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
            const Color(0xFF1e40af),
            const Color(0xFF3b82f6),
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
          
         
          
          // Date (15%)
          Expanded(
            flex: 2,
            child: _buildSortableHeader(
              'Sale Date',
              'sale_date',
              Icons.calendar_today,
            ),
          ),
          
          // Amount (15%)
          Expanded(
            flex: 2,
            child: _buildSortableHeader(
              'Amount',
              'cost_per_strip',
              Icons.currency_rupee,
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
      onTap: () => onSort('${field}_${isActive && isAscending ? 'desc' : 'asc'}'),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white70,
            size: 14,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white70,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          if (isActive)
            Icon(
              isAscending ? Icons.arrow_upward : Icons.arrow_downward,
              color: Colors.white,
              size: 12,
            )
          else
            const Icon(
              Icons.unfold_more,
              color: Colors.white54,
              size: 12,
            ),
        ],
      ),
    );
  }
}