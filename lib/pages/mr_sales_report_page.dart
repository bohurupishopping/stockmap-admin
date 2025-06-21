import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/mr_sale_service.dart';
import '../models/mr_sale_models.dart';
import '../widgets/mr_sales/mr_sales_filter_widget.dart';
import '../widgets/mr_sales/mr_sales_table_row.dart';
import '../widgets/mr_sales/mr_sales_details_dialog.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/footer_nav_bar.dart';

class MRSalesReportPage extends StatefulWidget {
  const MRSalesReportPage({super.key});

  @override
  State<MRSalesReportPage> createState() => _MRSalesReportPageState();
}

class _MRSalesReportPageState extends State<MRSalesReportPage> {
  final MRSaleService _mrSaleService = MRSaleService();
  final ScrollController _scrollController = ScrollController();
  final NumberFormat _currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 2);
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  
  List<MRSalesOrder> _orders = [];
  Map<String, dynamic>? _summary;

  MRSalesFilters? _filters;
  String _searchQuery = '';
  final String _sortField = 'order_date';
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
        _orders.clear();
        _hasMoreData = true;
      }
    });
    
    try {
      final orders = await _mrSaleService.fetchMRSales(
        page: _currentPage,
        limit: _itemsPerPage,
        searchQuery: _searchQuery.isNotEmpty ? _searchQuery : null,
        filters: _filters,
        sortField: _sortField,
        sortDirection: _sortDirection,
      );
      
      setState(() {
        if (_currentPage == 1) {
          _orders = orders;
        } else {
          _orders.addAll(orders);
        }
        _hasMoreData = orders.length == _itemsPerPage;
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
      final summary = await _mrSaleService.getMRSalesSummary(
        dateFrom: _filters?.dateFrom,
        dateTo: _filters?.dateTo,
        mrUserId: _filters?.mrUserId,
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
  
  void _onFiltersChanged(MRSalesFilters? filters) {
    setState(() {
      _filters = filters;
    });
    _loadData(isRefresh: true);
    _loadSummary();
  }
  

  void _showOrderDetails(MRSalesOrder order) {
    showDialog(
      context: context,
      builder: (context) => MRSalesDetailsDialog(
        order: order,
        currencyFormat: _currencyFormat,
        dateFormat: _dateFormat,
        onPaymentStatusUpdate: (orderId, status) async {
          final messenger = ScaffoldMessenger.of(context);
          try {
            await _mrSaleService.updatePaymentStatus(orderId, status);
            _loadData(isRefresh: true);
            _loadSummary();
            if (mounted) {
              messenger.showSnackBar(
                const SnackBar(
                  content: Text('Payment status updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              messenger.showSnackBar(
                SnackBar(
                  content: Text('Failed to update payment status: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: LoadingOverlay(
                isLoading: _isLoading && _orders.isEmpty,
                child: Column(
                  children: [
                    // Summary Cards
                    if (_summary != null) _buildSummaryCards(),
                    
                    // Error Message
                    if (_error != null) _buildErrorMessage(),
                    
                    // Orders List
                    Expanded(
                      child: _orders.isEmpty && !_isLoading
                          ? _buildEmptyState()
                          : _buildOrdersList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const FooterNavBar(currentRoute: '/dashboard/mr-sales'),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6366f1),
            Color(0xFF8b5cf6),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  // Icon and title
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.receipt_long,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'MR Sales Report',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Track sales performance',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Search button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _isSearchFilterVisible = !_isSearchFilterVisible;
                          if (!_isSearchFilterVisible) {
                            _searchQuery = '';
                            _loadData(isRefresh: true);
                          }
                        });
                      },
                      icon: Icon(
                        _isSearchFilterVisible ? Icons.close : Icons.search,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Filter button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => MRSalesFilterWidget(
                            currentFilters: _filters,
                            onFiltersChanged: _onFiltersChanged,
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.filter_list,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Collapsible Search Section
            if (_isSearchFilterVisible)
              _buildSearchAndFilters(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: _onSearchChanged,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search by customer name or MR name...',
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
          prefixIcon: Icon(Icons.search_rounded, color: Colors.white.withValues(alpha: 0.7)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white),
          ),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.1),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Total Sales',
              _currencyFormat.format(_summary!['total_sales']),
              const Color(0xFF3B82F6),
              Icons.trending_up,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Paid',
              _currencyFormat.format(_summary!['paid_amount']),
              const Color(0xFF059669),
              Icons.check_circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Pending',
              _currencyFormat.format(_summary!['pending_amount']),
              const Color(0xFFF59E0B),
              Icons.pending,
            ),
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
            Icons.receipt_long,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No MR sales found',
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
  
  Widget _buildOrdersList() {
    return RefreshIndicator(
      onRefresh: () => _loadData(isRefresh: true),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: _orders.length + (_hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _orders.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }
          
          final order = _orders[index];
          return MRSalesTableRow(
            order: order,
            currencyFormat: _currencyFormat,
            dateFormat: _dateFormat,
            onTap: () => _showOrderDetails(order),
          );
        },
      ),
    );
  }
}