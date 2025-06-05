import 'dart:async';
import 'package:flutter/material.dart';
import '../models/product_models.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';
import '../widgets/product_details_dialog.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  static const int itemsPerPage = 20;
  
  final ProductFilters _filters = ProductFilters();
  int _currentPage = 1;
  List<Product> _products = [];
  bool _isLoading = false;
  bool _hasMoreData = true;
  int _totalCount = 0;
  
  // Filter data
  List<ProductCategory> _categories = [];
  List<ProductSubCategory> _subCategories = [];
  List<ProductFormulation> _formulations = [];
  List<String> _manufacturers = [];
  
  String _sortField = 'product_name';
  String _sortDirection = 'asc';
  
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMoreData) {
      _loadMoreProducts();
    }
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _loadFilterData(),
      _loadProducts(reset: true),
    ]);
  }

  Future<void> _loadFilterData() async {
    try {
      final results = await Future.wait([
        ProductService.getCategories(),
        ProductService.getFormulations(),
        ProductService.getManufacturers(),
      ]);

      setState(() {
        _categories = results[0] as List<ProductCategory>;
        _formulations = results[1] as List<ProductFormulation>;
        _manufacturers = results[2] as List<String>;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load filter data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadProducts({bool reset = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      if (reset) {
        _currentPage = 1;
        _products.clear();
        _hasMoreData = true;
      }
    });

    try {
      final result = await ProductService.getProducts(
        filters: _filters,
        page: _currentPage,
        limit: itemsPerPage,
        sortField: _sortField,
        sortDirection: _sortDirection,
      );

      final newProducts = result['products'] as List<Product>;
      final totalCount = result['totalCount'] as int;
      final hasMore = result['hasMore'] as bool;

      setState(() {
        if (reset) {
          _products = newProducts;
        } else {
          _products.addAll(newProducts);
        }
        _totalCount = totalCount;
        _hasMoreData = hasMore;
        _currentPage++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load products: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadMoreProducts() async {
    await _loadProducts();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _filters.searchQuery = value.isEmpty ? null : value;
    });
    _debounceSearch();
  }

  Timer? _debounceTimer;
  void _debounceSearch() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _loadProducts(reset: true);
    });
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFilterDialog(),
    );
  }

  void _showSortDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSortDialog(),
    );
  }

  void _onProductTap(Product product) {
    showDialog(
      context: context,
      builder: (context) => ProductDetailsDialog(product: product),
    );
  }

  // Add state variable for search/filter visibility
  bool _isSearchFilterVisible = false;

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
            if (_isLoading) const Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
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
                      Icons.inventory_rounded,
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
                          'Stock Management',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Manage your inventory',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Sort button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: _showSortDialog,
                      icon: const Icon(
                        Icons.sort_by_alpha,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
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
                      icon: Stack(
                        children: [
                          Icon(
                            _isSearchFilterVisible ? Icons.filter_list_off : Icons.filter_list,
                            color: Colors.white,
                            size: 24,
                          ),
                          if (_filters.hasActiveFilters)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
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
                      onPressed: () => _loadProducts(reset: true),
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
              _buildSearchAndFilters(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search products...',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
              prefixIcon: Icon(Icons.search_rounded, color: Colors.white.withValues(alpha: 0.7)),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.close_rounded, color: Colors.white.withValues(alpha: 0.7)),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                    )
                  : null,
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
          const SizedBox(height: 12),
          // Filter and Results Row
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _showFilterDialog,
                  icon: Stack(
                    children: [
                      const Icon(Icons.filter_alt, size: 18),
                      if (_filters.hasActiveFilters)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                  label: const Text('Filters'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (_totalCount > 0)
                Text(
                  'Found $_totalCount products',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              if (_filters.hasActiveFilters) ...[
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _filters.clear();
                      _searchController.clear();
                    });
                    _loadProducts(reset: true);
                  },
                  child: Text(
                    'Clear',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Products List
          _products.isEmpty && !_isLoading
              ? _buildEmptyState()
              : ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: _products.length + (_hasMoreData ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= _products.length) {
                      return _buildLoadingIndicator();
                    }
                    
                    final product = _products[index];
                    return ProductCard(
                      product: product,
                      onTap: () => _onProductTap(product),
                    );
                  },
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
            Icons.inventory_rounded,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildFilterDialog() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'Filter Products',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _filters.clear();
                    });
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Filter Options
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Filter
                  _buildFilterSection(
                    'Category',
                    DropdownButtonFormField<String>(
                      value: _filters.categoryId,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      hint: const Text('Select Category'),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('All Categories'),
                        ),
                        ..._categories.map(
                          (category) => DropdownMenuItem(
                            value: category.id,
                            child: Text(category.categoryName),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _filters.categoryId = value;
                          _filters.subCategoryId = null; // Reset subcategory
                        });
                        _loadSubCategories(value);
                      },
                    ),
                  ),
                  // Formulation Filter
                  _buildFilterSection(
                    'Formulation',
                    DropdownButtonFormField<String>(
                      value: _filters.formulationId,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      hint: const Text('Select Formulation'),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('All Formulations'),
                        ),
                        ..._formulations.map(
                          (formulation) => DropdownMenuItem(
                            value: formulation.id,
                            child: Text(formulation.formulationName),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _filters.formulationId = value;
                        });
                      },
                    ),
                  ),
                  // Manufacturer Filter
                  _buildFilterSection(
                    'Manufacturer',
                    DropdownButtonFormField<String>(
                      value: _filters.manufacturer,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      hint: const Text('Select Manufacturer'),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('All Manufacturers'),
                        ),
                        ..._manufacturers.map(
                          (manufacturer) => DropdownMenuItem(
                            value: manufacturer,
                            child: Text(manufacturer),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _filters.manufacturer = value;
                        });
                      },
                    ),
                  ),
                  // Status Filter
                  _buildFilterSection(
                    'Status',
                    DropdownButtonFormField<bool?>(
                      value: _filters.isActive,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      hint: const Text('Select Status'),
                      items: const [
                        DropdownMenuItem(
                          value: null,
                          child: Text('All Status'),
                        ),
                        DropdownMenuItem(
                          value: true,
                          child: Text('Active'),
                        ),
                        DropdownMenuItem(
                          value: false,
                          child: Text('Inactive'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _filters.isActive = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Apply Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _loadProducts(reset: true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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

  Widget _buildSortDialog() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Sort Products',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Divider(height: 1),
          // Sort Options
          ..._buildSortOptions(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<Widget> _buildSortOptions() {
    final sortOptions = [
      {'field': 'product_name', 'label': 'Product Name'},
      {'field': 'product_code', 'label': 'Product Code'},
      {'field': 'manufacturer', 'label': 'Manufacturer'},
      {'field': 'base_cost_per_strip', 'label': 'Cost per Strip'},
      {'field': 'created_at', 'label': 'Date Created'},
    ];

    return sortOptions.map((option) {
      final field = option['field']!;
      final label = option['label']!;
      
      return Column(
        children: [
          ListTile(
            title: Text(label),
            trailing: _sortField == field
                ? Icon(
                    _sortDirection == 'asc'
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    color: const Color(0xFF4F46E5),
                  )
                : null,
            onTap: () {
              setState(() {
                if (_sortField == field) {
                  _sortDirection = _sortDirection == 'asc' ? 'desc' : 'asc';
                } else {
                  _sortField = field;
                  _sortDirection = 'asc';
                }
              });
              Navigator.pop(context);
              _loadProducts(reset: true);
            },
          ),
          if (field != sortOptions.last['field']) const Divider(height: 1),
        ],
      );
    }).toList();
  }

  Widget _buildFilterSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        child,
        const SizedBox(height: 16),
      ],
    );
  }

  Future<void> _loadSubCategories(String? categoryId) async {
    if (categoryId == null) {
      setState(() {
        _subCategories.clear();
      });
      return;
    }

    try {
      final subCategories = await ProductService.getSubCategories(categoryId);
      setState(() {
        _subCategories = subCategories;
      });
    } catch (e) {
      // Handle error silently or show a message
    }
  }
}