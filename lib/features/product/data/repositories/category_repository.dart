import '../sources/category_remote_source.dart';
import '../models/category_model.dart';

/// Repository for category operations
class CategoryRepository {
  final CategoryRemoteSource _remoteSource;

  CategoryRepository(this._remoteSource);

  /// Get all categories
  Future<List<CategoryModel>> getAllCategories() async {
    return await _remoteSource.getAllCategories();
  }

  /// Get category by ID
  Future<CategoryModel> getCategoryById(int categoryId) async {
    return await _remoteSource.getCategoryById(categoryId);
  }

  /// Get category by slug
  Future<CategoryModel> getCategoryBySlug(String slug) async {
    return await _remoteSource.getCategoryBySlug(slug);
  }

  /// Get child categories
  Future<List<CategoryModel>> getCategoryChildren(int categoryId) async {
    return await _remoteSource.getCategoryChildren(categoryId);
  }
}

