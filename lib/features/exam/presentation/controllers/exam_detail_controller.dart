import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/exam_repository_impl.dart';
import '../../domain/entities/exam.dart';
import '../../domain/usecases/fetch_exam_detail_use_case.dart';

final examDetailControllerProvider =
    AsyncNotifierProvider.family<ExamDetailController, Exam, String>(
  ExamDetailController.new,
);

class ExamDetailController extends FamilyAsyncNotifier<Exam, String> {
  @override
  Future<Exam> build(String arg) async {
    final useCase = FetchExamDetailUseCase(ref.watch(examRepositoryProvider));
    return useCase.call(arg);
  }
}
