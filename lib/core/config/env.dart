enum AppEnvironment { local, dev, prod }

/// Environment configuration
class Env {
  /// Current environment
  static const AppEnvironment current = AppEnvironment.local;

  /// Use mock server instead of real API
  static const bool useMockServer = false;
  
  /// Deployed mock server URL
  static const String mockServerUrl = 'https://json-mock-server-7vtn.onrender.com/';
  
  /// Local API URL
  static const String localApiUrl = 'http://localhost:8080';
  
  /// Development API URL
  static const String devApiUrl = 'https://dev-api.apnadukan.com';
  
  /// Production API URL
  static const String productionApiUrl = 'https://api.apnadukan.com';
  
  /// Get the base URL based on environment and mock setting
  static String get baseUrl {
    if (useMockServer) return mockServerUrl;
    
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

