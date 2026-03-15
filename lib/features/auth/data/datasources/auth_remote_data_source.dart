import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_dto.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.watch(dioClientProvider));
});

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<AuthTokensDto> login(LoginRequestDto dto) async {
    final response = await _dio.post<Map<String, dynamic>>(
      AppConstants.loginEndpoint,
      data: dto.toJson(),
    );
    return AuthTokensDto.fromJson(response.data!);
  }

  Future<AuthTokensDto> register(RegisterRequestDto dto) async {
    final response = await _dio.post<Map<String, dynamic>>(
      AppConstants.registerEndpoint,
      data: dto.toJson(),
    );
    return AuthTokensDto.fromJson(response.data!);
  }
}
