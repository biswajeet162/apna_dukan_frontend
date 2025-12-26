import '../models/product_list_model.dart';
import '../models/product_detail_model.dart';
import '../models/product_create_request.dart';
import '../models/product_update_request.dart';
import '../models/paginated_response.dart';
import '../sources/product_remote_source.dart';
import '../../../../core/network/network_exceptions.dart';

/// Repository for product data operations
class ProductRepository {
  final ProductRemoteSource _remoteSource;

  ProductRepository(this._remoteSource);

  /// Get all products with pagination
  Future<PaginatedResponse<ProductListModel>> getProducts({
    int page = 0,
    int size = 20,
    String sort = 'createdAt,desc',
  }) async {
    try {
      return await _remoteSource.getProducts(
        page: page,
        size: size,
        sort: sort,
      );
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error: ${e.toString()}');
    }
  }

  /// Get product by ID
  Future<ProductDetailModel> getProductById(int productId) async {
    try {
      return await _remoteSource.getProductById(productId);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error: ${e.toString()}');
    }
  }

  /// Get products by category
  Future<List<ProductListModel>> getProductsByCategory(
    int categoryId, {
    int page = 0,
    int size = 20,
  }) async {
    try {
      return await _remoteSource.getProductsByCategory(
        categoryId,
        page: page,
        size: size,
      );
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error: ${e.toString()}');
    }
  }

  /// Search products
  Future<List<ProductListModel>> searchProducts(String keyword) async {
    try {
      return await _remoteSource.searchProducts(keyword);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error: ${e.toString()}');
    }
  }

  /// Filter products
  Future<List<ProductListModel>> filterProducts({
    double? minPrice,
    double? maxPrice,
    double? minRating,
  }) async {
    try {
      return await _remoteSource.filterProducts(
        minPrice: minPrice,
        maxPrice: maxPrice,
        minRating: minRating,
      );
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error: ${e.toString()}');
    }
  }

  /// Create product (Admin)
  Future<Map<String, dynamic>> createProduct(ProductCreateRequest request) async {
    try {
      return await _remoteSource.createProduct(request);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error: ${e.toString()}');
    }
  }

  /// Update product (Admin)
  Future<void> updateProduct(int productId, ProductUpdateRequest request) async {
    try {
      return await _remoteSource.updateProduct(productId, request);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error: ${e.toString()}');
    }
  }

  /// Delete product (Admin)
  Future<void> deleteProduct(int productId) async {
    try {
      return await _remoteSource.deleteProduct(productId);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error: ${e.toString()}');
    }
  }
}

