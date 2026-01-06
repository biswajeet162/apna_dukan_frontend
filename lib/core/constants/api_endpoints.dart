import '../config/env.dart';

/// API endpoints constants
class ApiEndpoints {
  static String get baseUrl => Env.baseUrl;
  
  // Product endpoints
  static const String products = '/api/v1/products';
  static String productById(int id) => '/api/v1/products/$id';
  static String productRelated(int id) => '/api/v1/products/$id/related';
  static String productsByCategory(int categoryId) => '/api/v1/products/category/$categoryId';
  static const String productSearch = '/api/v1/products/search';
  static const String productFilter = '/api/v1/products/filter';

  // Category endpoints
  static const String categories = '/api/v1/categories';
  static String categoryById(int id) => '/api/v1/categories/$id';
  static String categoryBySlug(String slug) => '/api/v1/categories/slug/$slug';
  static String categoryChildren(int categoryId) => '/api/v1/categories/$categoryId/children';

  // Auth endpoints
  static const String auth = '/api/v1/auth';
  static const String login = '/api/v1/auth/login';
  static const String signup = '/api/v1/auth/signup';
  static const String verifyOtp = '/api/v1/auth/verify-otp';
  static const String refreshToken = '/api/v1/auth/refresh-token';
  static const String logout = '/api/v1/auth/logout';
  static const String me = '/api/v1/auth/me';
  static const String updateProfile = '/api/v1/auth/profile';

  // Order endpoints
  static const String orders = '/api/v1/orders';
  static String orderById(int orderId) => '/api/v1/orders/$orderId';
  static String orderStatus(int orderId) => '/api/v1/orders/$orderId/status';
  static String orderInvoice(int orderId) => '/api/v1/orders/$orderId/invoice';
  static String cancelOrder(int orderId) => '/api/v1/orders/$orderId/cancel';
  static String returnOrder(int orderId) => '/api/v1/orders/$orderId/return';
}

