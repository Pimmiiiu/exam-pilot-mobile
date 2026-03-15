import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../controllers/auth_session_controller.dart';

/// Handles the initial app bootstrap: loads stored auth state, then
/// navigates to the appropriate screen.
class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authSessionControllerProvider, (_, next) {
      if (next.isLoading) return;
      if (next.valueOrNull != null) {
        context.go(AppRoutes.examList);
      } else {
        context.go(AppRoutes.login);
      }
    });

    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.school_rounded, size: 80, color: Color(0xFF4F46E5)),
            SizedBox(height: 24),
            Text(
              'ExamPilot',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'AI-powered exam practice',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 48),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
