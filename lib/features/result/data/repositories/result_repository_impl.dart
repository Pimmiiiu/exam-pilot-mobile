import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/exam_result.dart';
import '../../domain/repositories/result_repository.dart';
import '../datasources/result_remote_data_source.dart';

final resultRepositoryProvider = Provider<ResultRepository>((ref) {
  return ResultRepositoryImpl(ref.watch(resultRemoteDataSourceProvider));
});

class ResultRepositoryImpl implements ResultRepository {
  ResultRepositoryImpl(this._remote);

  final ResultRemoteDataSource _remote;

  @override
  Future<ExamResult> getResult(String attemptId) async {
    final dto = await _remote.getResult(attemptId);
    return dto.toEntity();
  }
}
