/// Environment configuration
class Env {
  /// Use mock server instead of real API
  static const bool useMockServer = true;
  
  /// Deployed mock server URL
  static const String mockServerUrl = 'https://json-mock-server-7vtn.onrender.com/';
  
  /// Production API URL (when useMockServer is false)
  static const String productionApiUrl = 'http://your-api-url.com';
  
  /// Get the base URL based on environment
  static String get baseUrl => useMockServer ? mockServerUrl : productionApiUrl;
}

