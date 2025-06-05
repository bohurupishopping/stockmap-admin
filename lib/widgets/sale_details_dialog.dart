// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/sale_models.dart';

class SaleDetailsDialog extends StatelessWidget {
  final SaleTransaction transaction;
  final NumberFormat currencyFormat;
  final DateFormat dateFormat;

  const SaleDetailsDialog({
    super.key,
    required this.transaction,
    required this.currencyFormat,
    required this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    
    // Modern color scheme
    const primaryColor = Color(0xFF1E293B); // Slate 800
    const accentColor = Color(0xFF7C3AED); // Violet 600
    const surfaceColor = Color(0xFFF8FAFC); // Slate 50
    const borderColor = Color(0xFFE2E8F0); // Slate 200
    const successColor = Color(0xFF059669); // Emerald 600
    
    final isExpiringSoon = transaction.expiryDate.isBefore(
      DateTime.now().add(const Duration(days: 90)),
    );
    
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 40 : 16,
        vertical: isTablet ? 24 : 16,
      ),
      child: Container(
        width: isTablet ? 750 : screenSize.width * 0.95,
        constraints: BoxConstraints(
          maxWidth: 750,
          maxHeight: screenSize.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(context, theme, primaryColor, accentColor, surfaceColor, borderColor, successColor),
            
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSaleInfo(theme, primaryColor, accentColor),
                    const SizedBox(height: 20),
                    _buildTransactionDetails(theme, primaryColor, isExpiringSoon),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            
            // Footer
            _buildFooter(context, theme, primaryColor, accentColor, surfaceColor, borderColor),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, Color primaryColor, Color accentColor, Color surfaceColor, Color borderColor, Color successColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border(
          bottom: BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Sale Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
            ),
            child: Icon(
              Icons.point_of_sale_outlined,
              color: accentColor,
              size: 20,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Sale Title Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sale ID Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E8FF), // Violet 50
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFDDD6FE), // Violet 200
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Sale #${transaction.saleId}',
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 6,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                
                const SizedBox(height: 6),
                
                // Product Name
                Text(
                  transaction.productName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 2),
                
                // Product Code
                Text(
                  transaction.productCode,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF64748B), // Slate 500
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Amount Badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5), // Emerald 50
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFA7F3D0), // Emerald 200
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  currencyFormat.format(transaction.totalValue),
                  style: TextStyle(
                    color: successColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Total',
                  style: TextStyle(
                    color: successColor,
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Close Button
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
            ),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.close_rounded,
                size: 16,
              ),
              style: IconButton.styleFrom(
                foregroundColor: const Color(0xFF64748B), // Slate 500
                minimumSize: const Size(32, 32),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaleInfo(ThemeData theme, Color primaryColor, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sale Information',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        _buildInfoRow('Sale Date', dateFormat.format(transaction.saleDate), Icons.calendar_today_outlined, theme, primaryColor, accentColor),
        _buildInfoRow('Quantity', '${transaction.quantityStrips} strips', Icons.inventory_2_outlined, theme, primaryColor, accentColor),
        _buildInfoRow('Price per Strip', currencyFormat.format(transaction.costPerStrip), Icons.attach_money_outlined, theme, primaryColor, accentColor),
      ],
    );
  }

  Widget _buildTransactionDetails(ThemeData theme, Color primaryColor, bool isExpiringSoon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Batch & Product Details',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDetailCard(
                'Batch Number',
                transaction.batchNumber,
                Icons.qr_code_2_outlined,
                theme,
                primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDetailCard(
                'Expiry Date',
                dateFormat.format(transaction.expiryDate),
                Icons.schedule_outlined,
                theme,
                primaryColor,
                isWarning: isExpiringSoon,
              ),
            ),
          ],
        ),
        if (isExpiringSoon) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED), // Orange 50
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFFED7AA), // Orange 200
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_outlined,
                  color: const Color(0xFFEA580C), // Orange 600
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Warning: This batch is expiring soon!',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFEA580C), // Orange 600
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFooter(BuildContext context, ThemeData theme, Color primaryColor, Color accentColor, Color surfaceColor, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: borderColor,
                  width: 1,
                ),
              ),
              child: TextButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close_rounded,
                  size: 16,
                ),
                label: const Text(
                  'Close',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF64748B), // Slate 500
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, ThemeData theme, Color primaryColor, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9), // Slate 100
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 14,
              color: accentColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B), // Slate 500
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String label, String value, IconData icon, ThemeData theme, Color primaryColor, {bool isWarning = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isWarning ? const Color(0xFFFED7AA) : const Color(0xFFE2E8F0), // Orange 200 or Slate 200
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isWarning ? const Color(0xFFFFF7ED) : const Color(0xFFF1F5F9), // Orange 50 or Slate 100
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 16,
              color: isWarning ? const Color(0xFFEA580C) : const Color(0xFF7C3AED), // Orange 600 or Violet 600
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isWarning ? const Color(0xFFEA580C) : const Color(0xFF64748B), // Orange 600 or Slate 500
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isWarning ? const Color(0xFFEA580C) : primaryColor, // Orange 600 or Primary
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}