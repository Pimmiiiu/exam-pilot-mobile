import '../entities/exam_result.dart';

abstract interface class ResultRepository {
  Future<ExamResult> getResult(String attemptId);
}
