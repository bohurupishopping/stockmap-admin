import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';
import '../models/user_profile.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  final List<NavItem> navItems = const [
    NavItem(
      title: 'Stock',
      description: 'Manage inventory',
      icon: Icons.inventory_2,
      route: '/stock',
      color: Color(0xFF818cf8),
      gradientColors: [Color(0xFF818cf8), Color(0xFF6366f1)],
    ),
    NavItem(
      title: 'Reports',
      description: 'View analytics',
      icon: Icons.analytics,
      route: '/report',
      color: Color(0xFFfb923c),
      gradientColors: [Color(0xFFfb923c), Color(0xFFf97316)],
    ),
    NavItem(
      title: 'Customers',
      description: 'Manage customers',
      icon: Icons.people,
      route: '/customers',
      color: Color(0xFF34d399),
      gradientColors: [Color(0xFF34d399), Color(0xFF10b981)],
    ),
    NavItem(
      title: 'Settings',
      description: 'App settings',
      icon: Icons.settings,
      route: '/settings',
      color: Color(0xFFf472b6),
      gradientColors: [Color(0xFFf472b6), Color(0xFFec4899)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial || state is AuthLoading) {
          return const _LoadingWidget();
        } else if (state is AuthAuthenticated) {
          return _DashboardContent(user: state.user, navItems: navItems);
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context, user.name),
              _buildContent(context),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String userName) {
    return Container(
      height: 240,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6366f1), Color(0xFF4f46e5)],
        ),
      ),
      child: Stack(
        children: [
          // Background image with blur effect
          Positioned.fill(
            child: Image.asset(
              'images/bg.avif',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF6366f1), Color(0xFF4f46e5)],
                    ),
                  ),
                );
              },
            ),
          ),
          // Overlay gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF6366f1).withValues(alpha: 0.8),
                    const Color(0xFF4f46e5).withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),
          // Logout button
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                context.read<AuthBloc>().add(
                  const AuthEvent.logoutRequested(),
                );
              },
            ),
          ),
          // Welcome content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                const Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFe0e7ff),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Admin Dashboard',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 16),
          _buildNavGrid(context),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildNavGrid(BuildContext context) {
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: navItems.map((item) => _buildNavItem(context, item)).toList(),
    );
  }

  Widget _buildNavItem(BuildContext context, NavItem item) {
    return Container(
      width: (MediaQuery.of(context).size.width - 64) / 2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: item.color.withValues(alpha: 0.2),
          width: 2,
          style: BorderStyle.solid,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            if (item.route == '/stock' || item.route == '/report') {
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
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    item.icon,
                    size: 26,
                    color: item.color,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: item.gradientColors[1],
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748b),
                    height: 1.4,
                    letterSpacing: 0.3,
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
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Error',
                style: Theme.of(context).textTheme.headlineSmall,
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
                  context.read<AuthBloc>().add(const AuthEvent.checkAuthStatus());
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