import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/doctor_service.dart';
import '../models/doctor_models.dart';
import '../widgets/doctor/doctor_filter_widget.dart';
import '../widgets/doctor/doctor_table_row.dart';
import '../widgets/doctor/doctor_details_dialog.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/footer_nav_bar.dart';

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  final DoctorService _doctorService = DoctorService();
  final ScrollController _scrollController = ScrollController();
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  
  List<Doctor> _doctors = [];
  Map<String, dynamic>? _summary;

  DoctorFilters? _filters;
  String _searchQuery = '';
  final String _sortField = 'created_at';
  final String _sortDirection = 'desc';
  
  bool _isLoading = false;
  bool _hasMoreData = true;
  bool _isSearchFilterVisible = false;
  String? _error;
  
  int _currentPage = 1;
  final int _itemsPerPage = 20;
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadData();
    _loadSummary();
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreData();
    }
  }
  
  Future<void> _loadData({bool isRefresh = false}) async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
      _error = null;
      if (isRefresh) {
        _currentPage = 1;
        _doctors.clear();
        _hasMoreData = true;
      }
    });
    
    try {
      final doctors = await _doctorService.fetchDoctors(
        page: _currentPage,
        limit: _itemsPerPage,
        searchQuery: _searchQuery.isNotEmpty ? _searchQuery : null,
        filters: _filters,
        sortField: _sortField,
        sortDirection: _sortDirection,
      );
      
      setState(() {
        if (_currentPage == 1) {
          _doctors = doctors;
        } else {
          _doctors.addAll(doctors);
        }
        _hasMoreData = doctors.length == _itemsPerPage;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadSummary() async {
    try {
      final summary = await _doctorService.getDoctorsSummary(
        filters: _filters,
      );
      
      setState(() {
        _summary = summary;
      });
    } catch (e) {
      // Handle summary error silently
    }
  }
  
  Future<void> _loadMoreData() async {
    if (_isLoading || !_hasMoreData) return;
    
    _currentPage++;
    await _loadData();
  }
  
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _debounceSearch();
  }
  
  void _debounceSearch() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _loadData(isRefresh: true);
      }
    });
  }
  
  void _onFiltersChanged(DoctorFilters? filters) {
    setState(() {
      _filters = filters;
    });
    _loadData(isRefresh: true);
    _loadSummary();
  }

  void _showDoctorDetails(Doctor doctor) {
    showDialog(
      context: context,
      builder: (context) => DoctorDetailsDialog(
        doctor: doctor,
        dateFormat: _dateFormat,
        onDoctorUpdate: () {
          _loadData(isRefresh: true);
          _loadSummary();
        },
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Doctors',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1F2937)),
        actions: [
          IconButton(
            icon: Icon(
              _isSearchFilterVisible ? Icons.close : Icons.search,
              color: const Color(0xFF1F2937),
            ),
            onPressed: () {
              setState(() {
                _isSearchFilterVisible = !_isSearchFilterVisible;
                if (!_isSearchFilterVisible) {
                  _searchQuery = '';
                  _loadData(isRefresh: true);
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.filter_list,
              color: Color(0xFF1F2937),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => DoctorFilterWidget(
                  currentFilters: _filters,
                  onFiltersChanged: _onFiltersChanged,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Color(0xFF1F2937),
            ),
            onPressed: () {
              // TODO: Implement add doctor functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Add doctor functionality coming soon'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: _isLoading && _doctors.isEmpty,
        child: Column(
          children: [
            // Summary Cards
            if (_summary != null) _buildSummaryCards(),
            
            // Search Bar
            if (_isSearchFilterVisible) _buildSearchBar(),
            
            // Error Message
            if (_error != null) _buildErrorMessage(),
            
            // Doctors List
            Expanded(
              child: _doctors.isEmpty && !_isLoading
                  ? _buildEmptyState()
                  : _buildDoctorsList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const FooterNavBar(currentRoute: '/dashboard/doctors'),
    );
  }

  Widget _buildSummaryCards() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Total Doctors',
                  _summary!['total_doctors'].toString(),
                  const Color(0xFF3B82F6),
                  Icons.people,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Active',
                  _summary!['active_doctors'].toString(),
                  const Color(0xFF059669),
                  Icons.check_circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Inactive',
                  _summary!['inactive_doctors'].toString(),
                  const Color(0xFF6B7280),
                  Icons.pause_circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Tier A',
                  _summary!['tier_a_count'].toString(),
                  const Color(0xFF059669),
                  Icons.star,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Tier B',
                  _summary!['tier_b_count'].toString(),
                  const Color(0xFFF59E0B),
                  Icons.star_half,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Tier C',
                  _summary!['tier_c_count'].toString(),
                  const Color(0xFFDC2626),
                  Icons.star_border,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        onChanged: _onSearchChanged,
        decoration: const InputDecoration(
          hintText: 'Search by doctor name, specialty, or clinic...',
          prefixIcon: Icon(Icons.search, color: Color(0xFF6B7280)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
  
  Widget _buildErrorMessage() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error, color: Color(0xFFDC2626)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _error!,
              style: const TextStyle(color: Color(0xFFDC2626)),
            ),
          ),
          TextButton(
            onPressed: () => _loadData(isRefresh: true),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_hospital,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No doctors found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDoctorsList() {
    return RefreshIndicator(
      onRefresh: () => _loadData(isRefresh: true),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: _doctors.length + (_hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _doctors.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }
          
          final doctor = _doctors[index];
          return DoctorTableRow(
            doctor: doctor,
            dateFormat: _dateFormat,
            onTap: () => _showDoctorDetails(doctor),
          );
        },
      ),
    );
  }
}