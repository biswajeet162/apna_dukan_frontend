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

  /// Recursively convert nested Maps and Lists to proper types
  /// This is critical for Flutter Web release mode to avoid type errors
  static dynamic _sanitizeValue(dynamic value) {
    if (value is Map) {
      final Map<String, dynamic> sanitized = <String, dynamic>{};
      value.forEach((key, val) {
        sanitized[key.toString()] = _sanitizeValue(val);
      });
      return sanitized;
    } else if (value is List) {
      return value.map((item) => _sanitizeValue(item)).toList();
    }
    return value;
  }

  factory ApiResponse.fromJson(
    dynamic json,
    T Function(dynamic)? fromJsonT,
  ) {
    // Manually build the map to ensure it's a clean Map<String, dynamic>
    // This is the safest way to avoid 'ki vs fL' TypeErrors in Flutter Web release mode
    final Map<String, dynamic> safeJson = <String, dynamic>{};
    if (json is Map) {
      json.forEach((key, value) {
        safeJson[key.toString()] = _sanitizeValue(value);
      });
    }
    
    return ApiResponse<T>(
      success: safeJson['success'] ?? false,
      message: safeJson['message']?.toString() ?? '',
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

