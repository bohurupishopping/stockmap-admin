import 'package:flutter/material.dart';
import '../../models/product_models.dart';

class ProductDetailsDialog extends StatelessWidget {
  final Product product;

  const ProductDetailsDialog({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1E293B); // Slate 800
    const accentColor = Color(0xFF0EA5E9); // Sky 500
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 80 : 16,
        vertical: isTablet ? 40 : 24,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isTablet ? 600 : double.infinity,
          maxHeight: screenSize.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFE2E8F0), // Slate 200
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(context, theme, primaryColor, accentColor),
            
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductInfo(theme, primaryColor),
                    const SizedBox(height: 24),
                    _buildStockInfo(theme, primaryColor),
                  ],
                ),
              ),
            ),
            
            // Footer Actions
            _buildFooter(context, theme, primaryColor, accentColor),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, Color primaryColor, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC), // Slate 50
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: const Border(
          bottom: BorderSide(
            color: Color(0xFFE2E8F0), // Slate 200
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFE2E8F0), // Slate 200
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: product.imageUrl?.isNotEmpty == true
                  ? Image.network(
                      product.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderIcon();
                      },
                    )
                  : _buildPlaceholderIcon(),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Product Title Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Code Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFDF7), // Emerald 50
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF34D399), // Emerald 400
                      width: 1,
                    ),
                  ),
                  child: Text(
                    product.productCode,
                    style: const TextStyle(
                      color: Color(0xFF047857), // Emerald 700
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                
                const SizedBox(height: 10),
                
                // Product Name
                Text(
                  product.productName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 4),
                
                // Generic Name
                Text(
                  product.genericName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF64748B), // Slate 500
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: product.isActive
                  ? const Color(0xFFDCFDF7) // Emerald 50
                  : const Color(0xFFFEF2F2), // Red 50
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: product.isActive
                    ? const Color(0xFF34D399) // Emerald 400
                    : const Color(0xFFFCA5A5), // Red 300
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  product.isActive ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: product.isActive
                      ? const Color(0xFF047857) // Emerald 700
                      : const Color(0xFFDC2626), // Red 600
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  product.isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    color: product.isActive
                        ? const Color(0xFF047857) // Emerald 700
                        : const Color(0xFFDC2626), // Red 600
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          
        ],
      ),
    );
  }

  Widget _buildProductInfo(ThemeData theme, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoRow('Manufacturer', product.manufacturer, Icons.business_rounded, theme),
        _buildInfoRow('Category', product.categoryName ?? 'N/A', Icons.category_rounded, theme),
        _buildInfoRow('Sub Category', product.subCategoryName ?? 'N/A', Icons.subdirectory_arrow_right_rounded, theme),
        _buildInfoRow('Formulation', product.formulationName ?? 'N/A', Icons.medical_services_rounded, theme),
      ],
    );
  }


  Widget _buildStockInfo(ThemeData theme, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Stock Levels',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStockCard(
                'Godown Stock',
                product.formattedGodownStock,
                Icons.warehouse_rounded,
                theme,
                isStock: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStockCard(
                'MR Stock',
                product.formattedMrStock,
                Icons.person_rounded,
                theme,
                isStock: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F9FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFBAE6FD),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.inventory_2_rounded,
                color: const Color(0xFF0EA5E9),
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                'Total Stock: ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
              Text(
                product.formattedTotalStock,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0EA5E9),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }



  Widget _buildFooter(BuildContext context, ThemeData theme, Color primaryColor, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC), // Slate 50
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(
            color: Color(0xFFE2E8F0), // Slate 200
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE2E8F0), // Slate 200
                  width: 1,
                ),
              ),
              child: TextButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close_rounded,
                  size: 18,
                ),
                label: const Text('Close'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF64748B), // Slate 500
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          
        ],
      ),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9), // Slate 100
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Icon(
        Icons.medical_services_rounded,
        color: Color(0xFF94A3B8), // Slate 400
        size: 32,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9), // Slate 100
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 16,
              color: const Color(0xFF0EA5E9), // Sky 500
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B), // Slate 500
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B), // Slate 800
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildStockCard(String label, dynamic value, IconData icon, ThemeData theme, {bool isStock = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0), // Slate 200
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9), // Slate 100
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: const Color(0xFF0EA5E9), // Sky 500
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B), // Slate 500
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            isStock ? value.toString() : value.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B), // Slate 800
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}