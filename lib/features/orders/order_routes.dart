import 'package:flutter/material.dart';
import 'presentation/order_list_page.dart';

/// Order feature routes
class OrderRoutes {
  static const String orders = '/orders';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routeName = settings.name ?? '';
    
    if (routeName == orders) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const OrderListPage(),
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

