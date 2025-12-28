import 'package:flutter/material.dart';
import 'presentation/screens/product_list_screen.dart';
import 'presentation/screens/product_detail_screen.dart';

/// Product feature routes
class ProductRoutes {
  static const String productList = '/products';
  static const String productDetail = '/products/:id';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routeName = settings.name ?? '';
    
    // Handle product list
    if (routeName == productList || routeName == '/' || routeName.isEmpty) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const ProductListScreen(),
      );
    }
    
    // Handle product detail - could be template or actual path
    if (routeName == productDetail || routeName.startsWith('/products/')) {
      // Extract product ID from arguments or from path
      int productId = 0;
      if (settings.arguments is int) {
        productId = settings.arguments as int;
      } else if (routeName.startsWith('/products/')) {
        final segments = routeName.split('/');
        if (segments.length >= 3) {
          productId = int.tryParse(segments[2]) ?? 0;
        }
      }
      
      // Use the actual path for route settings
      final actualPath = '/products/$productId';
      return MaterialPageRoute(
        settings: RouteSettings(name: actualPath, arguments: productId),
        builder: (_) => ProductDetailScreen(productId: productId),
      );
    }
    
    // Default 404
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => const Scaffold(
        body: Center(child: Text('Route not found')),
      ),
    );
  }
}

