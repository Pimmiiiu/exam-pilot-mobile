import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/exam_repository_impl.dart';
import '../../domain/entities/exam.dart';
import '../../domain/usecases/submit_exam_use_case.dart';

/// Tracks selected answers for the current exam session in memory.
final examSessionProvider =
    StateNotifierProvider.autoDispose<ExamSessionNotifier, ExamSessionState>(
  (ref) => ExamSessionNotifier(),
);

class ExamSessionState {
  const ExamSessionState({
    required this.answers,
    required this.currentQuestionIndex,
  });

  factory ExamSessionState.initial() => const ExamSessionState(
        answers: {},
        currentQuestionIndex: 0,
      );

  final Map<String, String> answers; // questionId -> choiceId
  final int currentQuestionIndex;

  ExamSessionState copyWith({
    Map<String, String>? answers,
    int? currentQuestionIndex,
  }) =>
      ExamSessionState(
        answers: answers ?? this.answers,
        currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      );
}

class ExamSessionNotifier extends StateNotifier<ExamSessionState> {
  ExamSessionNotifier() : super(ExamSessionState.initial());

  void selectAnswer(String questionId, String choiceId) {
    state = state.copyWith(
      answers: Map.from(state.answers)..[questionId] = choiceId,
    );
  }

  void goToNextQuestion() {
    state = state.copyWith(
      currentQuestionIndex: state.currentQuestionIndex + 1,
    );
  }

  void goToPreviousQuestion() {
    if (state.currentQuestionIndex > 0) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex - 1,
      );
    }
  }

  void reset() => state = ExamSessionState.initial();
}

/// Handles exam submission.
final examSubmissionControllerProvider =
    AsyncNotifierProvider.autoDispose<ExamSubmissionController, String?>(
  ExamSubmissionController.new,
);

class ExamSubmissionController extends AutoDisposeAsyncNotifier<String?> {
  @override
  Future<String?> build() async => null;

  Future<String?> submit({
    required String examId,
    required Map<String, String> answers,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final useCase = SubmitExamUseCase(ref.watch(examRepositoryProvider));
      final submission = ExamSubmission(
        examId: examId,
        answers: answers.entries
            .map((e) => UserAnswer(questionId: e.key, choiceId: e.value))
            .toList(),
      );
      return useCase.call(submission);
    });
    return state.valueOrNull;
  }
}
