import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'config/supabase_config.dart';
import 'bloc/auth/auth_bloc.dart';
import 'repositories/auth_repository.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
        ],
        child: Builder(
          builder: (context) {
            final authBloc = context.read<AuthBloc>();
            final router = AppRouter.createRouter(authBloc);
            
            return BackButtonHandler(
              router: router,
              child: MaterialApp.router(
                title: 'StockMap Admin',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  useMaterial3: true,
                  appBarTheme: const AppBarTheme(
                    centerTitle: true,
                    elevation: 0,
                  ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  cardTheme: CardThemeData(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                routerConfig: router,
                debugShowCheckedModeBanner: false,
              ),
            );
          },
        ),
      ),
    );
  }
}

class BackButtonHandler extends StatefulWidget {
  final GoRouter router;
  final Widget child;

  const BackButtonHandler({
    super.key,
    required this.router,
    required this.child,
  });

  @override
  State<BackButtonHandler> createState() => _BackButtonHandlerState();
}

class _BackButtonHandlerState extends State<BackButtonHandler> {
  DateTime? _lastBackPressed;
  static const Duration _exitTimeLimit = Duration(seconds: 2);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        await _handleBackButton(context);
      },
      child: widget.child,
    );
  }

  Future<void> _handleBackButton(BuildContext context) async {
    final currentLocation = GoRouterState.of(context).matchedLocation;
    
    // If we're on dashboard, handle double-tap to exit
    if (currentLocation == '/dashboard') {
      final now = DateTime.now();
      
      if (_lastBackPressed == null || 
          now.difference(_lastBackPressed!) > _exitTimeLimit) {
        _lastBackPressed = now;
        
        // Show snackbar with exit message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit'),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }
      
      // Double tap detected, exit the app
      SystemNavigator.pop();
      return;
    }
    
    // For other pages, navigate back to dashboard
    if (context.mounted) {
      context.go('/dashboard');
    }
  }
}
