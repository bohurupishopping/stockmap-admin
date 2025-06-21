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
      route: '/dashboard/stock',
      color: Color(0xFF818cf8),
    ),
    NavItem(
      title: 'Reports',
      icon: Icons.analytics,
      route: '/dashboard/report',
      color: Color(0xFFfb923c),
    ),
    NavItem(
      title: 'Sale',
      icon: Icons.people,
      route: '/dashboard/sale',
      color: Color(0xFF34d399),
    ),
    NavItem(
      title: 'Purchase',
      icon: Icons.shopping_cart,
      route: '/dashboard/purchase',
      color: Color(0xFFf472b6),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFf1f5f9),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 12,
            bottom: 12,
            left: 8,
            right: 8,
          ),
          child: Row(
            children: navItems.map((item) => _buildNavItem(context, item)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, NavItem item) {
    final isActive = currentRoute == item.route;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (currentRoute != item.route) {
            context.go(item.route);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  // ignore: deprecated_member_use
                  color: isActive ? item.color.withOpacity(0.1) : Colors.white,
                  border: Border.all(
                    color: isActive
                        ? item.color
                        : const Color(0xFFf1f5f9),
                    width: 2,
                  ),
                ),
                child: Icon(
                  item.icon,
                  size: 24,
                  color: isActive
                      ? item.color
                      : const Color(0xFF94a3b8),
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 12,
                  color: isActive
                      ? item.color
                      : const Color(0xFF94a3b8),
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                  letterSpacing: 0.5,
                ),
                child: Text(item.title),
              ),
            ],
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
