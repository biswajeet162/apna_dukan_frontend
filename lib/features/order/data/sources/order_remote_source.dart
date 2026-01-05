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
        fromJson: (data) => Map<String, dynamic>.from(data as Map),
      );

      if (!response.success || response.data == null) {
        throw NetworkException(response.message);
      }

      final data = response.data!['data'] != null ? Map<String, dynamic>.from(response.data!['data'] as Map) : null;
      if (data == null) {
        throw NetworkException('Invalid response format');
      }

      final content = (data['content'] as List<dynamic>?)
              ?.map((json) => OrderListModel.fromJson(Map<String, dynamic>.from(json as Map)))
              .toList() ??
          [];

      return PaginatedResponse<OrderListModel>(
        content: content,
        totalElements: data['totalElements']?.toInt() ?? content.length,
        totalPages: data['totalPages']?.toInt() ?? 1,
        currentPage: data['page']?.toInt() ?? page,
        size: data['size']?.toInt() ?? size,
        hasNext: (data['page']?.toInt() ?? page) < ((data['totalPages']?.toInt() ?? 1) - 1),
        hasPrevious: (data['page']?.toInt() ?? page) > 0,
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
        fromJson: (data) => Map<String, dynamic>.from(data as Map),
      );

      if (!response.success || response.data == null) {
        throw NetworkException(response.message);
      }

      final data = response.data!['data'] != null ? Map<String, dynamic>.from(response.data!['data'] as Map) : null;
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

