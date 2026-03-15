import '../entities/exam_result.dart';
import '../repositories/result_repository.dart';

class GetResultUseCase {
  const GetResultUseCase(this._repository);
  final ResultRepository _repository;
  Future<ExamResult> call(String attemptId) => _repository.getResult(attemptId);
}
