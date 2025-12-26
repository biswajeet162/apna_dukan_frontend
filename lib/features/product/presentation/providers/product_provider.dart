import 'package:flutter/foundation.dart';
import '../../data/models/product_list_model.dart';
import '../../data/models/product_detail_model.dart';
import '../../data/models/product_create_request.dart';
import '../../data/models/product_update_request.dart';
import '../../data/models/paginated_response.dart';
import '../../data/repositories/product_repository.dart';
import '../../../../core/network/network_exceptions.dart';

/// Provider for managing product state
class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository;

  ProductProvider(this._repository);

  // State variables
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  List<ProductListModel> _products = [];
  ProductDetailModel? _productDetail;
  PaginatedResponse<ProductListModel>? _paginatedResponse;
  int _currentPage = 0;
  final int _pageSize = 20;

  // Getters
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  List<ProductListModel> get products => _products;
  ProductDetailModel? get productDetail => _productDetail;
  bool get hasMore => _paginatedResponse?.hasNext ?? false;

  /// Load products with pagination
  Future<void> loadProducts({bool refresh = false}) async {
    try {
      print('📦 ProductProvider: Loading products (refresh: $refresh, page: $_currentPage)');
      if (refresh) {
        _currentPage = 0;
        _products.clear();
        _isLoading = true;
      } else {
        _isLoadingMore = true;
      }
      _error = null;
      notifyListeners();

      final response = await _repository.getProducts(
        page: _currentPage,
        size: _pageSize,
      );
      
      print('✅ ProductProvider: Received ${response.content.length} products');

      if (refresh) {
        _products = response.content;
      } else {
        _products.addAll(response.content);
      }

      _paginatedResponse = response;
      _currentPage++;
      _error = null;
    } on NetworkException catch (e) {
      print('❌ ProductProvider: Network error - ${e.message}');
      _error = e.message;
    } catch (e, stackTrace) {
      print('❌ ProductProvider: Unexpected error - ${e.toString()}');
      print('Stack trace: $stackTrace');
      _error = 'An unexpected error occurred: ${e.toString()}';
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Load more products (pagination)
  Future<void> loadMoreProducts() async {
    if (_isLoadingMore || !hasMore) return;
    await loadProducts();
  }

  /// Get product by ID
  Future<void> getProductById(int productId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _productDetail = await _repository.getProductById(productId);
      _error = null;
    } on NetworkException catch (e) {
      _error = e.message;
      _productDetail = null;
    } catch (e) {
      _error = 'An unexpected error occurred: ${e.toString()}';
      _productDetail = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get products by category
  Future<void> getProductsByCategory(int categoryId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _products = await _repository.getProductsByCategory(categoryId);
      _error = null;
    } on NetworkException catch (e) {
      _error = e.message;
      _products = [];
    } catch (e) {
      _error = 'An unexpected error occurred: ${e.toString()}';
      _products = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Search products
  Future<void> searchProducts(String keyword) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _products = await _repository.searchProducts(keyword);
      _error = null;
    } on NetworkException catch (e) {
      _error = e.message;
      _products = [];
    } catch (e) {
      _error = 'An unexpected error occurred: ${e.toString()}';
      _products = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Filter products
  Future<void> filterProducts({
    double? minPrice,
    double? maxPrice,
    double? minRating,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _products = await _repository.filterProducts(
        minPrice: minPrice,
        maxPrice: maxPrice,
        minRating: minRating,
      );
      _error = null;
    } on NetworkException catch (e) {
      _error = e.message;
      _products = [];
    } catch (e) {
      _error = 'An unexpected error occurred: ${e.toString()}';
      _products = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create product (Admin)
  Future<bool> createProduct(ProductCreateRequest request) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _repository.createProduct(request);
      _error = null;
      return true;
    } on NetworkException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update product (Admin)
  Future<bool> updateProduct(int productId, ProductUpdateRequest request) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _repository.updateProduct(productId, request);
      _error = null;
      return true;
    } on NetworkException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete product (Admin)
  Future<bool> deleteProduct(int productId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _repository.deleteProduct(productId);
      _products.removeWhere((p) => p.id == productId);
      _error = null;
      return true;
    } on NetworkException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Reset state
  void reset() {
    _products.clear();
    _productDetail = null;
    _paginatedResponse = null;
    _currentPage = 0;
    _error = null;
    notifyListeners();
  }
}

