import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/domain/entities/auth_tokens.dart';
import '../features/auth/presentation/controllers/auth_session_controller.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/exam/presentation/pages/exam_detail_page.dart';
import '../features/exam/presentation/pages/exam_list_page.dart';
import '../features/exam/presentation/pages/exam_question_page.dart';
import '../features/result/presentation/pages/result_page.dart';

// Route paths
class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const examList = '/exams';
  static const examDetail = '/exams/:examId';
  static const examQuestion = '/exams/:examId/question';
  static const result = '/results/:attemptId';
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authSessionControllerProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull is AuthTokens;
      final isLoading = authState.isLoading;
      final location = state.matchedLocation;

      // Let splash handle its own redirect
      if (location == AppRoutes.splash) return null;

      // Still loading auth state – stay on splash
      if (isLoading) return AppRoutes.splash;

      final isOnAuthPage =
          location == AppRoutes.login || location == AppRoutes.register;

      if (!isLoggedIn && !isOnAuthPage) return AppRoutes.login;
      if (isLoggedIn && isOnAuthPage) return AppRoutes.examList;

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.examList,
        builder: (context, state) => const ExamListPage(),
      ),
      GoRoute(
        path: AppRoutes.examDetail,
        builder: (context, state) {
          final examId = state.pathParameters['examId']!;
          return ExamDetailPage(examId: examId);
        },
      ),
      GoRoute(
        path: AppRoutes.examQuestion,
        builder: (context, state) {
          final examId = state.pathParameters['examId']!;
          return ExamQuestionPage(examId: examId);
        },
      ),
      GoRoute(
        path: AppRoutes.result,
        builder: (context, state) {
          final attemptId = state.pathParameters['attemptId']!;
          return ResultPage(attemptId: attemptId);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );
});
