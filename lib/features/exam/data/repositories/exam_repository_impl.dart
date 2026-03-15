import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/exam.dart';
import '../../domain/repositories/exam_repository.dart';
import '../datasources/exam_remote_data_source.dart';
import '../models/exam_dto.dart';

final examRepositoryProvider = Provider<ExamRepository>((ref) {
  return ExamRepositoryImpl(ref.watch(examRemoteDataSourceProvider));
});

class ExamRepositoryImpl implements ExamRepository {
  ExamRepositoryImpl(this._remote);

  final ExamRemoteDataSource _remote;

  @override
  Future<List<Exam>> getExams() async {
    final dtos = await _remote.getExams();
    return dtos.map((d) => d.toEntity()).toList();
  }

  @override
  Future<Exam> getExamDetail(String examId) async {
    final dto = await _remote.getExamDetail(examId);
    return dto.toEntity();
  }

  @override
  Future<String> submitExam(ExamSubmission submission) async {
    final dto = ExamSubmissionDto(
      examId: submission.examId,
      answers: submission.answers
          .map((a) => UserAnswerDto(
                questionId: a.questionId,
                choiceId: a.choiceId,
              ))
          .toList(),
    );
    return _remote.submitExam(dto);
  }
}
