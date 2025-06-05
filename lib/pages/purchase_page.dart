// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/purchase_models.dart';
import '../services/purchase_service.dart';
import '../widgets/purchase_summary_card.dart';
import '../widgets/purchase_filter_widget.dart';
import '../widgets/purchase_table_row.dart';
import '../widgets/purchase_table_header.dart';
import '../widgets/purchase_details_dialog.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/footer_nav_bar.dart';

class PurchasePage extends StatefulWidget {
  const PurchasePage({super.key});

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  final PurchaseService _purchaseService = PurchaseService();
  final NumberFormat _currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 2);
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  
  List<PurchaseTransaction> _transactions = [];
  PurchaseSummary? _summary;
  bool _isLoading = true;
  String? _error;
  bool _isSearchFilterVisible = false;
  
  // Pagination
  int _currentPage = 1;
  final int _itemsPerPage = 20;

  bool _hasMoreData = true;
  
  // Sorting
  String _sortField = 'purchase_date';
  String _sortDirection = 'desc';
  
  // Filters
  PurchaseFilters? _filters;
  String _searchQuery = '';
  
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController.addListener(_onScroll);
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (_hasMoreData && !_isLoading) {
        _loadMoreData();
      }
    }
  }
  
  Future<void> _loadData({bool isRefresh = false}) async {
    if (isRefresh) {
      setState(() {
        _currentPage = 1;
        _transactions.clear();
        _hasMoreData = true;
      });
    }
    
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      final transactions = await _purchaseService.fetchPurchases(
        filters: _filters,
        sortField: _sortField,
        sortDirection: _sortDirection,
        page: _currentPage,
        limit: _itemsPerPage,
      );
      
      final summary = await _purchaseService.getPurchaseSummary(
        filters: _filters,
      );
      
      
      setState(() {
        if (isRefresh || _currentPage == 1) {
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
  
  void _onFiltersChanged(PurchaseFilters? filters) {
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
                      child: PurchaseSummaryCard(
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
                      child: PurchaseTableHeader(
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
                            return PurchaseTableRow(
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
      bottomNavigationBar: const FooterNavBar(currentRoute: '/purchase'),
    );
  }
  
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF10b981),
            Color(0xFF059669),
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
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.shopping_cart,
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
                          'Purchases',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Track purchase transactions',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Search/Filter toggle button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
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
                      color: Colors.white.withOpacity(0.2),
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
              PurchaseFilterWidget(
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
      ),
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
                'Error loading purchases',
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
                Icons.shopping_cart_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No purchases found',
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
                    : 'No purchase transactions available',
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
  
  void _showTransactionDetails(PurchaseTransaction transaction) {
    showDialog(
      context: context,
      builder: (context) => PurchaseDetailsDialog(
        transaction: transaction,
        currencyFormat: _currencyFormat,
        dateFormat: _dateFormat,
      ),
    );
  }
  
}