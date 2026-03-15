import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../storage/secure_storage_service.dart';

/// Attaches the JWT access token to every outgoing request.
/// On 401 responses it clears the stored token so the app redirects to login.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._ref);

  final Ref _ref;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final storage = _ref.read(secureStorageServiceProvider);
    final token = await storage.readAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Clear tokens so the auth state notifier reacts and redirects to login.
      final storage = _ref.read(secureStorageServiceProvider);
      await storage.deleteTokens();
    }
    handler.next(err);
  }
}
