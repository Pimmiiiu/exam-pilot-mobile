import '../entities/exam.dart';
import '../repositories/exam_repository.dart';

class FetchExamDetailUseCase {
  const FetchExamDetailUseCase(this._repository);
  final ExamRepository _repository;
  Future<Exam> call(String examId) => _repository.getExamDetail(examId);
}
