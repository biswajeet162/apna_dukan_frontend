import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../constants/api_endpoints.dart';
import 'api_response.dart';
import 'network_exceptions.dart';
import 'auth_interceptor.dart';

/// API Client using Dio for HTTP requests
class ApiClient {
  late final Dio _dio;

  ApiClient() {
    final baseUrl = ApiEndpoints.baseUrl;
    print('🌐 API Client initialized with baseUrl: $baseUrl');
    
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10), // Reduced timeout for faster error feedback
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(AuthInterceptor());
    if (!kReleaseMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ));
    }
  }

  // Removed manual token management in favor of AuthInterceptor

  /// Handle API response and convert to ApiResponse
  Future<ApiResponse<T>> _handleResponse<T>(
    Response response,
    T Function(dynamic)? fromJson,
  ) async {
    try {
      final dynamic data = response.data;
      if (data is Map) {
        // Explicitly create a new Map to ensure we break any internal Dio/Web specific Map types
        final mapData = Map<dynamic, dynamic>.from(data);
        return ApiResponse.fromJson(mapData, fromJson);
      }
      throw NetworkException('Invalid response format');
    } catch (e) {
      throw NetworkException('Failed to parse response: ${e.toString()}');
    }
  }

  /// Handle errors and convert to appropriate exceptions
  NetworkException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout. Please check if the server is running.');
      case DioExceptionType.connectionError:
        return NetworkException('Connection error. Please check your internet connection and if the server is accessible.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'An error occurred';
        switch (statusCode) {
          case 400:
            return BadRequestException(message, statusCode);
          case 401:
            return UnauthorizedException(message, statusCode);
          case 403:
            return ForbiddenException(message, statusCode);
          case 404:
            return NotFoundException(message, statusCode);
          case 500:
          default:
            return ServerException(message, statusCode);
        }
      case DioExceptionType.cancel:
        return NetworkException('Request cancelled');
      default:
        return NetworkException('Network error: ${error.message}');
    }
  }

  /// GET request
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT request
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE request
  Future<ApiResponse<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        queryParameters: queryParameters,
      );
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
}

