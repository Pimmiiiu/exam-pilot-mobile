# ExamPilot Mobile

AI-powered online exam practice platform built with **Flutter**, using Clean Architecture, Riverpod, Dio, and GoRouter.

---

## Features

- 🔐 **Authentication** – Login & Register with JWT token storage (Flutter Secure Storage)
- 📋 **Exam List** – Browse available practice exams
- ❓ **Question Answering** – Multiple-choice questions with real-time answer tracking
- ✅ **Exam Submission** – Submit answers to a REST backend
- 📊 **Results** – View score, correct/incorrect breakdown, AI explanations, and topic recommendations

---

## Tech Stack

| Concern         | Library                        |
|-----------------|-------------------------------|
| UI              | Flutter + Material 3          |
| State           | Riverpod (`flutter_riverpod`) |
| Navigation      | GoRouter                       |
| Networking      | Dio                            |
| Token storage   | Flutter Secure Storage         |
| Models          | Freezed / json_serializable (ready to add) |

---

## Project Structure

```
lib/
├── app/          # App entry, router, top-level providers
├── core/         # Constants, errors, extensions, network, storage, theme
├── shared/       # Reusable widgets
└── features/
    ├── auth/     # Login, register, auth session
    ├── exam/     # Exam list, detail, question page, submission
    └── result/   # Result display with AI explanations
```

---

## Getting Started

### Prerequisites

- Flutter ≥ 3.16 (Dart ≥ 3.2)
- A running backend (see **API Endpoints** below)

### Setup

```bash
# 1. Clone the repo
git clone https://github.com/Pimmiiiu/exam-pilot-mobile.git
cd exam-pilot-mobile

# 2. Install dependencies
flutter pub get

# 3. (Optional) Run code generation if you add Freezed models
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Set the backend URL
#    Edit lib/core/constants/app_constants.dart → AppConstants.baseUrl

# 5. Run the app
flutter run
```

---

## API Endpoints (assumed backend)

| Method | Path                  | Description          |
|--------|-----------------------|----------------------|
| POST   | `/auth/register`      | Create account       |
| POST   | `/auth/login`         | Authenticate         |
| GET    | `/exams`              | List exams           |
| GET    | `/exams/{id}`         | Exam detail + questions |
| POST   | `/exams/submit`       | Submit answers       |
| GET    | `/results/{attemptId}`| Fetch result         |

### Auth response shape

```json
{ "access_token": "...", "refresh_token": "..." }
```

### Exam list response shape

```json
[
  {
    "id": "exam-1",
    "title": "Python Basics",
    "description": "Test your Python fundamentals",
    "total_questions": 10,
    "duration_minutes": 20
  }
]
```

### Submit request shape

```json
{
  "exam_id": "exam-1",
  "answers": [
    { "question_id": "q1", "choice_id": "c2" }
  ]
}
```

### Result response shape

```json
{
  "attempt_id": "attempt-123",
  "exam_id": "exam-1",
  "exam_title": "Python Basics",
  "total_questions": 10,
  "correct_answers": 7,
  "incorrect_answers": 3,
  "score": 70.0,
  "question_results": [
    {
      "question_id": "q1",
      "question_text": "What is a list comprehension?",
      "user_choice_id": "c1",
      "user_choice_text": "A type of loop",
      "correct_choice_id": "c2",
      "correct_choice_text": "A concise way to create lists",
      "is_correct": false,
      "ai_explanation": "List comprehensions provide a concise syntax...",
      "topic_recommendations": [
        { "topic": "Python Comprehensions", "reason": "Review the syntax" }
      ]
    }
  ]
}
```

---

## Architecture

This project follows **Clean Architecture** with a feature-based modular structure:

```
feature/
├── data/
│   ├── datasources/   # Remote API calls (Dio)
│   ├── models/        # DTOs with JSON serialization
│   └── repositories/  # Repository implementations
├── domain/
│   ├── entities/      # Pure domain models
│   ├── repositories/  # Abstract repository interfaces
│   └── usecases/      # Business logic use cases
└── presentation/
    ├── controllers/   # Riverpod AsyncNotifiers / StateNotifiers
    ├── pages/         # Full-screen pages
    └── widgets/       # Feature-specific widgets
```

---

## License

MIT
