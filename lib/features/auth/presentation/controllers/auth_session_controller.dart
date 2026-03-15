import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/usecases/get_current_session_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';

/// Watches the current authentication state.
/// Exposes [AuthTokens] when logged in, or null when logged out.
final authSessionControllerProvider =
    AsyncNotifierProvider<AuthSessionController, AuthTokens?>(() {
  return AuthSessionController();
});

class AuthSessionController extends AsyncNotifier<AuthTokens?> {
  @override
  Future<AuthTokens?> build() async {
    final useCase = GetCurrentSessionUseCase(ref.watch(authRepositoryProvider));
    return useCase.call();
  }

  Future<void> setTokens(AuthTokens tokens) async {
    state = AsyncData(tokens);
  }

  Future<void> logout() async {
    final useCase = LogoutUseCase(ref.watch(authRepositoryProvider));
    await useCase.call();
    state = const AsyncData(null);
  }
}
