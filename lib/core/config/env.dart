import 'package:flutter/foundation.dart';

enum AppEnvironment { local, dev, prod }

/// Environment configuration
class Env {
  /// Current environment - automatically determined based on platform and build mode
  static AppEnvironment get current {
    if (!kIsWeb) {
      // Android / iOS always use production backend as requested
      return AppEnvironment.prod;
    }
    
    // For Web, switch based on debug/release mode
    return kReleaseMode ? AppEnvironment.prod : AppEnvironment.local;
  }

  /// Local API URL
  /// For Android emulator, use 'http://10.0.2.2:8080'
  /// For iOS simulator or Web, use 'http://localhost:8080'
  static const String localApiUrl = 'http://localhost:8080';
  
  /// Development API URL
  static const String devApiUrl = 'https://dev-api.apnadukan.com';
  
  /// Production API URL
  static const String productionApiUrl = 'https://apna-dukan-backend.onrender.com';
  
  /// Get the base URL based on environment
  static String get baseUrl {
    switch (current) {
      case AppEnvironment.local:
        return localApiUrl;
      case AppEnvironment.dev:
        return devApiUrl;
      case AppEnvironment.prod:
        return productionApiUrl;
    }
  }
}

