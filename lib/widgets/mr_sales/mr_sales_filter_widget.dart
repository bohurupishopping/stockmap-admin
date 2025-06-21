import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/mr_sale_models.dart';
import '../../services/mr_sale_service.dart';

class MRSalesFilterWidget extends StatefulWidget {
  final MRSalesFilters? currentFilters;
  final Function(MRSalesFilters?) onFiltersChanged;

  const MRSalesFilterWidget({
    super.key,
    this.currentFilters,
    required this.onFiltersChanged,
  });

  @override
  State<MRSalesFilterWidget> createState() => _MRSalesFilterWidgetState();
}

class _MRSalesFilterWidgetState extends State<MRSalesFilterWidget> {
  final MRSaleService _mrSaleService = MRSaleService();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  
  DateTime? _dateFrom;
  DateTime? _dateTo;
  String? _selectedMRUserId = '';
  String? _selectedPaymentStatus;
  
  List<Map<String, dynamic>> _mrUsers = [];
  bool _isLoadingMRUsers = false;
  
  final List<Map<String, String>> _paymentStatusOptions = [
    {'value': 'paid', 'label': 'Paid'},
    {'value': 'pending', 'label': 'Pending'},
    {'value': 'partial', 'label': 'Partial'},
  ];
  
  @override
  void initState() {
    super.initState();
    _initializeFilters();
    _loadMRUsers();
  }
  
  void _initializeFilters() {
    if (widget.currentFilters != null) {
      _dateFrom = widget.currentFilters!.dateFrom;
      _dateTo = widget.currentFilters!.dateTo;
      _selectedMRUserId = widget.currentFilters!.mrUserId ?? '';
      _selectedPaymentStatus = widget.currentFilters!.paymentStatus;
    }
  }
  
  Future<void> _loadMRUsers() async {
    setState(() {
      _isLoadingMRUsers = true;
    });
    
    try {
      final users = await _mrSaleService.getMRUsers();
      setState(() {
        _mrUsers = users;
        _isLoadingMRUsers = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMRUsers = false;
      });
    }
  }
  
  void _applyFilters() {
    final filters = MRSalesFilters(
      dateFrom: _dateFrom,
      dateTo: _dateTo,
      mrUserId: _selectedMRUserId?.isEmpty == true ? null : _selectedMRUserId,
      paymentStatus: _selectedPaymentStatus,
    );
    
    widget.onFiltersChanged(filters);
    Navigator.of(context).pop();
  }
  
  void _clearFilters() {
    setState(() {
      _dateFrom = null;
      _dateTo = null;
      _selectedMRUserId = '';
      _selectedPaymentStatus = null;
    });
    
    widget.onFiltersChanged(null);
    Navigator.of(context).pop();
  }
  
  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFromDate 
          ? (_dateFrom ?? DateTime.now())
          : (_dateTo ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _dateFrom = picked;
          // Ensure dateTo is not before dateFrom
          if (_dateTo != null && _dateTo!.isBefore(picked)) {
            _dateTo = picked;
          }
        } else {
          _dateTo = picked;
          // Ensure dateFrom is not after dateTo
          if (_dateFrom != null && _dateFrom!.isAfter(picked)) {
            _dateFrom = picked;
          }
        }
      });
    }
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
                  'Filter MR Sales',
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
                    date: _dateFrom,
                    onTap: () => _selectDate(context, true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDateField(
                    label: 'To Date',
                    date: _dateTo,
                    onTap: () => _selectDate(context, false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // MR User
            const Text(
              'MR User',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 12),
            _buildMRUserDropdown(),
            const SizedBox(height: 20),
            
            // Payment Status
            const Text(
              'Payment Status',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 12),
            _buildPaymentStatusDropdown(),
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
  
  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD1D5DB)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date != null 
                      ? _dateFormat.format(date)
                      : 'Select date',
                  style: TextStyle(
                    fontSize: 14,
                    color: date != null 
                        ? const Color(0xFF1F2937)
                        : const Color(0xFF9CA3AF),
                  ),
                ),
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Color(0xFF6B7280),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMRUserDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _isLoadingMRUsers
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          : DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedMRUserId,
                hint: const Text(
                  'Select MR User',
                  style: TextStyle(color: Color(0xFF9CA3AF)),
                ),
                isExpanded: true,
                items: [
                  const DropdownMenuItem<String>(
                    value: '',
                    child: Text('All MR Users'),
                  ),
                  ..._mrUsers.map((user) {
                    return DropdownMenuItem<String>(
                      value: user['id'],
                      child: Text(user['name'] ?? user['email'] ?? 'Unknown'),
                    );
                  }),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedMRUserId = value;
                  });
                },
              ),
            ),
    );
  }
  
  Widget _buildPaymentStatusDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedPaymentStatus,
          hint: const Text(
            'Select Payment Status',
            style: TextStyle(color: Color(0xFF9CA3AF)),
          ),
          isExpanded: true,
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('All Statuses'),
            ),
            ..._paymentStatusOptions.map((status) {
              return DropdownMenuItem<String>(
                value: status['value'],
                child: Text(status['label']!),
              );
            }),
          ],
          onChanged: (value) {
            setState(() {
              _selectedPaymentStatus = value;
            });
          },
        ),
      ),
    );
  }
}