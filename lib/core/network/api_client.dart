import '../constants/api_constants.dart';

/// HTTP client - simplified for UI phase
class ApiClient {
  String? _authToken;

  void setAuthToken(String token) => _authToken = token;
  void clearAuthToken() => _authToken = null;

  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
  };

  String get baseUrl => '${ApiConstants.baseUrl}${ApiConstants.apiVersion}';
}
