import '../config/env.dart';

/// API endpoints constants
class ApiEndpoints {
  static String get baseUrl => Env.baseUrl;
  
  // Product endpoints
  static const String products = '/api/v1/products';
  static String productById(int id) => '/api/v1/products/$id';
  static String productsByCategory(int categoryId) => '/api/v1/products/category/$categoryId';
  static const String productSearch = '/api/v1/products/search';
  static const String productFilter = '/api/v1/products/filter';

  // Category endpoints
  static const String categories = '/api/v1/categories';
  static String categoryById(int id) => '/api/v1/categories/$id';
  static String categoryBySlug(String slug) => '/api/v1/categories/slug/$slug';
  static String categoryChildren(int categoryId) => '/api/v1/categories/$categoryId/children';
}

