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

class ExamDetailPage extends ConsumerWidget {
  const ExamDetailPage({super.key, required this.examId});

  final String examId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final examState = ref.watch(examDetailControllerProvider(examId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Details'),
        leading: const BackButton(),
      ),
      body: examState.when(
        loading: () => const AppLoadingWidget(message: 'Loading exam…'),
        error: (error, _) => AppErrorWidget(message: error.toString()),
        data: (exam) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: context.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.quiz_rounded,
                      size: 56,
                      color: context.colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      exam.title,
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                exam.description,
                style: context.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              _DetailRow(
                icon: Icons.help_outline_rounded,
                label: 'Questions',
                value: '${exam.totalQuestions}',
              ),
              const Divider(height: 24),
              _DetailRow(
                icon: Icons.timer_outlined,
                label: 'Duration',
                value: '${exam.durationMinutes} minutes',
              ),
              const SizedBox(height: 40),
              AppButton(
                label: 'Start Exam',
                icon: Icons.play_arrow_rounded,
                onPressed: () {
                  ref.read(examSessionProvider.notifier).reset();
                  context.go(
                    AppRoutes.examQuestion.replaceAll(':examId', exam.id),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
