import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/app_loading_widget.dart';
import '../controllers/exam_detail_controller.dart';
import '../controllers/exam_session_controller.dart';

class ExamQuestionPage extends ConsumerWidget {
  const ExamQuestionPage({super.key, required this.examId});

  final String examId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final examState = ref.watch(examDetailControllerProvider(examId));
    final session = ref.watch(examSessionProvider);
    final submissionState = ref.watch(examSubmissionControllerProvider);

    ref.listen(examSubmissionControllerProvider, (_, next) {
      if (next.hasError) {
        context.showSnackBar(next.error.toString(), isError: true);
      }
      if (next.hasValue && next.value != null) {
        context.go(
          AppRoutes.result.replaceAll(':attemptId', next.value!),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: examState.maybeWhen(
          data: (exam) => Text(exam.title),
          orElse: () => const Text('Question'),
        ),
        leading: const BackButton(),
      ),
      body: examState.when(
        loading: () => const AppLoadingWidget(message: 'Loading questions…'),
        error: (error, _) => AppErrorWidget(message: error.toString()),
        data: (exam) {
          if (exam.questions.isEmpty) {
            return const Center(child: Text('No questions found.'));
          }

          final questions = exam.questions;
          final currentIndex = session.currentQuestionIndex;
          final isLast = currentIndex == questions.length - 1;
          final question = questions[currentIndex];
          final selectedChoiceId = session.answers[question.id];

          return Column(
            children: [
              // Progress indicator
              LinearProgressIndicator(
                value: (currentIndex + 1) / questions.length,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Question counter
                      Text(
                        'Question ${currentIndex + 1} of ${questions.length}',
                        style: context.textTheme.labelLarge?.copyWith(
                          color: context.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Question text
                      Text(
                        question.text,
                        style: context.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 32),
                      // Answer choices
                      ...question.choices.map((choice) {
                        final isSelected = selectedChoiceId == choice.id;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _ChoiceTile(
                            text: choice.text,
                            isSelected: isSelected,
                            onTap: () {
                              ref
                                  .read(examSessionProvider.notifier)
                                  .selectAnswer(question.id, choice.id);
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              // Navigation buttons
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    if (currentIndex > 0)
                      Expanded(
                        child: AppButton(
                          label: 'Previous',
                          variant: AppButtonVariant.secondary,
                          icon: Icons.arrow_back_rounded,
                          onPressed: () => ref
                              .read(examSessionProvider.notifier)
                              .goToPreviousQuestion(),
                        ),
                      ),
                    if (currentIndex > 0) const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        label: isLast ? 'Submit' : 'Next',
                        icon: isLast
                            ? Icons.check_circle_outline_rounded
                            : Icons.arrow_forward_rounded,
                        isLoading: submissionState.isLoading,
                        onPressed: selectedChoiceId == null
                            ? null
                            : () async {
                                if (isLast) {
                                  await ref
                                      .read(examSubmissionControllerProvider
                                          .notifier)
                                      .submit(
                                        examId: examId,
                                        answers: session.answers,
                                      );
                                } else {
                                  ref
                                      .read(examSessionProvider.notifier)
                                      .goToNextQuestion();
                                }
                              },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surface,
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected ? colorScheme.primary : Colors.grey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
