import '../models/user_model.dart';
import '../sources/auth_remote_source.dart';
import '../../../../core/network/network_exceptions.dart';

/// Repository for authentication operations
class AuthRepository {
  final AuthRemoteSource _remoteSource;

  AuthRepository(this._remoteSource);

  /// Login - Send OTP to mobile number
  Future<LoginResponse> login(String mobileNumber) async {
    try {
      return await _remoteSource.login(mobileNumber);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error during login: ${e.toString()}');
    }
  }

  /// Signup - Send OTP to mobile number for registration
  Future<LoginResponse> signup(String mobileNumber, {String? name, String? email}) async {
    try {
      return await _remoteSource.signup(mobileNumber, name: name, email: email);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error during signup: ${e.toString()}');
    }
  }

  /// Verify OTP and get tokens
  Future<VerifyOtpResponse> verifyOtp(String otpRefId, String otp) async {
    try {
      return await _remoteSource.verifyOtp(otpRefId, otp);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error during OTP verification: ${e.toString()}');
    }
  }

  /// Refresh access token
  Future<VerifyOtpResponse> refreshToken(String refreshToken) async {
    try {
      return await _remoteSource.refreshToken(refreshToken);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error during token refresh: ${e.toString()}');
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      return await _remoteSource.logout();
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error during logout: ${e.toString()}');
    }
  }

  /// Get current user profile
  Future<UserModel> getMe() async {
    try {
      return await _remoteSource.getMe();
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error fetching user profile: ${e.toString()}');
    }
  }

  /// Update user profile
  Future<UserModel> updateProfile({
    String? name,
    String? email,
  }) async {
    try {
      return await _remoteSource.updateProfile(name: name, email: email);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Unexpected error updating profile: ${e.toString()}');
    }
  }
}

