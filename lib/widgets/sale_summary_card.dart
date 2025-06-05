import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/sale_models.dart';

class SaleSummaryCard extends StatelessWidget {
  final SaleSummary summary;
  final NumberFormat currencyFormat;
  final DateFormat dateFormat;

  const SaleSummaryCard({
    super.key,
    required this.summary,
    required this.currencyFormat,
    required this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[600]!, Colors.blue[700]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.point_of_sale,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Sales Summary',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  icon: Icons.receipt_long,
                  label: 'Total Sales',
                  value: summary.totalTransactions.toString(),
                ),
              ),
              Expanded(
                child: _SummaryItem(
                  icon: Icons.inventory,
                  label: 'Total Quantity',
                  value: '₹${summary.totalQuantity} strips',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  icon: Icons.currency_rupee,
                  label: 'Total Amount',
                  value: '₹${summary.totalAmount}',
                ),
              ),
              Expanded(
                child: _SummaryItem(
                  icon: Icons.schedule,
                  label: 'Last Sale',
                  value: summary.lastSaleDate != null
                      ? dateFormat.format(summary.lastSaleDate!)
                      : 'No sales yet',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Colors.white70,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}