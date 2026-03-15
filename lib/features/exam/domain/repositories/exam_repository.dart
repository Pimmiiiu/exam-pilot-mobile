import '../entities/exam.dart';

abstract interface class ExamRepository {
  Future<List<Exam>> getExams();
  Future<Exam> getExamDetail(String examId);
  Future<String> submitExam(ExamSubmission submission);
}
