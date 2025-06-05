import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FooterNavBar extends StatelessWidget {
  final String currentRoute;

  const FooterNavBar({super.key, required this.currentRoute});

  static const List<NavItem> navItems = [
    NavItem(
      title: 'Dashboard',
      icon: Icons.dashboard,
      route: '/dashboard',
      color: Color(0xFF667eea),
    ),
    NavItem(
      title: 'Stock',
      icon: Icons.inventory_2,
      route: '/stock',
      color: Color(0xFF818cf8),
    ),
    NavItem(
      title: 'Reports',
      icon: Icons.analytics,
      route: '/report',
      color: Color(0xFFfb923c),
    ),
    NavItem(
      title: 'Sale',
      icon: Icons.people,
      route: '/sale',
      color: Color(0xFF34d399),
    ),
    NavItem(
      title: 'Purchase',
      icon: Icons.shopping_cart,
      route: '/purchase',
      color: Color(0xFFf472b6),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: navItems.map((item) => _buildNavItem(context, item)).toList(),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, NavItem item) {
    final isActive = currentRoute == item.route;
    
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (currentRoute != item.route) {
              context.go(item.route);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isActive 
                        ? item.color.withValues(alpha: 0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    item.icon,
                    size: 24,
                    color: isActive 
                        ? item.color 
                        : const Color(0xFF64748b),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive 
                        ? item.color 
                        : const Color(0xFF64748b),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NavItem {
  final String title;
  final IconData icon;
  final String route;
  final Color color;

  const NavItem({
    required this.title,
    required this.icon,
    required this.route,
    required this.color,
  });
}