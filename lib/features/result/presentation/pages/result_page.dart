import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/app_loading_widget.dart';
import '../../domain/entities/exam_result.dart';
import '../controllers/result_controller.dart';

class ResultPage extends ConsumerWidget {
  const ResultPage({super.key, required this.attemptId});

  final String attemptId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultState = ref.watch(resultControllerProvider(attemptId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        automaticallyImplyLeading: false,
      ),
      body: resultState.when(
        loading: () => const AppLoadingWidget(message: 'Loading results…'),
        error: (error, _) => AppErrorWidget(message: error.toString()),
        data: (result) => _ResultContent(result: result),
      ),
    );
  }
}

class _ResultContent extends StatelessWidget {
  const _ResultContent({required this.result});

  final ExamResult result;

  @override
  Widget build(BuildContext context) {
    final scoreColor = result.score >= 70
        ? Colors.green
        : result.score >= 50
            ? Colors.orange
            : Colors.red;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Score card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    result.examTitle,
                    style: context.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          value: result.score / 100,
                          strokeWidth: 10,
                          backgroundColor: Colors.grey.shade200,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(scoreColor),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '${result.score.toStringAsFixed(0)}%',
                            style: context.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: scoreColor,
                            ),
                          ),
                          const Text('Score'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _ScoreStat(
                        label: 'Correct',
                        value: '${result.correctAnswers}',
                        color: Colors.green,
                        icon: Icons.check_circle_outline_rounded,
                      ),
                      _ScoreStat(
                        label: 'Incorrect',
                        value: '${result.incorrectAnswers}',
                        color: Colors.red,
                        icon: Icons.cancel_outlined,
                      ),
                      _ScoreStat(
                        label: 'Total',
                        value: '${result.totalQuestions}',
                        color: Colors.blue,
                        icon: Icons.quiz_outlined,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'Question Review',
            style: context.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          ...result.questionResults.asMap().entries.map((entry) {
            final index = entry.key;
            final qResult = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _QuestionResultCard(
                index: index + 1,
                questionResult: qResult,
              ),
            );
          }),

          const SizedBox(height: 24),
          AppButton(
            label: 'Back to Exams',
            icon: Icons.home_rounded,
            onPressed: () => context.go(AppRoutes.examList),
          ),
        ],
      ),
    );
  }
}

class _ScoreStat extends StatelessWidget {
  const _ScoreStat({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _QuestionResultCard extends StatefulWidget {
  const _QuestionResultCard({
    required this.index,
    required this.questionResult,
  });

  final int index;
  final QuestionResult questionResult;

  @override
  State<_QuestionResultCard> createState() => _QuestionResultCardState();
}

class _QuestionResultCardState extends State<_QuestionResultCard> {
  @override
  Widget build(BuildContext context) {
    final qr = widget.questionResult;
    final isCorrect = qr.isCorrect;
    final statusColor = isCorrect ? Colors.green : Colors.red;
    final statusIcon = isCorrect
        ? Icons.check_circle_rounded
        : Icons.cancel_rounded;

    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: CircleAvatar(
            backgroundColor: statusColor.withOpacity(0.15),
            child: Icon(statusIcon, color: statusColor, size: 20),
          ),
          title: Text(
            'Q${widget.index}: ${qr.questionText}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AnswerRow(
                    label: 'Your answer',
                    text: qr.userChoiceText,
                    color: isCorrect ? Colors.green : Colors.red,
                    icon: isCorrect
                        ? Icons.check_rounded
                        : Icons.close_rounded,
                  ),
                  if (!isCorrect) ...[
                    const SizedBox(height: 8),
                    _AnswerRow(
                      label: 'Correct answer',
                      text: qr.correctChoiceText,
                      color: Colors.green,
                      icon: Icons.check_rounded,
                    ),
                  ],
                  if (qr.aiExplanation != null && !isCorrect) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.auto_awesome_rounded,
                                  size: 16, color: Colors.blue),
                              const SizedBox(width: 6),
                              Text(
                                'AI Explanation',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(color: Colors.blue),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            qr.aiExplanation!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (qr.topicRecommendations.isNotEmpty && !isCorrect) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Recommended topics',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: qr.topicRecommendations
                          .map((t) => Chip(label: Text(t.topic)))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnswerRow extends StatelessWidget {
  const _AnswerRow({
    required this.label,
    required this.text,
    required this.color,
    required this.icon,
  });

  final String label;
  final String text;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: text),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
