class ExamChoice {
  const ExamChoice({
    required this.id,
    required this.text,
  });

  final String id;
  final String text;
}

class ExamQuestion {
  const ExamQuestion({
    required this.id,
    required this.text,
    required this.choices,
  });

  final String id;
  final String text;
  final List<ExamChoice> choices;
}

class Exam {
  const Exam({
    required this.id,
    required this.title,
    required this.description,
    required this.totalQuestions,
    required this.durationMinutes,
    this.questions = const [],
  });

  final String id;
  final String title;
  final String description;
  final int totalQuestions;
  final int durationMinutes;
  final List<ExamQuestion> questions;
}

class UserAnswer {
  const UserAnswer({
    required this.questionId,
    required this.choiceId,
  });

  final String questionId;
  final String choiceId;
}

class ExamSubmission {
  const ExamSubmission({
    required this.examId,
    required this.answers,
  });

  final String examId;
  final List<UserAnswer> answers;
}
