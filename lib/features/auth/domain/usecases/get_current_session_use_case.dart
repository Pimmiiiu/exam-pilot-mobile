import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';

class GetCurrentSessionUseCase {
  const GetCurrentSessionUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthTokens?> call() => _repository.getStoredTokens();
}
