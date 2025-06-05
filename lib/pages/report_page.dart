import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/product_models.dart';
import '../services/product_service.dart';

import '../widgets/loading_overlay.dart';
import '../widgets/report_widgets.dart';
import '../widgets/footer_nav_bar.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final TextEditingController _searchController = TextEditingController();
  final NumberFormat _currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 2);
  bool _isSearchFilterVisible = false;
  bool _isLoading = true;
  String _error = '';
  
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  String _searchQuery = '';
  String _sortField = 'product_name';
  String _sortDirection = 'asc';
  String _selectedCategory = 'all';
  String _stockFilter = 'all'; // all, low_stock, out_of_stock, in_stock
  
  // Summary data
  int _totalProducts = 0;
  int _lowStockProducts = 0;
  int _outOfStockProducts = 0;
  double _totalStockValue = 0.0;
  
  @override
  void initState() {
    super.initState();
    _loadReportData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadReportData() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final result = await ProductService.getProducts(
        limit: 1000, // Get all products for report
        sortField: _sortField,
        sortDirection: _sortDirection,
      );
      
      final products = result['products'] as List<Product>;
      
      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _calculateSummary();
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load report data: $e';
        _isLoading = false;
      });
    }
  }

  void _calculateSummary() {
    _totalProducts = _allProducts.length;
    _lowStockProducts = 0;
    _outOfStockProducts = 0;
    _totalStockValue = 0.0;
    
    for (final product in _allProducts) {
      final totalStock = product.totalClosingStock;
      final minStock = product.minStockLevelGodown + product.minStockLevelMr;
      
      if (totalStock == 0) {
        _outOfStockProducts++;
      } else if (totalStock <= minStock) {
        _lowStockProducts++;
      }
      
      _totalStockValue += totalStock * product.baseCostPerStrip;
    }
  }

  void _applyFilters() {
    List<Product> filtered = List.from(_allProducts);
    
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((product) {
        return product.productName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               product.productCode.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               product.genericName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               product.manufacturer.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
    
    // Apply category filter
    if (_selectedCategory != 'all') {
      filtered = filtered.where((product) => product.categoryId == _selectedCategory).toList();
    }
    
    // Apply stock filter
    if (_stockFilter != 'all') {
      filtered = filtered.where((product) {
        final totalStock = product.totalClosingStock;
        final minStock = product.minStockLevelGodown + product.minStockLevelMr;
        
        switch (_stockFilter) {
          case 'out_of_stock':
            return totalStock == 0;
          case 'low_stock':
            return totalStock > 0 && totalStock <= minStock;
          case 'in_stock':
            return totalStock > minStock;
          default:
            return true;
        }
      }).toList();
    }
    
    // Apply sorting
    filtered.sort((a, b) {
      int comparison = 0;
      
      switch (_sortField) {
        case 'product_name':
          comparison = a.productName.compareTo(b.productName);
          break;
        case 'total_stock':
          comparison = a.totalClosingStock.compareTo(b.totalClosingStock);
          break;
        case 'stock_value':
          final aValue = a.totalClosingStock * a.baseCostPerStrip;
          final bValue = b.totalClosingStock * b.baseCostPerStrip;
          comparison = aValue.compareTo(bValue);
          break;
        case 'category':
          comparison = (a.categoryName ?? '').compareTo(b.categoryName ?? '');
          break;
        default:
          comparison = a.productName.compareTo(b.productName);
      }
      
      return _sortDirection == 'asc' ? comparison : -comparison;
    });
    
    setState(() {
      _filteredProducts = filtered;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
    _applyFilters();
  }

  void _onSortChanged(String field, String direction) {
    setState(() {
      _sortField = field;
      _sortDirection = direction;
    });
    _applyFilters();
  }

  void _onCategoryChanged(String categoryId) {
    setState(() {
      _selectedCategory = categoryId;
    });
    _applyFilters();
  }

  void _onStockFilterChanged(String filter) {
    setState(() {
      _stockFilter = filter;
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildContent(),
                  const SizedBox(height: 100), // Space for bottom navigation
                ],
              ),
            ),
            if (_isLoading) const LoadingOverlay(
              isLoading: true,
              child: SizedBox.shrink(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const FooterNavBar(currentRoute: '/report'),
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
                      Icons.assessment_outlined,
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
                          'Stock Report',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Comprehensive stock analysis',
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
                      onPressed: _loadReportData,
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
              ReportFilters(
                searchController: _searchController,
                searchQuery: _searchQuery,
                sortField: _sortField,
                sortDirection: _sortDirection,
                selectedCategory: _selectedCategory,
                stockFilter: _stockFilter,
                onSearchChanged: _onSearchChanged,
                onSortChanged: _onSortChanged,
                onCategoryChanged: _onCategoryChanged,
                onStockFilterChanged: _onStockFilterChanged,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_error.isNotEmpty) {
      return _buildErrorState();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Summary Cards
          ReportSummaryCards(
            totalProducts: _totalProducts,
            lowStockProducts: _lowStockProducts,
            outOfStockProducts: _outOfStockProducts,
            totalStockValue: _totalStockValue,
            currencyFormat: _currencyFormat,
          ),
          // Stock Report List
          _buildStockReportList(),
        ],
      ),
    );
  }

  Widget _buildStockReportList() {
    if (_filteredProducts.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: RefreshIndicator(
        color: const Color(0xFF6366f1),
        onRefresh: _loadReportData,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: _filteredProducts.length,
          itemBuilder: (context, index) {
            final product = _filteredProducts[index];
            return StockReportCard(
              product: product,
              currencyFormat: _currencyFormat,
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF6366f1).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                size: 60,
                color: Color(0xFF6366f1),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No products found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1e293b),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or search criteria',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.error_outline,
                size: 60,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Error Loading Report',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1e293b),
              ),
            ),
            const SizedBox(height: 8),
            SelectableText.rich(
              TextSpan(
                text: _error,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadReportData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366f1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}