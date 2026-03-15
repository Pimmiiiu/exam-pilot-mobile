class TopicRecommendation {
  const TopicRecommendation({
    required this.topic,
    required this.reason,
  });

  final String topic;
  final String reason;
}

class QuestionResult {
  const QuestionResult({
    required this.questionId,
    required this.questionText,
    required this.userChoiceId,
    required this.userChoiceText,
    required this.correctChoiceId,
    required this.correctChoiceText,
    required this.isCorrect,
    this.aiExplanation,
    this.topicRecommendations = const [],
  });

  final String questionId;
  final String questionText;
  final String userChoiceId;
  final String userChoiceText;
  final String correctChoiceId;
  final String correctChoiceText;
  final bool isCorrect;
  final String? aiExplanation;
  final List<TopicRecommendation> topicRecommendations;
}

class ExamResult {
  const ExamResult({
    required this.attemptId,
    required this.examId,
    required this.examTitle,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.score,
    required this.questionResults,
  });

  final String attemptId;
  final String examId;
  final String examTitle;
  final int totalQuestions;
  final int correctAnswers;
  final int incorrectAnswers;

  /// Score as a percentage (0–100).
  final double score;

  final List<QuestionResult> questionResults;
}
