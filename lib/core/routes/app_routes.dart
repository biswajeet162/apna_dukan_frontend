import 'package:flutter/material.dart';
import '../../features/auth/auth_routes.dart';
import '../../features/product/product_routes.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/category/presentation/category_page.dart';
import '../../features/orders/order_routes.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../features/splash/presentation/splash_page.dart';

/// Centralized app routing configuration
class AppRoutes {
  // Base routes
  static const String dashboard = '/dashboard';
  static const String home = '/';
  static const String products = '/products';
  static const String productDetail = '/products/:id';
  static const String splash = '/splash';
  
  // Auth routes
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  
  // Other routes
  static const String categories = '/categories';
  static const String orders = '/orders';
  static const String account = '/account';

  /// Generate route from settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routeName = settings.name ?? '/';
    // Handle hash-based routing (Flutter web default)
    // URL like /#/products/123 will have routeName as /products/123
    final path = routeName.startsWith('/') ? routeName : '/$routeName';

    // Handle dashboard route (default route)
    if (path == dashboard || path == home) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const DashboardPage(),
      );
    }
    
    // Handle products route
    if (path == products) {
      return ProductRoutes.generateRoute(
        RouteSettings(name: ProductRoutes.productList),
      );
    }

    // Handle product detail with path parameter
    if (path.startsWith('/products/')) {
      final segments = path.split('/');
      if (segments.length >= 3) {
        final productId = int.tryParse(segments[2]);
        if (productId != null) {
          // Pass the actual path as route name
          return ProductRoutes.generateRoute(
            RouteSettings(
              name: path, // Use actual path like '/products/123'
              arguments: productId,
            ),
          );
        }
      }
      // Invalid product ID, return 404
      return _buildNotFoundRoute(settings);
    }

    // Handle splash route
    if (path == splash) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const SplashPage(),
      );
    }

    // Handle auth routes
    switch (path) {
      case login:
        return AuthRoutes.generateRoute(
          RouteSettings(name: AuthRoutes.login),
        );
      case register:
        return AuthRoutes.generateRoute(
          RouteSettings(name: AuthRoutes.register),
        );
      case forgotPassword:
        return AuthRoutes.generateRoute(
          RouteSettings(name: AuthRoutes.forgotPassword),
        );
      case categories:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const CategoryPage(),
        );
      case orders:
        return OrderRoutes.generateRoute(
          RouteSettings(name: OrderRoutes.orders),
        );
      case account:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ProfilePage(),
        );
      default:
        return _buildNotFoundRoute(settings);
    }
  }

  /// Build route path with parameters
  static String buildPath(String basePath, {Map<String, dynamic>? pathParams, Map<String, String>? queryParams}) {
    String path = basePath;
    
    // Replace path parameters
    if (pathParams != null) {
      pathParams.forEach((key, value) {
        path = path.replaceAll(':$key', value.toString());
      });
    }
    
    // Add query parameters
    if (queryParams != null && queryParams.isNotEmpty) {
      final uri = Uri(path: path, queryParameters: queryParams);
      return uri.toString();
    }
    
    return path;
  }

  /// Build 404 route
  static Route<dynamic> _buildNotFoundRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Page Not Found'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                'Page not found',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                'The requested route "${settings.name}" does not exist',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
