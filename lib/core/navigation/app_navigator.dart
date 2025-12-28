import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

/// Helper class for app navigation with named routes
class AppNavigator {
  /// Navigate to a route
  static Future<T?> pushNamed<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed<T>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate to a route and remove all previous routes
  static Future<T?> pushNamedAndRemoveUntil<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    bool Function(Route<dynamic>)? predicate,
  }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
      predicate ?? (route) => false,
      arguments: arguments,
    );
  }

  /// Navigate to a route and remove current route
  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return Navigator.pushReplacementNamed<T, TO>(
      context,
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  /// Pop current route
  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.pop<T>(context, result);
  }

  /// Pop until predicate
  static void popUntil(BuildContext context, bool Function(Route<dynamic>) predicate) {
    Navigator.popUntil(context, predicate);
  }

  /// Build route path with parameters
  static String buildProductDetailPath(int productId) {
    // Replace :id with actual productId in the path
    return '/products/$productId';
  }

  /// Navigate to product detail
  static Future<void> toProductDetail(BuildContext context, int productId) {
    return pushNamed(context, buildProductDetailPath(productId));
  }

  /// Navigate to login
  static Future<void> toLogin(BuildContext context) {
    return pushNamed(context, AppRoutes.login);
  }

  /// Navigate to register
  static Future<void> toRegister(BuildContext context) {
    return pushNamed(context, AppRoutes.register);
  }

  /// Navigate to forgot password
  static Future<void> toForgotPassword(BuildContext context) {
    return pushNamed(context, AppRoutes.forgotPassword);
  }

  /// Navigate to account
  static Future<void> toAccount(BuildContext context) {
    return pushNamed(context, AppRoutes.account);
  }

  /// Navigate to categories
  static Future<void> toCategories(BuildContext context) {
    return pushNamed(context, AppRoutes.categories);
  }

  /// Navigate to orders
  static Future<void> toOrders(BuildContext context) {
    return pushNamed(context, AppRoutes.orders);
  }

  /// Navigate to home
  static Future<void> toHome(BuildContext context) {
    return pushNamedAndRemoveUntil(context, AppRoutes.home);
  }

  /// Navigate to home and clear stack
  static Future<void> toHomeClearStack(BuildContext context) {
    return pushNamedAndRemoveUntil(context, AppRoutes.home, predicate: (route) => false);
  }
}

