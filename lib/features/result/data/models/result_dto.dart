import '../../domain/entities/exam_result.dart';

class TopicRecommendationDto {
  const TopicRecommendationDto({required this.topic, required this.reason});

  factory TopicRecommendationDto.fromJson(Map<String, dynamic> json) =>
      TopicRecommendationDto(
        topic: json['topic'] as String,
        reason: json['reason'] as String,
      );

  final String topic;
  final String reason;

  TopicRecommendation toEntity() =>
      TopicRecommendation(topic: topic, reason: reason);
}

class QuestionResultDto {
  const QuestionResultDto({
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

  factory QuestionResultDto.fromJson(Map<String, dynamic> json) =>
      QuestionResultDto(
        questionId: json['question_id'] as String,
        questionText: json['question_text'] as String,
        userChoiceId: json['user_choice_id'] as String,
        userChoiceText: json['user_choice_text'] as String,
        correctChoiceId: json['correct_choice_id'] as String,
        correctChoiceText: json['correct_choice_text'] as String,
        isCorrect: json['is_correct'] as bool,
        aiExplanation: json['ai_explanation'] as String?,
        topicRecommendations: json['topic_recommendations'] != null
            ? (json['topic_recommendations'] as List<dynamic>)
                .map((e) => TopicRecommendationDto.fromJson(
                    e as Map<String, dynamic>))
                .toList()
            : [],
      );

  final String questionId;
  final String questionText;
  final String userChoiceId;
  final String userChoiceText;
  final String correctChoiceId;
  final String correctChoiceText;
  final bool isCorrect;
  final String? aiExplanation;
  final List<TopicRecommendationDto> topicRecommendations;

  QuestionResult toEntity() => QuestionResult(
        questionId: questionId,
        questionText: questionText,
        userChoiceId: userChoiceId,
        userChoiceText: userChoiceText,
        correctChoiceId: correctChoiceId,
        correctChoiceText: correctChoiceText,
        isCorrect: isCorrect,
        aiExplanation: aiExplanation,
        topicRecommendations:
            topicRecommendations.map((t) => t.toEntity()).toList(),
      );
}

class ExamResultDto {
  const ExamResultDto({
    required this.attemptId,
    required this.examId,
    required this.examTitle,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.score,
    required this.questionResults,
  });

  factory ExamResultDto.fromJson(Map<String, dynamic> json) => ExamResultDto(
        attemptId: json['attempt_id'] as String,
        examId: json['exam_id'] as String,
        examTitle: json['exam_title'] as String,
        totalQuestions: json['total_questions'] as int,
        correctAnswers: json['correct_answers'] as int,
        incorrectAnswers: json['incorrect_answers'] as int,
        score: (json['score'] as num).toDouble(),
        questionResults: (json['question_results'] as List<dynamic>)
            .map((e) =>
                QuestionResultDto.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  final String attemptId;
  final String examId;
  final String examTitle;
  final int totalQuestions;
  final int correctAnswers;
  final int incorrectAnswers;
  final double score;
  final List<QuestionResultDto> questionResults;

  ExamResult toEntity() => ExamResult(
        attemptId: attemptId,
        examId: examId,
        examTitle: examTitle,
        totalQuestions: totalQuestions,
        correctAnswers: correctAnswers,
        incorrectAnswers: incorrectAnswers,
        score: score,
        questionResults: questionResults.map((q) => q.toEntity()).toList(),
      );
}
