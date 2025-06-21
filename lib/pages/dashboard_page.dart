import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';
import '../models/user_profile.dart';
import '../widgets/footer_nav_bar.dart'; // Using your original footer nav bar

// ignore_for_file: deprecated_member_use

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  // Using your original navigation items, but with updated outlined icons for a modern look.
  final List<NavItem> navItems = const [
    NavItem(
      title: 'Stock',
      description: 'View stocks',
      icon: Icons.inventory_2_outlined, // Updated icon
      route: '/dashboard/stock',
      color: Color(0xFF818cf8),
      gradientColors: [Color(0xFF818cf8), Color(0xFF6366f1)],
    ),
    NavItem(
      title: 'Reports',
      description: 'View analytics',
      icon: Icons.bar_chart_outlined, // Updated icon
      route: '/dashboard/report',
      color: Color(0xFFfb923c),
      gradientColors: [Color(0xFFfb923c), Color(0xFFf97316)],
    ),
    NavItem(
      title: 'Sale',
      description: 'View sales',
      icon: Icons.people_alt_outlined, // Updated icon
      route: '/dashboard/sale',
      color: Color(0xFF34d399),
      gradientColors: [Color(0xFF34d399), Color(0xFF10b981)],
    ),
    NavItem(
      title: 'Purchase',
      description: 'View purchases',
      icon: Icons.shopping_cart_outlined, // Updated icon
      route: '/dashboard/purchase',
      color: Color(0xFFf472b6),
      gradientColors: [Color(0xFFf472b6), Color(0xFFec4899)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // The BLoC builder logic remains unchanged, correctly handling different auth states.
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial || state is AuthLoading) {
          return const _LoadingWidget();
        } else if (state is AuthAuthenticated) {
          // The main content is now wrapped in a Scaffold to use your FooterNavBar
          return Scaffold(
            backgroundColor: const Color(0xFFF8F9FA),
            body: _DashboardContent(user: state.user, navItems: navItems),
            bottomNavigationBar: const FooterNavBar(currentRoute: '/dashboard'),
          );
        } else if (state is AuthUnauthenticated) {
          return const SizedBox.shrink();
        } else if (state is AuthError) {
          return _ErrorWidget(message: state.message);
        } else if (state is AuthAccessDenied) {
          return _ErrorWidget(message: state.message);
        }
        return const _LoadingWidget();
      },
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final UserProfile user;
  final List<NavItem> navItems;

  const _DashboardContent({required this.user, required this.navItems});

  @override
  Widget build(BuildContext context) {
    // The content is scrollable and sits within the safe area.
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, user.name),
            const SizedBox(height: 24),
            _buildContent(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// Builds the top header section with a new gradient and welcome message.
  Widget _buildHeader(BuildContext context, String userName) {
    return Container(
      padding: const EdgeInsets.only(top: 24, bottom: 32),
      decoration: const BoxDecoration(
        // NEW: A fresh, professional gradient.
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D9488), Color(0xFF1D4ED8)], // Teal to deep blue
        ),
        // This creates the nice curved bottom edge.
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        children: [
          // Top bar with a modern, circular logout button.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Material(
                  color: Colors.white.withOpacity(0.15),
                  shape: const CircleBorder(),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () => context
                        .read<AuthBloc>()
                        .add(const AuthEvent.logoutRequested()),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.power_settings_new_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Centered welcome text content.
          Text(
            'Welcome back,',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white.withOpacity(0.85),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userName,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the main content area containing the navigation grid.
  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 20),
          _buildNavGrid(context),
        ],
      ),
    );
  }

  /// Builds the responsive grid of navigation items.
  Widget _buildNavGrid(BuildContext context) {
    return Wrap(
      spacing: 16, // Horizontal space between cards
      runSpacing: 16, // Vertical space between cards
      children: navItems.map((item) => _buildNavItem(context, item)).toList(),
    );
  }

  /// Builds a single, tappable navigation item card, styled like the sample.
  Widget _buildNavItem(BuildContext context, NavItem item) {
    // Calculate width for two items per row with padding and spacing.
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 40 - 16) / 2;

    return SizedBox(
      width: itemWidth,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            // Updated navigation logic for your specific routes.
            if (['/dashboard/stock', '/dashboard/report', '/dashboard/sale', '/dashboard/purchase', '/dashboard/ai']
                .contains(item.route)) {
              context.go(item.route);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item.title} feature coming soon!'),
                  backgroundColor: item.color,
                ),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade200, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // The icon container with a soft background color.
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(item.icon, size: 28, color: item.color),
                ),
                const SizedBox(height: 16),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    // Uses the darker color from your gradient for a nice effect.
                    color: item.gradientColors[1],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748b),
                    height: 1.3,
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

// Data model for a navigation item.
class NavItem {
  final String title;
  final String description;
  final IconData icon;
  final String route;
  final Color color;
  final List<Color> gradientColors;

  const NavItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
    required this.color,
    required this.gradientColors,
  });
}

// A simple loading widget.
class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

// A reusable error display widget.
class _ErrorWidget extends StatelessWidget {
  final String message;

  const _ErrorWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'An Error Occurred',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              SelectableText(
                message,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<AuthBloc>()
                      .add(const AuthEvent.checkAuthStatus());
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}