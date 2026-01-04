/// Environment configuration
class Env {
  /// Use mock server instead of real API
  static const bool useMockServer = false;
  
  /// Deployed mock server URL
  static const String mockServerUrl = 'https://json-mock-server-7vtn.onrender.com/';
  
  /// Production API URL (when useMockServer is false)
  static const String productionApiUrl = 'http://localhost:8080';
  
  /// Get the base URL based on environment
  static String get baseUrl => useMockServer ? mockServerUrl : productionApiUrl;
}

