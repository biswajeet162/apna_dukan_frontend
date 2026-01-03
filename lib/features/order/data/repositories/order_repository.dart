import '../models/order_model.dart';
import '../models/paginated_response.dart';
import '../sources/order_remote_source.dart';
import '../../../../core/network/network_exceptions.dart';

/// Repository for order data operations
class OrderRepository {
  final OrderRemoteSource _remoteSource;

  OrderRepository(this._remoteSource);

  /// Get user's order history with pagination
  Future<PaginatedResponse<OrderListModel>> getOrders({
    required String userUuid,
    int page = 0,
    int size = 10,
  }) async {
    try {
      return await _remoteSource.getOrders(
        userUuid: userUuid,
        page: page,
        size: size,
      );
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error: ${e.toString()}');
    }
  }

  /// Get order details by ID
  Future<OrderDetailModel> getOrderById(int orderId) async {
    try {
      return await _remoteSource.getOrderById(orderId);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error: ${e.toString()}');
    }
  }
}

