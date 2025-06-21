import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';
import '../pages/splash_page.dart';
import '../pages/login_page.dart';
import '../pages/dashboard_page.dart';
import '../pages/stock_page.dart';
import '../pages/report_page.dart';
import '../pages/purchase_page.dart';
import '../pages/sale_page.dart';
import '../pages/ai_page.dart';
import '../pages/mr_sales_report_page.dart';
import '../pages/doctors_page.dart';
import '../pages/mr_activity_page.dart';

class AppRouter {
  static GoRouter createRouter(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: '/splash',
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        final authState = authBloc.state;
        final currentLocation = state.matchedLocation;
        
        // Allow splash screen to handle initial auth check
        if (currentLocation == '/splash') {
          return null;
        }
        
        // Redirect logic for other routes
        if (authState is AuthInitial || authState is AuthLoading) {
          return '/splash';
        } else if (authState is AuthAuthenticated) {
          if (currentLocation == '/login') {
            return '/dashboard';
          }
          return null; // Allow access to authenticated routes
        } else if (authState is AuthUnauthenticated || 
                   authState is AuthError || 
                   authState is AuthAccessDenied) {
          if (currentLocation != '/login') {
            return '/login';
          }
          return null;
        }
        
        return '/splash';
      },
      routes: [
        GoRoute(
          path: '/splash',
          name: 'splash',
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          builder: (context, state) => const DashboardPage(),
          routes: [
            GoRoute(
              path: 'stock',
              name: 'stock',
              builder: (context, state) => const StockPage(),
            ),
            GoRoute(
              path: 'report',
              name: 'report',
              builder: (context, state) => const ReportPage(),
            ),
            GoRoute(
              path: 'purchase',
              name: 'purchase',
              builder: (context, state) => const PurchasePage(),
            ),
            GoRoute(
              path: 'sale',
              name: 'sale',
              builder: (context, state) => const SalePage(),
            ),
            GoRoute(
              path: 'ai',
              name: 'ai',
              builder: (context, state) => const AiPage(),
            ),
            GoRoute(
              path: 'mr-sales',
              name: 'mr-sales',
              builder: (context, state) => const MRSalesReportPage(),
            ),
            GoRoute(
              path: 'doctors',
              name: 'doctors',
              builder: (context, state) => const DoctorsPage(),
            ),
            GoRoute(
              path: 'mr-activity',
              name: 'mr-activity',
              builder: (context, state) => const MRActivityPage(),
            ),
          ],
        ),
      ],
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<AuthState> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (AuthState state) {
        notifyListeners();
      },
    );
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}