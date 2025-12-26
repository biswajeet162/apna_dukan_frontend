import 'package:flutter/material.dart';
import 'presentation/screens/product_list_screen.dart';
import 'presentation/screens/product_detail_screen.dart';

/// Product feature routes
class ProductRoutes {
  static const String productList = '/products';
  static const String productDetail = '/products/:id';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case productList:
        return MaterialPageRoute(
          builder: (_) => const ProductListScreen(),
        );
      case productDetail:
        final productId = settings.arguments as int? ?? 0;
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(productId: productId),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}

