/// Base class for all application exceptions.
class AppException implements Exception {
  const AppException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'AppException(message: $message, statusCode: $statusCode)';
}

class NetworkException extends AppException {
  const NetworkException({required super.message, super.statusCode});
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({super.message = 'Unauthorized. Please log in again.'});
}

class ServerException extends AppException {
  const ServerException({required super.message, super.statusCode});
}

class CacheException extends AppException {
  const CacheException({required super.message});
}
