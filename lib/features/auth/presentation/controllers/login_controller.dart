import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/usecases/login_use_case.dart';
import 'auth_session_controller.dart';

final loginControllerProvider =
    AsyncNotifierProvider.autoDispose<LoginController, void>(() {
  return LoginController();
});

class LoginController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final useCase = LoginUseCase(ref.watch(authRepositoryProvider));
      final tokens = await useCase.call(email: email, password: password);
      await ref
          .read(authSessionControllerProvider.notifier)
          .setTokens(tokens);
    });
  }
}
