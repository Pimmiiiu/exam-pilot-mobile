import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_dto.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    storageService: ref.watch(secureStorageServiceProvider),
  );
});

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorageService storageService,
  })  : _remote = remoteDataSource,
        _storage = storageService;

  final AuthRemoteDataSource _remote;
  final SecureStorageService _storage;

  @override
  Future<AuthTokens> login({
    required String email,
    required String password,
  }) async {
    final dto = await _remote.login(
      LoginRequestDto(email: email, password: password),
    );
    final tokens = dto.toEntity();
    await _persistTokens(tokens);
    return tokens;
  }

  @override
  Future<AuthTokens> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final dto = await _remote.register(
      RegisterRequestDto(name: name, email: email, password: password),
    );
    final tokens = dto.toEntity();
    await _persistTokens(tokens);
    return tokens;
  }

  @override
  Future<AuthTokens?> getStoredTokens() async {
    final accessToken = await _storage.readAccessToken();
    if (accessToken == null) return null;
    final refreshToken = await _storage.readRefreshToken();
    return AuthTokens(accessToken: accessToken, refreshToken: refreshToken);
  }

  @override
  Future<void> logout() => _storage.deleteTokens();

  Future<void> _persistTokens(AuthTokens tokens) async {
    await _storage.writeAccessToken(tokens.accessToken);
    if (tokens.refreshToken != null) {
      await _storage.writeRefreshToken(tokens.refreshToken!);
    }
  }
}
