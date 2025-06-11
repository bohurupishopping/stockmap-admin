// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/purchase_models.dart';

class PurchaseFilterWidget extends StatefulWidget {
  final PurchaseFilters? initialFilters;
  final Function(PurchaseFilters?) onFiltersChanged;
  final String searchQuery;
  final Function(String) onSearchChanged;
  final String sortField;
  final String sortDirection;
  final Function(String) onSortChanged;

  const PurchaseFilterWidget({
    super.key,
    this.initialFilters,
    required this.onFiltersChanged,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.sortField,
    required this.sortDirection,
    required this.onSortChanged,
  });

  @override
  State<PurchaseFilterWidget> createState() => _PurchaseFilterWidgetState();
}

class _PurchaseFilterWidgetState extends State<PurchaseFilterWidget> {
  late TextEditingController _searchController;
  late TextEditingController _batchController;
  late TextEditingController _referenceController;
  late TextEditingController _supplierController;
  DateTime? _startDate;
  DateTime? _endDate;
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
    _batchController = TextEditingController(text: widget.initialFilters?.batchNumber ?? '');
    _referenceController = TextEditingController(text: widget.initialFilters?.referenceDocumentId ?? '');
    _supplierController = TextEditingController(text: widget.initialFilters?.supplierName ?? '');
    _startDate = widget.initialFilters?.dateFrom;
    _endDate = widget.initialFilters?.dateTo;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _batchController.dispose();
    _referenceController.dispose();
    _supplierController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final filters = PurchaseFilters(
      productName: _searchController.text.isNotEmpty ? _searchController.text : null,
      batchNumber: _batchController.text.isNotEmpty ? _batchController.text : null,
      referenceDocumentId: _referenceController.text.isNotEmpty ? _referenceController.text : null,
      supplierName: _supplierController.text.isNotEmpty ? _supplierController.text : null,
      dateFrom: _startDate,
      dateTo: _endDate,
    );
    
    widget.onFiltersChanged(filters.hasActiveFilters ? filters : null);
    widget.onSearchChanged(_searchController.text);
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _batchController.clear();
      _referenceController.clear();
      _supplierController.clear();
      _startDate = null;
      _endDate = null;
    });
    widget.onFiltersChanged(null);
    widget.onSearchChanged('');
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate ?? DateTime.now() : _endDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
      _applyFilters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // Search and Sort Row
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.7)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onChanged: (value) {
                    widget.onSearchChanged(value);
                  },
                  onSubmitted: (value) => _applyFilters(),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: PopupMenuButton<String>(
                  icon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.sort, color: Colors.white, size: 20),
                      const SizedBox(width: 4),
                      Icon(
                        widget.sortDirection == 'asc' ? Icons.arrow_upward : Icons.arrow_downward,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                  onSelected: widget.onSortChanged,
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'purchase_date',
                      child: Text('Sort by Date'),
                    ),
                    const PopupMenuItem(
                      value: 'product_name',
                      child: Text('Sort by Product'),
                    ),
                    const PopupMenuItem(
                      value: 'cost_per_strip',
                      child: Text('Sort by Cost'),
                    ),
                    const PopupMenuItem(
                      value: 'quantity_strips',
                      child: Text('Sort by Quantity'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Filter Fields Row
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _batchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Batch number',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onSubmitted: (value) => _applyFilters(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _supplierController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Supplier',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onSubmitted: (value) => _applyFilters(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Date Range and Actions Row
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context, true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.white.withOpacity(0.7), size: 16),
                        const SizedBox(width: 8),
                        Text(
                          _startDate != null ? _dateFormat.format(_startDate!) : 'From date',
                          style: TextStyle(
                            color: _startDate != null ? Colors.white : Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context, false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.white.withOpacity(0.7), size: 16),
                        const SizedBox(width: 8),
                        Text(
                          _endDate != null ? _dateFormat.format(_endDate!) : 'To date',
                          style: TextStyle(
                            color: _endDate != null ? Colors.white : Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: const Text('Apply'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _clearFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: const Text('Clear'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}