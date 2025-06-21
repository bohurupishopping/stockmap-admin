import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/doctor_models.dart';
import '../../services/doctor_service.dart';

class DoctorFilterWidget extends StatefulWidget {
  final DoctorFilters? currentFilters;
  final Function(DoctorFilters?) onFiltersChanged;

  const DoctorFilterWidget({
    super.key,
    this.currentFilters,
    required this.onFiltersChanged,
  });

  @override
  State<DoctorFilterWidget> createState() => _DoctorFilterWidgetState();
}

class _DoctorFilterWidgetState extends State<DoctorFilterWidget> {
  final DoctorService _doctorService = DoctorService();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  
  String? _selectedTier;
  String? _selectedMRUserId;
  bool? _selectedIsActive;
  String? _selectedSpecialty;
  DateTime? _dateFrom;
  DateTime? _dateTo;
  
  List<Map<String, dynamic>> _mrProfiles = [];
  List<String> _specialties = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _initializeFilters();
    _loadFilterData();
  }
  
  void _initializeFilters() {
    if (widget.currentFilters != null) {
      _selectedTier = widget.currentFilters!.tier;
      _selectedMRUserId = widget.currentFilters!.mrUserId;
      _selectedIsActive = widget.currentFilters!.isActive;
      _selectedSpecialty = widget.currentFilters!.specialty;
      _dateFrom = widget.currentFilters!.dateFrom;
      _dateTo = widget.currentFilters!.dateTo;
    }
  }
  
  Future<void> _loadFilterData() async {
    try {
      final futures = await Future.wait([
        _doctorService.getMRProfiles(),
        _doctorService.getSpecialties(),
      ]);
      
      setState(() {
        _mrProfiles = futures[0] as List<Map<String, dynamic>>;
        _specialties = futures[1] as List<String>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  void _applyFilters() {
    final filters = DoctorFilters(
      tier: _selectedTier,
      mrUserId: _selectedMRUserId,
      isActive: _selectedIsActive,
      specialty: _selectedSpecialty,
      dateFrom: _dateFrom,
      dateTo: _dateTo,
    );
    
    widget.onFiltersChanged(filters);
    Navigator.of(context).pop();
  }
  
  void _clearFilters() {
    setState(() {
      _selectedTier = null;
      _selectedMRUserId = null;
      _selectedIsActive = null;
      _selectedSpecialty = null;
      _dateFrom = null;
      _dateTo = null;
    });
  }
  
  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFromDate 
          ? (_dateFrom ?? DateTime.now())
          : (_dateTo ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _dateFrom = picked;
        } else {
          _dateTo = picked;
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Doctors',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                TextButton(
                  onPressed: _clearFilters,
                  child: const Text(
                    'Clear All',
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            )
          else
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tier Filter
                    _buildFilterSection(
                      'Tier',
                      DropdownButtonFormField<String>(
                        value: _selectedTier,
                        decoration: _inputDecoration('Select tier'),
                        items: const [
                          DropdownMenuItem<String>(value: 'A', child: Text('Tier A')),
                          DropdownMenuItem<String>(value: 'B', child: Text('Tier B')),
                          DropdownMenuItem<String>(value: 'C', child: Text('Tier C')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedTier = value;
                          });
                        },
                      ),
                    ),
                    
                    // Status Filter
                    _buildFilterSection(
                      'Status',
                      DropdownButtonFormField<bool>(
                        value: _selectedIsActive,
                        decoration: _inputDecoration('Select status'),
                        items: const [
                          DropdownMenuItem<bool>(value: true, child: Text('Active')),
                          DropdownMenuItem<bool>(value: false, child: Text('Inactive')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedIsActive = value;
                          });
                        },
                      ),
                    ),
                    
                    // Specialty Filter
                    if (_specialties.isNotEmpty)
                      _buildFilterSection(
                        'Specialty',
                        DropdownButtonFormField<String>(
                          value: _selectedSpecialty,
                          decoration: _inputDecoration('Select specialty'),
                          items: _specialties.map((specialty) {
                          return DropdownMenuItem<String>(
                            value: specialty,
                            child: Text(specialty),
                          );
                        }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedSpecialty = value;
                            });
                          },
                        ),
                      ),
                    
                    // MR Filter
                    if (_mrProfiles.isNotEmpty)
                      _buildFilterSection(
                        'Allotted MR',
                        DropdownButtonFormField<String>(
                          value: _selectedMRUserId,
                          decoration: _inputDecoration('Select MR'),
                          items: _mrProfiles.map((mr) {
                            return DropdownMenuItem<String>(
                              value: mr['user_id'],
                              child: Text(mr['name']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedMRUserId = value;
                            });
                          },
                        ),
                      ),
                    
                    // Date Range Filter
                    _buildFilterSection(
                      'Date Range',
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => _selectDate(context, true),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 16),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xFFE5E7EB)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.calendar_today, 
                                            size: 16, color: Color(0xFF6B7280)),
                                        const SizedBox(width: 8),
                                        Text(
                                          _dateFrom != null
                                              ? _dateFormat.format(_dateFrom!)
                                              : 'From date',
                                          style: TextStyle(
                                            color: _dateFrom != null
                                                ? const Color(0xFF1F2937)
                                                : const Color(0xFF6B7280),
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
                                        horizontal: 12, vertical: 16),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xFFE5E7EB)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.calendar_today, 
                                            size: 16, color: Color(0xFF6B7280)),
                                        const SizedBox(width: 8),
                                        Text(
                                          _dateTo != null
                                              ? _dateFormat.format(_dateTo!)
                                              : 'To date',
                                          style: TextStyle(
                                            color: _dateTo != null
                                                ? const Color(0xFF1F2937)
                                                : const Color(0xFF6B7280),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_dateFrom != null || _dateTo != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _dateFrom = null;
                                        _dateTo = null;
                                      });
                                    },
                                    child: const Text(
                                      'Clear dates',
                                      style: TextStyle(
                                        color: Color(0xFF6B7280),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          
          // Apply Button
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Apply Filters',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilterSection(String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
  
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF6B7280)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF3B82F6)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    );
  }
}