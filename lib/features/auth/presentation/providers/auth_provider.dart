import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../../../core/network/api_client.dart';

/// Provider for managing authentication state
class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;
  final ApiClient _apiClient;

  AuthProvider(this._repository, this._apiClient) {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');
    _refreshToken = prefs.getString('refresh_token');
    if (_accessToken != null) {
      _isAuthenticated = true;
      // Fetch user profile if token exists
      await getMe();
    }
    notifyListeners();
  }

  Future<void> _saveTokens(String access, String refresh) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', access);
    await prefs.setString('refresh_token', refresh);
  }

  Future<void> _clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  // State variables
  bool _isLoading = false;
  String? _error;
  UserModel? _user;
  String? _accessToken;
  String? _refreshToken;
  String? _otpRefId;
  bool _isAuthenticated = false;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  UserModel? get user => _user;
  String? get accessToken => _accessToken;
  bool get isAuthenticated => _isAuthenticated;

  /// Login - Send OTP to mobile number
  Future<bool> login(String mobileNumber) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _repository.login(mobileNumber);
      _otpRefId = response.otpRefId;
      _error = null;
      return true;
    } on NetworkException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Signup - Register and login
  Future<bool> signup(
    String mobileNumber,
    String firstName,
    String password, {
    String? lastName,
    String? email,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _repository.signup(
        mobileNumber,
        firstName,
        password,
        lastName: lastName,
        email: email,
      );

      _accessToken = response.accessToken;
      _refreshToken = response.refreshToken;
      _isAuthenticated = true;

      // Persist tokens
      await _saveTokens(_accessToken!, _refreshToken!);

      // Fetch user profile
      await getMe();

      _error = null;
      return true;
    } on NetworkException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Verify OTP and authenticate user
  Future<bool> verifyOtp(String otp) async {
    try {
      if (_otpRefId == null) {
        _error = 'OTP reference ID not found. Please request OTP again.';
        return false;
      }

      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _repository.verifyOtp(_otpRefId!, otp);
      _accessToken = response.accessToken;
      _refreshToken = response.refreshToken;
      _isAuthenticated = true;

      // Persist tokens
      await _saveTokens(_accessToken!, _refreshToken!);

      // Fetch user profile
      await getMe();

      _error = null;
      return true;
    } on NetworkException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get current user profile
  Future<void> getMe() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _user = await _repository.getMe();
      _error = null;
    } on NetworkException catch (e) {
      _error = e.message;
      _user = null;
    } catch (e) {
      _error = 'An unexpected error occurred: ${e.toString()}';
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _repository.logout();
      
      // Clear state
      _user = null;
      _accessToken = null;
      _refreshToken = null;
      _otpRefId = null;
      _isAuthenticated = false;

      // Clear persisted tokens
      await _clearTokens();

      _error = null;
    } on NetworkException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'An unexpected error occurred: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update user profile
  Future<bool> updateProfile({
    String? name,
    String? email,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _user = await _repository.updateProfile(name: name, email: email);
      _error = null;
      return true;
    } on NetworkException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Clear OTP reference ID (for resending OTP)
  void clearOtpRefId() {
    _otpRefId = null;
    notifyListeners();
  }
}

