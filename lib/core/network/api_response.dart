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
    dynamic json,
    T Function(dynamic)? fromJsonT,
  ) {
    // Manually build the map to ensure it's a clean Map<String, dynamic>
    // This is the safest way to avoid 'ki vs fL' TypeErrors in Flutter Web release mode
    final Map<String, dynamic> safeJson = <String, dynamic>{};
    if (json is Map) {
      json.forEach((key, value) {
        safeJson[key.toString()] = value;
      });
    }
    
    return ApiResponse<T>(
      success: safeJson['success'] ?? false,
      message: safeJson['message'] ?? '',
      data: safeJson['data'] != null
          ? (fromJsonT != null
              ? fromJsonT(safeJson['data'])
              : (safeJson['data'] is T ? safeJson['data'] as T : null))
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

