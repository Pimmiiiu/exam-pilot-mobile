import '../../domain/entities/exam.dart';

class ExamChoiceDto {
  const ExamChoiceDto({required this.id, required this.text});

  factory ExamChoiceDto.fromJson(Map<String, dynamic> json) => ExamChoiceDto(
        id: json['id'] as String,
        text: json['text'] as String,
      );

  final String id;
  final String text;

  ExamChoice toEntity() => ExamChoice(id: id, text: text);
}

class ExamQuestionDto {
  const ExamQuestionDto({
    required this.id,
    required this.text,
    required this.choices,
  });

  factory ExamQuestionDto.fromJson(Map<String, dynamic> json) =>
      ExamQuestionDto(
        id: json['id'] as String,
        text: json['text'] as String,
        choices: (json['choices'] as List<dynamic>)
            .map((e) => ExamChoiceDto.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  final String id;
  final String text;
  final List<ExamChoiceDto> choices;

  ExamQuestion toEntity() => ExamQuestion(
        id: id,
        text: text,
        choices: choices.map((c) => c.toEntity()).toList(),
      );
}

class ExamDto {
  const ExamDto({
    required this.id,
    required this.title,
    required this.description,
    required this.totalQuestions,
    required this.durationMinutes,
    this.questions = const [],
  });

  factory ExamDto.fromJson(Map<String, dynamic> json) => ExamDto(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        totalQuestions: json['total_questions'] as int,
        durationMinutes: json['duration_minutes'] as int,
        questions: json['questions'] != null
            ? (json['questions'] as List<dynamic>)
                .map((e) => ExamQuestionDto.fromJson(e as Map<String, dynamic>))
                .toList()
            : [],
      );

  final String id;
  final String title;
  final String description;
  final int totalQuestions;
  final int durationMinutes;
  final List<ExamQuestionDto> questions;

  Exam toEntity() => Exam(
        id: id,
        title: title,
        description: description,
        totalQuestions: totalQuestions,
        durationMinutes: durationMinutes,
        questions: questions.map((q) => q.toEntity()).toList(),
      );
}

class UserAnswerDto {
  const UserAnswerDto({
    required this.questionId,
    required this.choiceId,
  });

  Map<String, dynamic> toJson() => {
        'question_id': questionId,
        'choice_id': choiceId,
      };

  final String questionId;
  final String choiceId;
}

class ExamSubmissionDto {
  const ExamSubmissionDto({
    required this.examId,
    required this.answers,
  });

  Map<String, dynamic> toJson() => {
        'exam_id': examId,
        'answers': answers.map((a) => a.toJson()).toList(),
      };

  final String examId;
  final List<UserAnswerDto> answers;
}
