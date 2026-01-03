import 'package:flutter/foundation.dart';
import '../../data/models/order_model.dart';
import '../../data/models/paginated_response.dart';
import '../../data/repositories/order_repository.dart';
import '../../../../core/network/network_exceptions.dart';

/// Provider for managing order state
class OrderProvider extends ChangeNotifier {
  final OrderRepository _repository;

  OrderProvider(this._repository);

  // State variables
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  List<OrderListModel> _orders = [];
  OrderDetailModel? _orderDetail;
  PaginatedResponse<OrderListModel>? _paginatedResponse;
  int _currentPage = 0;
  final int _pageSize = 10;

  // Getters
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  List<OrderListModel> get orders => _orders;
  OrderDetailModel? get orderDetail => _orderDetail;
  bool get hasMore => _paginatedResponse?.hasNext ?? false;

  /// Load orders with pagination
  /// Requires user UUID for authenticated request
  Future<void> loadOrders({
    required String userUuid,
    bool refresh = false,
  }) async {
    try {
      if (refresh) {
        _currentPage = 0;
        _orders.clear();
        _isLoading = true;
      } else {
        _isLoadingMore = true;
      }
      _error = null;
      notifyListeners();

      final response = await _repository.getOrders(
        userUuid: userUuid,
        page: _currentPage,
        size: _pageSize,
      );

      if (refresh) {
        _orders = response.content;
      } else {
        _orders.addAll(response.content);
      }

      _paginatedResponse = response;
      _currentPage++;
      _error = null;
    } on NetworkException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'An unexpected error occurred: ${e.toString()}';
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Load more orders (pagination)
  Future<void> loadMoreOrders({required String userUuid}) async {
    if (_isLoadingMore || !hasMore) return;
    await loadOrders(userUuid: userUuid);
  }

  /// Get order by ID
  Future<void> getOrderById(int orderId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _orderDetail = await _repository.getOrderById(orderId);
      _error = null;
    } on NetworkException catch (e) {
      _error = e.message;
      _orderDetail = null;
    } catch (e) {
      _error = 'An unexpected error occurred: ${e.toString()}';
      _orderDetail = null;
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
}

