import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/product_list_model.dart';
import '../models/product_detail_model.dart';
import '../models/product_create_request.dart';
import '../models/product_update_request.dart';
import '../models/paginated_response.dart';

/// Remote data source for product operations
class ProductRemoteSource {
  final ApiClient _apiClient;

  ProductRemoteSource(this._apiClient);

  /// Fetch all products with pagination
  Future<PaginatedResponse<ProductListModel>> getProducts({
    int page = 0,
    int size = 20,
    String sort = 'createdAt,desc',
  }) async {
    try {
      // The mock JSON web server returns:
      // {
      //   "success": true,
      //   "message": "...",
      //   "data": [ { product }, {...} ]
      // }
      // i.e. `data` is a plain list, not a paginated map. We adapt that
      // into our `PaginatedResponse` model here.
      final response = await _apiClient.get<List<dynamic>>(
        ApiEndpoints.products,
        queryParameters: {
          'page': page,
          'size': size,
          'sort': sort,
        },
        fromJson: (data) => data as List<dynamic>,
      );

      if (!response.success || response.data == null) {
        throw NetworkException(response.message);
      }

      final products = response.data!
          .map((json) => ProductListModel.fromJson(json as Map<String, dynamic>))
          .toList();

      // Since the mock API does not provide real pagination metadata,
      // we synthesize a single-page `PaginatedResponse`.
      return PaginatedResponse<ProductListModel>(
        content: products,
        totalElements: products.length,
        totalPages: 1,
        currentPage: page,
        size: size,
        hasNext: false,
        hasPrevious: false,
      );
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Failed to fetch products: ${e.toString()}');
    }
  }

  /// Fetch product details by ID
  Future<ProductDetailModel> getProductById(int productId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiEndpoints.productById(productId),
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (!response.success || response.data == null) {
        throw NetworkException(response.message);
      }

      return ProductDetailModel.fromJson(response.data!);
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Failed to fetch product: ${e.toString()}');
    }
  }

  /// Fetch products by category
  Future<List<ProductListModel>> getProductsByCategory(
    int categoryId, {
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _apiClient.get<List<dynamic>>(
        ApiEndpoints.productsByCategory(categoryId),
        queryParameters: {
          'page': page,
          'size': size,
        },
        fromJson: (data) => data as List<dynamic>,
      );

      if (!response.success || response.data == null) {
        throw NetworkException(response.message);
      }

      return response.data!
          .map((json) => ProductListModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Failed to fetch products by category: ${e.toString()}');
    }
  }

  /// Search products by keyword
  Future<List<ProductListModel>> searchProducts(String keyword) async {
    try {
      final response = await _apiClient.get<List<dynamic>>(
        ApiEndpoints.productSearch,
        queryParameters: {'keyword': keyword},
        fromJson: (data) => data as List<dynamic>,
      );

      if (!response.success || response.data == null) {
        throw NetworkException(response.message);
      }

      return response.data!
          .map((json) => ProductListModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Failed to search products: ${e.toString()}');
    }
  }

  /// Filter products by price and rating
  Future<List<ProductListModel>> filterProducts({
    double? minPrice,
    double? maxPrice,
    double? minRating,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (minPrice != null) queryParams['minPrice'] = minPrice;
      if (maxPrice != null) queryParams['maxPrice'] = maxPrice;
      if (minRating != null) queryParams['minRating'] = minRating;

      final response = await _apiClient.get<List<dynamic>>(
        ApiEndpoints.productFilter,
        queryParameters: queryParams,
        fromJson: (data) => data as List<dynamic>,
      );

      if (!response.success || response.data == null) {
        throw NetworkException(response.message);
      }

      return response.data!
          .map((json) => ProductListModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Failed to filter products: ${e.toString()}');
    }
  }

  /// Create a new product (Admin only)
  Future<Map<String, dynamic>> createProduct(ProductCreateRequest request) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiEndpoints.products,
        data: request.toJson(),
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (!response.success || response.data == null) {
        throw NetworkException(response.message);
      }

      return response.data!;
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Failed to create product: ${e.toString()}');
    }
  }

  /// Update product (Admin only)
  Future<void> updateProduct(int productId, ProductUpdateRequest request) async {
    try {
      final response = await _apiClient.put<dynamic>(
        ApiEndpoints.productById(productId),
        data: request.toJson(),
        fromJson: (data) => data,
      );

      if (!response.success) {
        throw NetworkException(response.message);
      }
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Failed to update product: ${e.toString()}');
    }
  }

  /// Delete product (Admin only)
  Future<void> deleteProduct(int productId) async {
    try {
      final response = await _apiClient.delete<dynamic>(
        ApiEndpoints.productById(productId),
        fromJson: (data) => data,
      );

      if (!response.success) {
        throw NetworkException(response.message);
      }
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Failed to delete product: ${e.toString()}');
    }
  }
}

