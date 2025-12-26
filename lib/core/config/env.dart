/// Environment configuration
class Env {
  /// Use mock server instead of real API
  static const bool useMockServer = true;
  
  /// Deployed mock server URL
  static const String mockServerUrl = 'https://json-web-server-oxr2.onrender.com';
  
  /// Production API URL (when useMockServer is false)
  static const String productionApiUrl = 'http://your-api-url.com';
  
  /// Get the base URL based on environment
  static String get baseUrl => useMockServer ? mockServerUrl : productionApiUrl;
}

