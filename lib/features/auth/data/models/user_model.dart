/// User model representing authenticated user data
class UserModel {
  final int userId;
  final String name;
  final String mobileNumber;
  final String? email;
  final String role;

  UserModel({
    required this.userId,
    required this.name,
    required this.mobileNumber,
    this.email,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as int,
      name: json['name'] as String,
      mobileNumber: json['mobileNumber'] as String,
      email: json['email'] as String?,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'mobileNumber': mobileNumber,
      'email': email,
      'role': role,
    };
  }
}

/// Login response model
class LoginResponse {
  final String otpRefId;
  final int expiresInSeconds;

  LoginResponse({
    required this.otpRefId,
    required this.expiresInSeconds,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      otpRefId: json['otpRefId'] as String,
      expiresInSeconds: json['expiresInSeconds'] as int,
    );
  }
}

/// OTP verification response model
class VerifyOtpResponse {
  final int userId;
  final bool isNewUser;
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  VerifyOtpResponse({
    required this.userId,
    required this.isNewUser,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      userId: json['userId'] as int,
      isNewUser: json['isNewUser'] as bool,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresIn: json['expiresIn'] as int,
    );
  }
}

