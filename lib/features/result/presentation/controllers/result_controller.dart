import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/result_repository_impl.dart';
import '../../domain/entities/exam_result.dart';
import '../../domain/usecases/get_result_use_case.dart';

final resultControllerProvider =
    AsyncNotifierProvider.family<ResultController, ExamResult, String>(
  ResultController.new,
);

class ResultController extends FamilyAsyncNotifier<ExamResult, String> {
  @override
  Future<ExamResult> build(String arg) async {
    final useCase = GetResultUseCase(ref.watch(resultRepositoryProvider));
    return useCase.call(arg);
  }
}
