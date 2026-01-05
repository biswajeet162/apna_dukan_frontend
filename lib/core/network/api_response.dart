/// Generic API response wrapper matching backend structure
/// {
///   "success": true or false,
///   "message": "Human readable message",
///   "data": actual response object or list
/// }
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<dynamic, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    // Safely cast keys to String for internal usage if needed
    final Map<String, dynamic> safeJson = Map<String, dynamic>.from(json);
    
    return ApiResponse<T>(
      success: safeJson['success'] ?? false,
      message: safeJson['message'] ?? '',
      data: safeJson['data'] != null
          ? (fromJsonT != null ? fromJsonT(safeJson['data']) : safeJson['data'] as T)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
    };
  }
}

