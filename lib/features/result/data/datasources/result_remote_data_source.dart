import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/result_dto.dart';

final resultRemoteDataSourceProvider = Provider<ResultRemoteDataSource>((ref) {
  return ResultRemoteDataSource(ref.watch(dioClientProvider));
});

class ResultRemoteDataSource {
  ResultRemoteDataSource(this._dio);

  final Dio _dio;

  Future<ExamResultDto> getResult(String attemptId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${AppConstants.resultsEndpoint}/$attemptId',
    );
    return ExamResultDto.fromJson(response.data!);
  }
}
