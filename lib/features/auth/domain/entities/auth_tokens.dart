class AuthTokens {
  const AuthTokens({
    required this.accessToken,
    this.refreshToken,
  });

  final String accessToken;
  final String? refreshToken;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthTokens &&
          runtimeType == other.runtimeType &&
          accessToken == other.accessToken &&
          refreshToken == other.refreshToken;

  @override
  int get hashCode => Object.hash(accessToken, refreshToken);

  @override
  String toString() => 'AuthTokens(accessToken: [hidden])';
}
