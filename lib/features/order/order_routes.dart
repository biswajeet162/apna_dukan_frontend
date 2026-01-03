import 'package:flutter/material.dart';
import 'presentation/screens/order_screen.dart';

/// Order feature routes
class OrderRoutes {
  static const String orders = '/orders';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case orders:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const OrderScreen(),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}

