import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/sale_models.dart';

class SaleFilterWidget extends StatefulWidget {
  final SaleFilters? initialFilters;
  final Function(SaleFilters?) onFiltersChanged;
  final String searchQuery;
  final Function(String) onSearchChanged;
  final String sortField;
  final String sortDirection;
  final Function(String) onSortChanged;

  const SaleFilterWidget({
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
  State<SaleFilterWidget> createState() => _SaleFilterWidgetState();
}

class _SaleFilterWidgetState extends State<SaleFilterWidget> {
  late TextEditingController _searchController;
  late TextEditingController _batchController;
  late TextEditingController _referenceController;
  late TextEditingController _transactionTypeController;
  DateTime? _startDate;
  DateTime? _endDate;
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
    _batchController = TextEditingController(text: widget.initialFilters?.batchNumber ?? '');
    _referenceController = TextEditingController(text: widget.initialFilters?.referenceDocumentId ?? '');
    _transactionTypeController = TextEditingController(text: widget.initialFilters?.transactionType ?? '');
    _startDate = widget.initialFilters?.dateFrom;
    _endDate = widget.initialFilters?.dateTo;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _batchController.dispose();
    _referenceController.dispose();
    _transactionTypeController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final filters = SaleFilters(
      productName: _searchController.text.isNotEmpty ? _searchController.text : null,
      batchNumber: _batchController.text.isNotEmpty ? _batchController.text : null,
      referenceDocumentId: _referenceController.text.isNotEmpty ? _referenceController.text : null,
      transactionType: _transactionTypeController.text.isNotEmpty ? _transactionTypeController.text : null,
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
      _transactionTypeController.clear();
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
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.filter_list,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Filters & Search',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (widget.initialFilters?.hasActiveFilters == true)
                TextButton.icon(
                  onPressed: _clearFilters,
                  icon: const Icon(Icons.clear, size: 16),
                  label: const Text('Clear All'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red[600],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Search and Sort Row
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by product name...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  onChanged: (value) {
                    _applyFilters();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  value: '${widget.sortField}_${widget.sortDirection}',
                  decoration: InputDecoration(
                    labelText: 'Sort by',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'sale_date_desc',
                      child: Text('Date (Newest)'),
                    ),
                    DropdownMenuItem(
                      value: 'sale_date_asc',
                      child: Text('Date (Oldest)'),
                    ),
                    DropdownMenuItem(
                      value: 'cost_per_strip_desc',
                      child: Text('Price (High to Low)'),
                    ),
                    DropdownMenuItem(
                      value: 'cost_per_strip_asc',
                      child: Text('Price (Low to High)'),
                    ),
                    DropdownMenuItem(
                      value: 'quantity_strips_desc',
                      child: Text('Quantity (High to Low)'),
                    ),
                    DropdownMenuItem(
                      value: 'quantity_strips_asc',
                      child: Text('Quantity (Low to High)'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      widget.onSortChanged(value);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Filter Fields Row 1
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _batchController,
                  decoration: InputDecoration(
                    labelText: 'Batch Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  onChanged: (value) => _applyFilters(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _referenceController,
                  decoration: InputDecoration(
                    labelText: 'Reference Document',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  onChanged: (value) => _applyFilters(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _transactionTypeController,
                  decoration: InputDecoration(
                    labelText: 'Transaction Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  onChanged: (value) => _applyFilters(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Date Range Row
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _selectDate(context, true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          _startDate != null
                              ? 'From: ${_dateFormat.format(_startDate!)}'
                              : 'Start Date',
                          style: TextStyle(
                            color: _startDate != null
                                ? Theme.of(context).textTheme.bodyLarge?.color
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () => _selectDate(context, false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          _endDate != null
                              ? 'To: ${_dateFormat.format(_endDate!)}'
                              : 'End Date',
                          style: TextStyle(
                            color: _endDate != null
                                ? Theme.of(context).textTheme.bodyLarge?.color
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _applyFilters,
                icon: const Icon(Icons.search, size: 16),
                label: const Text('Apply'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}