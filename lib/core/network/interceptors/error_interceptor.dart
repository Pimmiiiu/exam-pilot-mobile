import 'package:dio/dio.dart';

import '../../errors/app_exception.dart';

/// Converts Dio errors into typed [AppException] subclasses.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final AppException exception;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        exception = const NetworkException(message: 'Request timed out. Please check your connection.');
      case DioExceptionType.connectionError:
        exception = const NetworkException(message: 'No internet connection.');
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode ?? 0;
        if (statusCode == 401) {
          exception = const UnauthorizedException();
        } else {
          final message = _extractMessage(err.response) ?? 'Server error ($statusCode)';
          exception = ServerException(message: message, statusCode: statusCode);
        }
      default:
        exception = NetworkException(message: err.message ?? 'An unexpected network error occurred.');
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: exception,
        response: err.response,
        type: err.type,
        message: exception.message,
      ),
    );
  }

  String? _extractMessage(Response? response) {
    if (response?.data is Map) {
      final data = response!.data as Map;
      return data['detail']?.toString() ?? data['message']?.toString();
    }
    return null;
  }
}
