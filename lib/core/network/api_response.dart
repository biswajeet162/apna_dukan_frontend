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
    if (value == null) return null;
    
    if (value is Map) {
      // Convert Map to Map<String, dynamic> explicitly
      final Map<String, dynamic> sanitized = <String, dynamic>{};
      value.forEach((key, val) {
        sanitized[key.toString()] = _sanitizeValue(val);
      });
      return sanitized;
    } else if (value is List) {
      // Convert List to List<dynamic> explicitly
      // This ensures type safety in Flutter Web release mode
      final List<dynamic> sanitized = <dynamic>[];
      for (final item in value) {
        sanitized.add(_sanitizeValue(item));
      }
      return sanitized;
    } else if (value is Iterable && value is! List) {
      // Handle other iterable types
      return value.map((item) => _sanitizeValue(item)).toList();
    }
    
    // For primitives, ensure they're properly typed
    if (value is num) return value;
    if (value is bool) return value;
    if (value is String) return value;
    
    // For any other type, convert to string as fallback
    return value.toString();
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

