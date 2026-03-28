class AppException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;

  const AppException({
    required this.message,
    this.statusCode,
    this.errorCode,
  });

  @override
  String toString() => 'AppException: $message (code: $statusCode)';
}

class NetworkException extends AppException {
  const NetworkException({String message = 'Geen internetverbinding'})
      : super(message: message);
}

class ServerException extends AppException {
  const ServerException({
    String message = 'Server fout',
    int? statusCode,
  }) : super(message: message, statusCode: statusCode);
}

class AuthException extends AppException {
  const AuthException({String message = 'Niet geautoriseerd'})
      : super(message: message, statusCode: 401);
}

class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    String message = 'Validatie fout',
    this.fieldErrors,
  }) : super(message: message, statusCode: 422);
}
