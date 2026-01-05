import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/user_model.dart';

/// Remote data source for authentication operations
class AuthRemoteSource {
  final ApiClient _apiClient;

  AuthRemoteSource(this._apiClient);

  /// Login - Direct password login
  Future<dynamic> login(String mobileNumber, String password) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: {
          'mobileNumber': mobileNumber,
          'password': password,
        },
        fromJson: (data) => data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{},
      );

      if (!response.success || response.data == null) {
        throw NetworkException(response.message);
      }

      // Check if it returned tokens (password login) or otpRefId (otp login request)
      if (response.data!.containsKey('accessToken')) {
        return VerifyOtpResponse.fromJson(response.data!);
      } else {
        return LoginResponse.fromJson(response.data!);
      }
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Failed to login: ${e.toString()}');
    }
  }

  /// Signup - Register user and get tokens
  Future<VerifyOtpResponse> signup(
    String mobileNumber,
    String firstName,
    String password, {
    String? lastName,
    String? email,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiEndpoints.signup,
        data: {
          'mobileNumber': mobileNumber,
          'firstName': firstName,
          'password': password,
          if (lastName != null) 'lastName': lastName,
          if (email != null) 'email': email,
        },
        fromJson: (data) => data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{},
      );

      if (!response.success || response.data == null) {
        throw NetworkException(response.message);
      }

      return VerifyOtpResponse.fromJson(response.data!);
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Failed to register: ${e.toString()}');
    }
  }

  /// Verify OTP and get tokens
  Future<VerifyOtpResponse> verifyOtp(String otpRefId, String otp) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiEndpoints.verifyOtp,
        data: {
          'otpRefId': otpRefId,
          'otp': otp,
        },
        fromJson: (data) => data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{},
      );

      if (!response.success || response.data == null) {
        throw NetworkException(response.message);
      }

      return VerifyOtpResponse.fromJson(response.data!);
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Failed to verify OTP: ${e.toString()}');
    }
  }

  /// Refresh access token
  Future<VerifyOtpResponse> refreshToken(String refreshToken) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiEndpoints.refreshToken,
        data: {
          'refreshToken': refreshToken,
        },
        fromJson: (data) => data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{},
      );

      if (!response.success || response.data == null) {
        throw NetworkException(response.message);
      }

      return VerifyOtpResponse.fromJson(response.data!);
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Failed to refresh token: ${e.toString()}');
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      final response = await _apiClient.post<dynamic>(
        ApiEndpoints.logout,
        fromJson: (data) => data,
      );

      if (!response.success) {
        throw NetworkException(response.message);
      }
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Failed to logout: ${e.toString()}');
    }
  }

  /// Get current user profile
  Future<UserModel> getMe() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiEndpoints.me,
        fromJson: (data) => data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{},
      );

      if (!response.success || response.data == null) {
        throw NetworkException(response.message);
      }

      return UserModel.fromJson(response.data!);
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Failed to fetch user profile: ${e.toString()}');
    }
  }

  /// Update user profile
  Future<UserModel> updateProfile({
    String? name,
    String? email,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (email != null) data['email'] = email;

      final response = await _apiClient.put<Map<String, dynamic>>(
        ApiEndpoints.updateProfile,
        data: data,
        fromJson: (data) => data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{},
      );

      if (!response.success || response.data == null) {
        throw NetworkException(response.message);
      }

      return UserModel.fromJson(response.data!);
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Failed to update profile: ${e.toString()}');
    }
  }
}

