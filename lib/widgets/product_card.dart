import 'package:flutter/material.dart';
import '../models/product_models.dart';
import 'product_details_dialog.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Clean modern color palette - avoiding pinkish tones
    const primaryColor = Color(0xFF2563EB); // Blue
    const accentColor = Color(0xFF059669); // Green
    const surfaceColor = Colors.white;
    Theme.of(context);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 400;
        
        return GestureDetector(
          onTap: onTap ?? () => _showProductDetails(context),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Compact Header Section
                Container(
                  height: isCompact ? 85 : 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primaryColor.withValues(alpha: 0.05),
                        Colors.grey.shade50,
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Main content with image on left and details on right
                      Padding(
                        padding: EdgeInsets.all(isCompact ? 10 : 12),
                        child: Row(
                          children: [
                            // Product Image - left side
                            Container(
                              width: isCompact ? 55 : 65,
                              height: isCompact ? 55 : 65,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: product.imageUrl?.isNotEmpty == true
                                    ? Image.network(
                                        product.imageUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return _buildPlaceholderIcon(isCompact);
                                        },
                                      )
                                    : _buildPlaceholderIcon(isCompact),
                              ),
                            ),
                            
                            const SizedBox(width: 12),
                            
                            // Product details - right side
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Product Code
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      product.productCode,
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: isCompact ? 10 : 11,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 6),
                                  
                                  // Product Name
                                  Text(
                                    product.productName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: isCompact ? 13 : 15,
                                      height: 1.2,
                                      color: Colors.grey.shade800,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  
                                  const SizedBox(height: 2),
                                  
                                  // Generic Name
                                  Text(
                                    product.genericName,
                                    style: TextStyle(
                                      fontSize: isCompact ? 10 : 11,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey.shade600,
                                      height: 1.2,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Compact Status Badge
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: product.isActive
                                ? accentColor.withValues(alpha: 0.1)
                                : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            product.isActive ? 'Active' : 'Inactive',
                            style: TextStyle(
                              color: product.isActive
                                  ? accentColor
                                  : Colors.red.shade600,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Compact Content Section
                Padding(
                  padding: EdgeInsets.all(isCompact ? 12 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Compact Key Info Grid
                      _buildInfoGrid(context, isCompact),
                      
                      SizedBox(height: isCompact ? 10 : 12),
                      
                      // Compact Stock Levels
                      _buildStockSection(context, isCompact),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showProductDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ProductDetailsDialog(product: product),
    );
  }

  Widget _buildPlaceholderIcon(bool isCompact) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        Icons.medical_services_rounded,
        color: Colors.grey.shade400,
        size: isCompact ? 24 : 28,
      ),
    );
  }

  Widget _buildInfoGrid(BuildContext context, bool isCompact) {
    
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildInfoItem(
                Icons.business_rounded,
                'Manufacturer',
                product.manufacturer,
                isCompact,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildInfoItem(
                Icons.category_rounded,
                'Category',
                product.categoryName ?? 'N/A',
                isCompact,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildInfoItem(
                Icons.currency_rupee_rounded,
                'Cost/Strip',
                '₹${product.baseCostPerStrip.toStringAsFixed(2)}',
                isCompact,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildInfoItem(
                Icons.medical_services_rounded,
                'Formulation',
                product.formulationName ?? 'N/A',
                isCompact,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String label,
    String value,
    bool isCompact,
  ) {
    const primaryColor = Color(0xFF2563EB);
    
    return Container(
      padding: EdgeInsets.all(isCompact ? 8 : 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: isCompact ? 12 : 14,
                color: primaryColor,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: isCompact ? 9 : 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: isCompact ? 11 : 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStockSection(BuildContext context, bool isCompact) {
    
    return Container(
      padding: EdgeInsets.all(isCompact ? 10 : 12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.shade100,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Stock levels row
          Row(
            children: [
              Expanded(
                child: _buildStockLevel(
                  'Godown Stock',
                  product.formattedGodownStock,
                  Icons.warehouse_rounded,
                  isCompact,
                ),
              ),
              Container(
                width: 1,
                height: 24,
                color: Colors.grey.shade300,
              ),
              Expanded(
                child: _buildStockLevel(
                  'MR Stock',
                  product.formattedMrStock,
                  Icons.person_rounded,
                  isCompact,
                ),
              ),
            ],
          ),
          if (!isCompact && product.totalClosingStock > 0) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_rounded,
                    size: 12,
                    color: Colors.green.shade700,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Total: ${product.formattedTotalStock}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStockLevel(
    String label,
    String formattedValue,
    IconData icon,
    bool isCompact,
  ) {
    const accentColor = Color(0xFF059669);
    
    return Column(
      children: [
        Icon(
          icon,
          size: isCompact ? 14 : 16,
          color: accentColor,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: isCompact ? 9 : 10,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          formattedValue,
          style: TextStyle(
            fontSize: isCompact ? 10 : 11,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade800,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}