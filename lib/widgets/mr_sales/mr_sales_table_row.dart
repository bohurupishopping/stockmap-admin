// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/mr_sale_models.dart';

// --- Professional color palette remains consistent ---
const Color _primaryColor = Color(0xFF059669); // Green for sales/money
const Color _warningColor = Color(0xFFD97706); // Amber/Yellow for partial
const Color _cardColor = Colors.white;
const Color _titleColor = Color(0xFF111827);
const Color _subtitleColor = Color(0xFF6B7280);
const Color _borderColor = Color(0xFFF3F4F6);

class MRSalesTableRow extends StatelessWidget {
  final MRSalesOrder order;
  final NumberFormat currencyFormat;
  final DateFormat dateFormat;
  final VoidCallback onTap;

  const MRSalesTableRow({
    super.key,
    required this.order,
    required this.currencyFormat,
    required this.dateFormat,
    required this.onTap,
  });

  // Helper for secondary info chips (unchanged)
  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: _subtitleColor),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: _subtitleColor,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Truncate the order ID
    final String displayOrderId = order.orderId.length > 8
        ? '#${order.orderId.substring(0, 8)}...'
        : '#${order.orderId}';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1F2937).withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- NEW: Integrated Two-Column Row Layout ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Left Column: All details ---
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.customerName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _titleColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          displayOrderId,
                          style: const TextStyle(
                            fontSize: 13,
                            color: _subtitleColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 16.0,
                          runSpacing: 8.0,
                          children: [
                             _buildInfoChip(
                              Icons.calendar_today_outlined,
                              dateFormat.format(order.orderDate),
                            ),
                            _buildInfoChip(
                              Icons.person_outline,
                              order.mrUserName ?? 'Unknown MR',
                            ),
                            if (order.items?.isNotEmpty == true)
                              _buildInfoChip(
                                Icons.inventory_2_outlined,
                                '${order.items!.length} item${order.items!.length > 1 ? 's' : ''}',
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // --- Right Column: Value and Status ---
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        currencyFormat.format(order.totalAmount),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _primaryColor,
                        ),
                      ),
                      const SizedBox(height: 12), // Minimum spacing
                      _buildPaymentStatusBadge(),
                    ],
                  ),
                ],
              ),
              // --- Visual Partial Payment Indicator (if applicable) ---
              if (order.paymentStatus == 'partial' && order.paidAmount > 0)
                _buildPartialPaymentIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentStatusBadge() {
    final statusColor = order.paymentStatusColor;
    final statusText = order.paymentStatusDisplay;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20), // Pill shape
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: statusColor,
        ),
      ),
    );
  }

  Widget _buildPartialPaymentIndicator() {
    final double progress = order.totalAmount > 0 
        ? order.paidAmount / order.totalAmount 
        : 0.0;

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: _warningColor.withOpacity(0.2),
              color: _warningColor,
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Paid: ${currencyFormat.format(order.paidAmount)} of ${currencyFormat.format(order.totalAmount)}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _warningColor,
            ),
          ),
        ],
      ),
    );
  }
}