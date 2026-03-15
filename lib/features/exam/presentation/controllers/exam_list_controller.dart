import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/exam_repository_impl.dart';
import '../../domain/entities/exam.dart';
import '../../domain/usecases/fetch_exams_use_case.dart';

final examListControllerProvider =
    AsyncNotifierProvider.autoDispose<ExamListController, List<Exam>>(() {
  return ExamListController();
});

class ExamListController extends AutoDisposeAsyncNotifier<List<Exam>> {
  @override
  Future<List<Exam>> build() async {
    final useCase = FetchExamsUseCase(ref.watch(examRepositoryProvider));
    return useCase.call();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      final useCase = FetchExamsUseCase(ref.watch(examRepositoryProvider));
      return useCase.call();
    });
  }
}
