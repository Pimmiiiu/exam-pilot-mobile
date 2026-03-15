import '../entities/exam.dart';
import '../repositories/exam_repository.dart';

class FetchExamsUseCase {
  const FetchExamsUseCase(this._repository);
  final ExamRepository _repository;
  Future<List<Exam>> call() => _repository.getExams();
}
