import '../entities/auth_tokens.dart';

abstract interface class AuthRepository {
  /// Authenticates with email and password, returns tokens on success.
  Future<AuthTokens> login({required String email, required String password});

  /// Creates a new account, returns tokens on success.
  Future<AuthTokens> register({
    required String name,
    required String email,
    required String password,
  });

  /// Loads tokens from secure storage. Returns null if none are stored.
  Future<AuthTokens?> getStoredTokens();

  /// Clears stored tokens and invalidates the session.
  Future<void> logout();
}
