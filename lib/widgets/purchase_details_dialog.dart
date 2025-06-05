import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/purchase_models.dart';

class PurchaseDetailsDialog extends StatelessWidget {
  final PurchaseTransaction transaction;
  final NumberFormat currencyFormat;
  final DateFormat dateFormat;

  const PurchaseDetailsDialog({
    super.key,
    required this.transaction,
    required this.currencyFormat,
    required this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    final isExpiringSoon = transaction.expiryDate.isBefore(
      DateTime.now().add(const Duration(days: 90)),
    );
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF0f172a),
                    const Color(0xFF1e293b),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.receipt_long,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Purchase Details',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          transaction.productName,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Information Section
                    _buildSection(
                      'Product Information',
                      Icons.inventory_2,
                      const Color(0xFF3b82f6),
                      [
                        _buildDetailItem('Product Name', transaction.productName),
                        _buildDetailItem('Product Code', transaction.productCode),
                        if (transaction.genericName != null)
                          _buildDetailItem('Generic Name', transaction.genericName!),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Purchase Details Section
                    _buildSection(
                      'Purchase Details',
                      Icons.shopping_cart,
                      const Color(0xFF10b981),
                      [
                        _buildDetailItem('Batch Number', transaction.batchNumber),
                        _buildDetailItem('Quantity', '${transaction.quantityStrips} strips'),
                        _buildDetailItem('Cost per Strip', currencyFormat.format(transaction.costPerStrip)),
                        _buildDetailItem('Total Value', currencyFormat.format(transaction.totalValue)),
                        _buildDetailItem('Supplier', transaction.supplierName ?? 'Unknown'),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Date Information Section
                    _buildSection(
                      'Date Information',
                      Icons.calendar_today,
                      const Color(0xFF8b5cf6),
                      [
                        _buildDetailItem('Purchase Date', dateFormat.format(transaction.purchaseDate)),
                        _buildDetailItem('Expiry Date', dateFormat.format(transaction.expiryDate)),
                        _buildDetailItem('Created At', dateFormat.format(transaction.createdAt)),
                      ],
                    ),
                    
                    // Expiry Warning
                    if (isExpiringSoon) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange[200]!),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning_amber,
                              color: Colors.orange[700],
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'This product expires in ${transaction.expiryDate.difference(DateTime.now()).inDays} days',
                                style: TextStyle(
                                  color: Colors.orange[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    // Additional Information Section
                    if (transaction.referenceDocumentId != null || transaction.notes != null) ...[
                      const SizedBox(height: 20),
                      _buildSection(
                        'Additional Information',
                        Icons.info_outline,
                        const Color(0xFF6b7280),
                        [
                          if (transaction.referenceDocumentId != null)
                            _buildDetailItem('Reference Document', transaction.referenceDocumentId!),
                          if (transaction.notes != null)
                            _buildDetailItem('Notes', transaction.notes!),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Footer
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSection(String title, IconData icon, Color color, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                icon,
                size: 16,
                color: color,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
  
  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF6b7280),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}