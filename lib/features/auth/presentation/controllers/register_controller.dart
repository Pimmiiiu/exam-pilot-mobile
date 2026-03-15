import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/register_use_case.dart';
import 'auth_session_controller.dart';

final registerControllerProvider =
    AsyncNotifierProvider.autoDispose<RegisterController, void>(() {
  return RegisterController();
});

class RegisterController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final useCase = RegisterUseCase(ref.watch(authRepositoryProvider));
      final tokens = await useCase.call(
        name: name,
        email: email,
        password: password,
      );
      await ref
          .read(authSessionControllerProvider.notifier)
          .setTokens(tokens);
    });
  }
}
