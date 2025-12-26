/// Network exception classes
class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  NetworkException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class ServerException extends NetworkException {
  ServerException(super.message, [super.statusCode]);
}

class NotFoundException extends NetworkException {
  NotFoundException(super.message, [super.statusCode]);
}

class BadRequestException extends NetworkException {
  BadRequestException(super.message, [super.statusCode]);
}

class UnauthorizedException extends NetworkException {
  UnauthorizedException(super.message, [super.statusCode]);
}

class ForbiddenException extends NetworkException {
  ForbiddenException(super.message, [super.statusCode]);
}

