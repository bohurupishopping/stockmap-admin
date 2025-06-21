import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/sale_models.dart';

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

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD1D5DB)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today,
              size: 16,
              color: Color(0xFF6B7280),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                date != null ? _dateFormat.format(date) : label,
                style: TextStyle(
                  color: date != null
                      ? const Color(0xFF374151)
                      : const Color(0xFF9CA3AF),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<String>(
        value: '${widget.sortField}_${widget.sortDirection}',
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          hintText: 'Select sort option',
          hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
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
        style: const TextStyle(
          color: Color(0xFF374151),
          fontSize: 14,
        ),
        dropdownColor: Colors.white,
        icon: const Icon(
          Icons.keyboard_arrow_down,
          color: Color(0xFF6B7280),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Sales',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Search
            const Text(
              'Search',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by product name...',
                hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF6B7280)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF3B82F6)),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                _applyFilters();
              },
            ),
            const SizedBox(height: 20),
            
            // Sort
            const Text(
              'Sort By',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 12),
            _buildSortDropdown(),
            const SizedBox(height: 20),
            
            // Additional Filters
            const Text(
              'Additional Filters',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _batchController,
                    decoration: InputDecoration(
                      labelText: 'Batch Number',
                      labelStyle: const TextStyle(color: Color(0xFF6B7280)),
                      hintText: 'Enter batch number',
                      hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF3B82F6)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      labelStyle: const TextStyle(color: Color(0xFF6B7280)),
                      hintText: 'Enter reference ID',
                      hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF3B82F6)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (value) => _applyFilters(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _transactionTypeController,
              decoration: InputDecoration(
                labelText: 'Transaction Type',
                labelStyle: const TextStyle(color: Color(0xFF6B7280)),
                hintText: 'Enter transaction type',
                hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF3B82F6)),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) => _applyFilters(),
            ),
            const SizedBox(height: 20),
            
            // Date Range
            const Text(
              'Date Range',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDateField(
                    label: 'From Date',
                    date: _startDate,
                    onTap: () => _selectDate(context, true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDateField(
                    label: 'To Date',
                    date: _endDate,
                    onTap: () => _selectDate(context, false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clearFilters,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Color(0xFFD1D5DB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Clear All',
                      style: TextStyle(
                        color: Color(0xFF374151),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}