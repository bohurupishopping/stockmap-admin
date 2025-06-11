import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/sale_service.dart';
import '../models/sale_models.dart';
import '../widgets/sale/sale_summary_card.dart';
import '../widgets/sale/sale_filter_widget.dart';
import '../widgets/sale/sale_table_header.dart';
import '../widgets/sale/sale_table_row.dart';
import '../widgets/sale/sale_details_dialog.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/footer_nav_bar.dart';

class SalePage extends StatefulWidget {
  const SalePage({super.key});

  @override
  State<SalePage> createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  final SaleService _saleService = SaleService();
  final ScrollController _scrollController = ScrollController();
  final NumberFormat _currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 2);
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  
  List<SaleTransaction> _transactions = [];
  SaleSummary? _summary;
  SaleFilters? _filters;
  String _searchQuery = '';
  String _sortField = 'sale_date';
  String _sortDirection = 'desc';
  
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
        _transactions.clear();
        _hasMoreData = true;
      }
    });
    
    try {
      final transactions = await _saleService.fetchSales(
        page: _currentPage,
        limit: _itemsPerPage,
        searchQuery: _searchQuery.isNotEmpty ? _searchQuery : null,
        filters: _filters,
        sortField: _sortField,
        sortDirection: _sortDirection,
      );
      
      SaleSummary? summary;
      if (_currentPage == 1) {
        summary = await _saleService.getSaleSummary(
          searchQuery: _searchQuery.isNotEmpty ? _searchQuery : null,
          filters: _filters,
        );
      }
      
      setState(() {
        if (_currentPage == 1) {
          _transactions = transactions;
        } else {
          _transactions.addAll(transactions);
        }
        _summary = summary;
        _hasMoreData = transactions.length == _itemsPerPage;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }
  
  Future<void> _loadMoreData() async {
    if (_isLoading || !_hasMoreData) return;
    
    setState(() {
      _currentPage++;
    });
    
    await _loadData();
  }
  
  void _onSort(String field) {
    setState(() {
      if (_sortField == field) {
        _sortDirection = _sortDirection == 'asc' ? 'desc' : 'asc';
      } else {
        _sortField = field;
        _sortDirection = 'desc';
      }
    });
    _loadData(isRefresh: true);
  }
  
  void _onFiltersChanged(SaleFilters? filters) {
    setState(() {
      _filters = filters;
    });
    _loadData(isRefresh: true);
  }
  
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () => _loadData(isRefresh: true),
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // Header
                  SliverToBoxAdapter(
                    child: _buildHeader(),
                  ),
                  
                  // Summary Card
                  if (_summary != null)
                    SliverToBoxAdapter(
                      child: SaleSummaryCard(
                        summary: _summary!,
                        currencyFormat: _currencyFormat,
                        dateFormat: _dateFormat,
                      ),
                    ),
                  
                  // Content
                  SliverToBoxAdapter(
                    child: _buildContent(),
                  ),
                  
                  // Transaction Table
                  if (_transactions.isNotEmpty) ...[
                    // Table Header
                    SliverToBoxAdapter(
                      child: SaleTableHeader(
                        sortField: _sortField,
                        sortDirection: _sortDirection,
                        onSort: _onSort,
                      ),
                    ),
                    
                    // Transaction List
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index < _transactions.length) {
                            return SaleTableRow(
                              transaction: _transactions[index],
                              currencyFormat: _currencyFormat,
                              dateFormat: _dateFormat,
                              onTap: () => _showTransactionDetails(_transactions[index]),
                            );
                          } else if (_hasMoreData) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          return null;
                        },
                        childCount: _transactions.length + (_hasMoreData ? 1 : 0),
                      ),
                    ),
                  ],
                  
                  // Bottom spacing
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 100),
                  ),
                ],
              ),
            ),
            
            // Loading overlay
            if (_isLoading && _transactions.isEmpty)
              const LoadingOverlay(
                isLoading: true,
                child: SizedBox.shrink(),
              ),
          ],
        ),
      ),
      bottomNavigationBar: const FooterNavBar(currentRoute: '/sale'),
    );
  }
  
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1e40af),
            Color(0xFF3b82f6),
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
                      Icons.point_of_sale,
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
                          'Sales',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Track sale transactions',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Search/Filter toggle button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _isSearchFilterVisible = !_isSearchFilterVisible;
                        });
                      },
                      icon: Icon(
                        _isSearchFilterVisible ? Icons.filter_list_off : Icons.filter_list,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Refresh button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () => _loadData(isRefresh: true),
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Collapsible Search and Filter Section
            if (_isSearchFilterVisible)
              SaleFilterWidget(
                initialFilters: _filters,
                onFiltersChanged: _onFiltersChanged,
                searchQuery: _searchQuery,
                onSearchChanged: _onSearchChanged,
                sortField: _sortField,
                sortDirection: _sortDirection,
                onSortChanged: _onSort,
              ),
          ],
        ),
      )
    );
  }
  
  Widget _buildContent() {
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading sales',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              SelectableText.rich(
                TextSpan(
                  text: _error!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _loadData(isRefresh: true),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    
    if (_transactions.isEmpty && !_isLoading) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.point_of_sale_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No sales found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _filters?.hasActiveFilters == true
                    ? 'Try adjusting your filters'
                    : 'No sale transactions available',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    return const SizedBox.shrink();
  }
  
  void _showTransactionDetails(SaleTransaction transaction) {
    showDialog(
      context: context,
      builder: (context) => SaleDetailsDialog(
        transaction: transaction,
        currencyFormat: _currencyFormat,
        dateFormat: _dateFormat,
      ),
    );
  }
}