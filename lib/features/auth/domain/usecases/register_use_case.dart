import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthTokens> call({
    required String name,
    required String email,
    required String password,
  }) =>
      _repository.register(name: name, email: email, password: password);
}
