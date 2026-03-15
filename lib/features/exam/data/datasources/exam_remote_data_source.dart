import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/exam_dto.dart';

final examRemoteDataSourceProvider = Provider<ExamRemoteDataSource>((ref) {
  return ExamRemoteDataSource(ref.watch(dioClientProvider));
});

class ExamRemoteDataSource {
  ExamRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<ExamDto>> getExams() async {
    final response = await _dio.get<List<dynamic>>(AppConstants.examsEndpoint);
    return (response.data!)
        .map((e) => ExamDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ExamDto> getExamDetail(String examId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${AppConstants.examsEndpoint}/$examId',
    );
    return ExamDto.fromJson(response.data!);
  }

  Future<String> submitExam(ExamSubmissionDto dto) async {
    final response = await _dio.post<Map<String, dynamic>>(
      AppConstants.submitEndpoint,
      data: dto.toJson(),
    );
    return response.data!['attempt_id'] as String;
  }
}
