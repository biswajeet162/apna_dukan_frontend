import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/category_model.dart';

/// Remote data source for categories
class CategoryRemoteSource {
  final ApiClient _apiClient;

  CategoryRemoteSource(this._apiClient);

  /// Fetch all categories in a tree structure
  Future<List<CategoryModel>> getAllCategories() async {
    final response = await _apiClient.get<List<CategoryModel>>(
      ApiEndpoints.categories,
      fromJson: (data) {
        if (data is List) {
          return data
              .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return [];
      },
    );
    // The API returns data in response.data, which is already a List<CategoryModel>
    if (response.data != null) {
      return response.data!;
    }
    return [];
  }

  /// Fetch category by ID
  Future<CategoryModel> getCategoryById(int categoryId) async {
    final response = await _apiClient.get<CategoryModel>(
      ApiEndpoints.categoryById(categoryId),
      fromJson: (data) => CategoryModel.fromJson(data as Map<String, dynamic>),
    );
    if (response.data == null) {
      throw Exception('Category not found');
    }
    return response.data!;
  }

  /// Fetch category by slug
  Future<CategoryModel> getCategoryBySlug(String slug) async {
    final response = await _apiClient.get<CategoryModel>(
      ApiEndpoints.categoryBySlug(slug),
      fromJson: (data) => CategoryModel.fromJson(data as Map<String, dynamic>),
    );
    if (response.data == null) {
      throw Exception('Category not found');
    }
    return response.data!;
  }

  /// Fetch child categories of a parent category
  Future<List<CategoryModel>> getCategoryChildren(int categoryId) async {
    final response = await _apiClient.get<List<CategoryModel>>(
      ApiEndpoints.categoryChildren(categoryId),
      fromJson: (data) {
        if (data is List) {
          return data
              .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return [];
      },
    );
    return response.data ?? [];
  }
}

