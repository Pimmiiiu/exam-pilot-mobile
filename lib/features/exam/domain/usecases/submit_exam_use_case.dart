import '../entities/exam.dart';
import '../repositories/exam_repository.dart';

class SubmitExamUseCase {
  const SubmitExamUseCase(this._repository);
  final ExamRepository _repository;

  /// Returns the attempt ID returned by the server.
  Future<String> call(ExamSubmission submission) =>
      _repository.submitExam(submission);
}
