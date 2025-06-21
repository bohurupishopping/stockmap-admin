import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/sale_models.dart';

class SaleTableRow extends StatelessWidget {
  final SaleTransaction transaction;
  final NumberFormat currencyFormat;
  final DateFormat dateFormat;
  final VoidCallback? onTap;

  const SaleTableRow({
    super.key,
    required this.transaction,
    required this.currencyFormat,
    required this.dateFormat,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if the product's expiry date is within the next 90 days.
    final isExpiringSoon = transaction.expiryDate.isBefore(
      DateTime.now().add(const Duration(days: 90)),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpiringSoon
              ? const Color(0xFFFF8A65) // Warning color for expiring items
              : const Color(0xFFE5E7EB), // Standard border color
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // KEY CHANGE 1:
                // Only the product info column is Expanded. It will take all
                // available horizontal space after other columns are laid out.
                Expanded(
                  child: _buildProductInfo(),
                ),
                const SizedBox(width: 16),

                // KEY CHANGE 2:
                // These columns are not Expanded. They size themselves based on
                // their content, creating a neat and adaptive layout.
                _buildBatchAndQuantity(),
                const SizedBox(width: 16),
                _buildDateInfo(isExpiringSoon),
                const SizedBox(width: 16),
                _buildAmountInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the Product Name and Code column.
  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          transaction.productName,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
            letterSpacing: -0.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            transaction.productCode,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Builds the Batch Number and Quantity column.
  Widget _buildBatchAndQuantity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            // Corrected: .withOpacity() is the correct method.
            color: const Color(0xFF3B82F6).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            transaction.batchNumber,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF3B82F6),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.inventory, size: 12, color: Color(0xFF6B7280)),
            const SizedBox(width: 4),
            Text(
              '${transaction.quantityStrips}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(width: 2),
            const Text(
              'strips',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds the Sale and Expiry Date column.
  Widget _buildDateInfo(bool isExpiringSoon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            const Icon(
              Icons.calendar_today,
              size: 12,
              color: Color(0xFF6B7280),
            ),
            const SizedBox(width: 4),
            Text(
              dateFormat.format(transaction.saleDate),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        const SizedBox(height: 4),
        // Use Opacity to prevent layout shifts when the warning appears/disappears.
        Opacity(
          opacity: isExpiringSoon ? 1.0 : 0.0,
          child: Row(
            children: [
              const Icon(
                Icons.warning,
                size: 10,
                color: Color(0xFFFF8A65),
              ),
              const SizedBox(width: 2),
              Text(
                'Exp: ${dateFormat.format(transaction.expiryDate)}',
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFFFF8A65),
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the Total Value and Cost/Strip column.
  Widget _buildAmountInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          currencyFormat.format(transaction.totalValue),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF059669),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          '${currencyFormat.format(transaction.costPerStrip)}/strip',
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF9CA3AF),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}