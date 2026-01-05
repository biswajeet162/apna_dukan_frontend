import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/order_model.dart';
import '../models/paginated_response.dart';

/// Remote data source for order operations
class OrderRemoteSource {
  final ApiClient _apiClient;

  OrderRemoteSource(this._apiClient);

  /// Fetch user's order history with pagination
  /// Requires authenticated user with UUID and token
  Future<PaginatedResponse<OrderListModel>> getOrders({
    required String userUuid,
    int page = 0,
    int size = 10,
  }) async {
    try {
      // POST request with user UUID in body and pagination in query params
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiEndpoints.orders,
        data: {
          'userUuid': userUuid,
        },
        queryParameters: {
          'page': page,
          'size': size,
        },
        fromJson: (data) => data is Map ? Map<String, dynamic>.from(data) : {},
      );

      if (!response.success || response.data == null) {
        throw NetworkException(response.message);
      }

      final data = response.data!['data'] is Map ? Map<String, dynamic>.from(response.data!['data'] as Map) : null;
      if (data == null) {
        throw NetworkException('Invalid response format');
      }

      final content = data['content'] is List
          ? (data['content'] as List)
              .map((item) => OrderListModel.fromJson(item is Map ? Map<String, dynamic>.from(item) : {}))
              .toList()
          : <OrderListModel>[];

      return PaginatedResponse<OrderListModel>(
        content: content,
        totalElements: int.tryParse(data['totalElements']?.toString() ?? '') ?? content.length,
        totalPages: int.tryParse(data['totalPages']?.toString() ?? '') ?? 1,
        currentPage: int.tryParse(data['page']?.toString() ?? '') ?? page,
        size: int.tryParse(data['size']?.toString() ?? '') ?? size,
        hasNext: (int.tryParse(data['page']?.toString() ?? '') ?? page) < ((int.tryParse(data['totalPages']?.toString() ?? '') ?? 1) - 1),
        hasPrevious: (int.tryParse(data['page']?.toString() ?? '') ?? page) > 0,
      );
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Failed to fetch orders: ${e.toString()}');
    }
  }

  /// Fetch order details by ID
  Future<OrderDetailModel> getOrderById(int orderId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiEndpoints.orderById(orderId),
        fromJson: (data) => data is Map ? Map<String, dynamic>.from(data) : {},
      );

      if (!response.success || response.data == null) {
        throw NetworkException(response.message);
      }

      final data = response.data!['data'] is Map ? Map<String, dynamic>.from(response.data!['data'] as Map) : null;
      if (data == null) {
        throw NetworkException('Invalid response format');
      }

      return OrderDetailModel.fromJson(data);
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Failed to fetch order details: ${e.toString()}');
    }
  }
}

