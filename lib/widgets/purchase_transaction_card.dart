// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/purchase_models.dart';

class PurchaseTransactionCard extends StatelessWidget {
  final PurchaseTransaction transaction;
  final NumberFormat currencyFormat;
  final DateFormat dateFormat;
  final VoidCallback? onTap;

  const PurchaseTransactionCard({
    super.key,
    required this.transaction,
    required this.currencyFormat,
    required this.dateFormat,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isExpiringSoon = transaction.expiryDate.isBefore(
      DateTime.now().add(const Duration(days: 90)),
    );
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isExpiringSoon 
            ? BorderSide(color: Colors.orange.withOpacity(0.5), width: 1)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.productName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1f2937),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          transaction.productCode,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Text(
                      currencyFormat.format(transaction.totalValue),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Details Grid
              Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      'Quantity',
                      '${transaction.quantityStrips} strips',
                      Icons.inventory_2_outlined,
                      Colors.blue,
                    ),
                  ),
                  Expanded(
                    child: _buildDetailItem(
                      'Cost/Strip',
                      currencyFormat.format(transaction.costPerStrip),
                      Icons.attach_money,
                      Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      'Batch',
                      transaction.batchNumber,
                      Icons.qr_code,
                      Colors.purple,
                    ),
                  ),
                  Expanded(
                    child: _buildDetailItem(
                      'Supplier',
                      transaction.supplierName ?? 'Unknown',
                      Icons.business,
                      Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      'Purchase Date',
                      dateFormat.format(transaction.purchaseDate),
                      Icons.calendar_today,
                      Colors.indigo,
                    ),
                  ),
                  Expanded(
                    child: _buildDetailItem(
                      'Expiry Date',
                      dateFormat.format(transaction.expiryDate),
                      Icons.schedule,
                      isExpiringSoon ? Colors.orange : Colors.grey,
                    ),
                  ),
                ],
              ),
              
              // Reference and Notes
              if (transaction.referenceDocumentId != null || transaction.notes != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (transaction.referenceDocumentId != null) ...[
                        Row(
                          children: [
                            Icon(Icons.receipt, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              'Ref: ${transaction.referenceDocumentId}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (transaction.notes != null) ...[
                        if (transaction.referenceDocumentId != null) const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.note, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                transaction.notes!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              
              // Expiry Warning
              if (isExpiringSoon) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber, size: 14, color: Colors.orange[700]),
                      const SizedBox(width: 4),
                      Text(
                        'Expires in ${transaction.expiryDate.difference(DateTime.now()).inDays} days',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: color.withOpacity(0.7),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF374151),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}