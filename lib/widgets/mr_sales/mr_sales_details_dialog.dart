import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/mr_sale_models.dart';

class MRSalesDetailsDialog extends StatefulWidget {
  final MRSalesOrder order;
  final NumberFormat currencyFormat;
  final DateFormat dateFormat;
  final Function(String orderId, String status) onPaymentStatusUpdate;

  const MRSalesDetailsDialog({
    super.key,
    required this.order,
    required this.currencyFormat,
    required this.dateFormat,
    required this.onPaymentStatusUpdate,
  });

  @override
  State<MRSalesDetailsDialog> createState() => _MRSalesDetailsDialogState();
}

class _MRSalesDetailsDialogState extends State<MRSalesDetailsDialog> {
  String? _selectedPaymentStatus;
  bool _isUpdating = false;

  final List<Map<String, String>> _paymentStatusOptions = [
    {'value': 'Pending', 'label': 'Pending'},
    {'value': 'Partial', 'label': 'Partial'},
    {'value': 'Paid', 'label': 'Paid'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedPaymentStatus = widget.order.paymentStatus;
  }

  Future<void> _updatePaymentStatus() async {
    if (_selectedPaymentStatus == null ||
        _selectedPaymentStatus == widget.order.paymentStatus) {
      return; // No change to update
    }

    setState(() => _isUpdating = true);

    try {
      await widget.onPaymentStatusUpdate(
        widget.order.orderId,
        _selectedPaymentStatus!,
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      // Error is handled by the parent, just reset the UI state
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        // KEY CHANGE: Increased dialog size for a less cramped feel.
        constraints: const BoxConstraints(maxWidth: 650, maxHeight: 750),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            // The content area is scrollable.
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoSection('Customer Information', [
                      _buildInfoRow('Name', widget.order.customerName),
                      if (widget.order.customerPhone?.isNotEmpty == true)
                        _buildInfoRow('Phone', widget.order.customerPhone!),
                      if (widget.order.customerAddress?.isNotEmpty == true)
                        _buildInfoRow('Address', widget.order.customerAddress!),
                    ]),
                    const SizedBox(height: 24),
                    _buildInfoSection('MR Information', [
                      _buildInfoRow('MR Name', widget.order.mrUserName ?? 'N/A'),
                    ]),
                    const SizedBox(height: 24),
                    _buildInfoSection('Payment Information', [
                      _buildInfoRow('Total Amount', widget.currencyFormat.format(widget.order.totalAmount)),
                      _buildInfoRow('Paid Amount', widget.currencyFormat.format(widget.order.paidAmount)),
                      _buildInfoRow('Pending Amount', widget.currencyFormat.format(widget.order.totalAmount - widget.order.paidAmount),
                        valueColor: const Color(0xFFEF4444)), // Highlight pending amount
                      _buildPaymentStatusRow(),
                    ]),
                    const SizedBox(height: 24),
                    _buildOrderItemsSection(),
                  ],
                ),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // --- Header ---
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // KEY CHANGE: Smaller font for order ID and better styling using RichText.
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'System',
                      color: Color(0xFF4B5563),
                      fontSize: 18,
                    ),
                    children: [
                      const TextSpan(text: 'Order '),
                      TextSpan(
                        text: '#${widget.order.orderId}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.dateFormat.format(widget.order.orderDate),
                  style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Color(0xFF6B7280)),
            splashRadius: 20,
          ),
        ],
      ),
    );
  }

  // --- Content Sections ---
  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
        ),
        const SizedBox(height: 8),
        // KEY CHANGE: Removed the boxy border. Using dividers between rows for a cleaner look.
        Column(
          children: List.generate(children.length, (index) {
            return Column(
              children: [
                children[index],
                if (index < children.length - 1)
                  const Divider(height: 16, color: Color(0xFFF3F4F6)),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KEY CHANGE: Replaced fixed width with Expanded for responsive layout.
          Expanded(
            flex: 2, // Label takes 2 parts of the space
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3, // Value takes 3 parts of the space
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: valueColor ?? const Color(0xFF1F2937),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStatusRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
            flex: 2,
            child: Text(
              'Payment Status',
              style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: DropdownButtonHideUnderline(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  border: Border.all(color: const Color(0xFFD1D5DB)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: _selectedPaymentStatus,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF6B7280)),
                  items: _paymentStatusOptions.map((status) {
                    return DropdownMenuItem<String>(
                      value: status['value'],
                      child: Text(
                        status['label']!,
                        style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedPaymentStatus = value),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Items (${widget.order.items?.length ?? 0})',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
        ),
        const SizedBox(height: 12),
        // KEY CHANGE: Replaced custom rows with ListTile for a standard, clean look.
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: widget.order.items?.asMap().entries.map((entry) {
                  final item = entry.value;
                  return _buildOrderItemTile(item);
                }).toList() ?? [],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItemTile(MRSalesOrderItem item) {
    return ListTile(
      title: Text(
        item.productName ?? 'Unknown Product',
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2937)),
      ),
      subtitle: Text(
        'Qty: ${item.quantity}  ·  Rate: ${widget.currencyFormat.format(item.unitPrice)}',
        style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
      ),
      trailing: Text(
        widget.currencyFormat.format(item.totalPrice),
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
      ),
      dense: true,
    );
  }

  // --- Footer ---
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        border: Border(top: BorderSide(color: Color(0xFFF3F4F6), width: 1.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: const BorderSide(color: Color(0xFFD1D5DB)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Close', style: TextStyle(color: Color(0xFF374151), fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _isUpdating ? null : _updatePaymentStatus,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                disabledBackgroundColor: const Color(0xFF93C5FD),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isUpdating
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                    )
                  : const Text('Update Status', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}