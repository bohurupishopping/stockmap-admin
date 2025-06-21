// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../models/product_models.dart';
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
    // Modernized color palette with darker tones
    const primaryColor = Color(0xFF1E40AF); // Darker Blue
// Darker Green
    const surfaceColor = Color(0xFFF9FAFB); // Off-white
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 350;
        
        return GestureDetector(
          onTap: onTap ?? () => _showProductDetails(context),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Compact Header with Product Info
                Container(
                  padding: EdgeInsets.all(isCompact ? 8 : 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Product Image - smaller
                      Container(
                        width: isCompact ? 40 : 45,
                        height: isCompact ? 40 : 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
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
                      
                      const SizedBox(width: 8),
                      
                      // Product details - condensed
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Code and Status in one row
                            // Product Code
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                product.productCode,
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: isCompact ? 10 : 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 4),
                            
                            // Product Name - more compact
                            Text(
                              product.productName,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: isCompact ? 11 : 12,
                                height: 1.1,
                                color: Colors.grey.shade800,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            

                          ],
                        ),
                      ),
                      
                      const SizedBox(width: 8),
                      
                      // Price and Category on the right
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Price
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '₹${product.baseCostPerStrip.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontSize: isCompact ? 9 : 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 4),
                          
                          // Category
                          if (product.categoryName != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.purple.shade50,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                product.categoryName!,
                                style: TextStyle(
                                  color: Colors.purple.shade700,
                                  fontSize: isCompact ? 8 : 9,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Main Content - Stock Focused
                Padding(
                  padding: EdgeInsets.all(isCompact ? 8 : 10),
                  child: Column(
                    children: [
                      // Stock Section - Primary Focus
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



  Widget _buildStockSection(BuildContext context, bool isCompact) {
    // Calculate boxes and strips for godown stock display
    final boxes = product.closingStockGodown ~/ product.stripsPerBox;
    final remainingStrips = product.closingStockGodown % product.stripsPerBox;
    
    // Format for bold display (boxes + strips)
    String boldStockDisplay = '';
    if (boxes > 0 && remainingStrips > 0) {
      boldStockDisplay = '$boxes ${boxes == 1 ? 'box' : 'boxes'} + $remainingStrips strips';
    } else if (boxes > 0) {
      boldStockDisplay = '$boxes ${boxes == 1 ? 'box' : 'boxes'}';
    } else {
      boldStockDisplay = '$remainingStrips strips';
    }
    
    // Stock status color based on quantity
    Color stockColor;
    Color stockBgColor;
    if (product.closingStockGodown == 0) {
      stockColor = Colors.red.shade600;
      stockBgColor = Colors.red.shade50;
    } else if (product.closingStockGodown <= (product.minStockLevelGodown)) {
      stockColor = Colors.orange.shade600;
      stockBgColor = Colors.orange.shade50;
    } else {
      stockColor = Colors.green.shade600;
      stockBgColor = Colors.green.shade50;
    }
    
    return Container(
      padding: EdgeInsets.all(isCompact ? 8 : 10),
      decoration: BoxDecoration(
        color: stockBgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: stockColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Main Stock Display
          Row(
            children: [
              Icon(
                Icons.warehouse_rounded,
                size: isCompact ? 18 : 20,
                color: stockColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Godown Stock',
                      style: TextStyle(
                        fontSize: isCompact ? 10 : 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      boldStockDisplay,
                      style: TextStyle(
                        fontSize: isCompact ? 14 : 16,
                        fontWeight: FontWeight.w900,
                        color: stockColor,
                        height: 1.1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Stock quantity badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: stockColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${product.closingStockGodown}',
                  style: TextStyle(
                    fontSize: isCompact ? 12 : 14,
                    fontWeight: FontWeight.w800,
                    color: stockColor,
                  ),
                ),
              ),
            ],
          ),
          
          // Additional info for larger cards
          if (!isCompact && product.closingStockGodown > 0) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_rounded,
                  size: 10,
                  color: stockColor.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 4),
                Text(
                  'Available: ${product.closingStockGodown} ${product.unitOfMeasureSmallest.toLowerCase()}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: stockColor.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }


}