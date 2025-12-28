import 'package:flutter/material.dart';

/// App color constants
class AppColors {
  // Primary colors
  static const Color primaryRed = Color(0xFFE53935); // Red color for app
  static const Color primaryDark = Color(0xFF000000);
  
  // Text colors
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textGrey = Color(0xFF9E9E9E);
  
  // Background colors
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color backgroundGrey = Color(0xFFF5F5F5);
  
  // Accent colors
  static const Color discountYellow = Color(0xFFFFC107);
  static const Color newBadgeBlue = Color(0xFF2196F3);
  
  // Gradient colors for auth screens
  static const Color gradientPurple = Color(0xFF9C27B0);
  static const Color gradientPink = Color(0xFFE91E63);
  static const Color gradientLightPurple = Color(0xFFBA68C8);
  static const Color gradientLightPink = Color(0xFFF06292);
  
  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gradientPurple, gradientPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient lightGradient = LinearGradient(
    colors: [Color(0xFFF3E5F5), Colors.white],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

