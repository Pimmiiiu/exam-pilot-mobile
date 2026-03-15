import '../../domain/entities/auth_tokens.dart';

class AuthTokensDto {
  const AuthTokensDto({
    required this.accessToken,
    this.refreshToken,
  });

  factory AuthTokensDto.fromJson(Map<String, dynamic> json) => AuthTokensDto(
        accessToken: json['access_token'] as String,
        refreshToken: json['refresh_token'] as String?,
      );

  final String accessToken;
  final String? refreshToken;

  AuthTokens toEntity() => AuthTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
}

class LoginRequestDto {
  const LoginRequestDto({required this.email, required this.password});

  final String email;
  final String password;

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

class RegisterRequestDto {
  const RegisterRequestDto({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
      };
}
