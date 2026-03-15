import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/app_loading_widget.dart';
import '../../../auth/presentation/controllers/auth_session_controller.dart';
import '../controllers/exam_list_controller.dart';

class ExamListPage extends ConsumerWidget {
  const ExamListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final examsState = ref.watch(examListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Exams'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: () async {
              await ref.read(authSessionControllerProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: examsState.when(
        loading: () => const AppLoadingWidget(message: 'Loading exams…'),
        error: (error, _) => AppErrorWidget(
          message: error.toString(),
          onRetry: () =>
              ref.read(examListControllerProvider.notifier).refresh(),
        ),
        data: (exams) {
          if (exams.isEmpty) {
            return const Center(
              child: Text('No exams available.'),
            );
          }
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(examListControllerProvider.notifier).refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: exams.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final exam = exams[index];
                return Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      context.go(
                        AppRoutes.examDetail.replaceAll(':examId', exam.id),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: context.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.quiz_rounded,
                                  color:
                                      context.colorScheme.onPrimaryContainer,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  exam.title,
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            exam.description,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _InfoChip(
                                icon: Icons.help_outline_rounded,
                                label: '${exam.totalQuestions} questions',
                              ),
                              const SizedBox(width: 8),
                              _InfoChip(
                                icon: Icons.timer_outlined,
                                label: '${exam.durationMinutes} min',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
