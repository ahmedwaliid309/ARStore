// ══════════════════════════════════════════════════════════
//  الشاشة    : Onboarding (شاشات التعريف)
//  المسؤول   : أحمد وليد
//  الـ Branch  : feature/onboarding
//  الملف     : lib/features/onboarding/onboarding_screen.dart
// ══════════════════════════════════════════════════════════
//  المطلوب:
//    - 3 صفحات PageView مع مؤشر نقاط
//    - زر تخطي وزر ابدأ ← Auth
//    - حفظ إن الـ Onboarding خلص (shared_preferences)
//
//  قواعد: شغلك جوه فولدر الشاشة بس. ممنوع تعدّل في core/ أو main.dart أو
//  pubspec.yaml (وليد بس). الألوان من AppColors، والأحجام بـ .w .h .r .sp،
//  والتنقل من AppRoutes. الطلبات في initState (مش build).
// ══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:decora/core/router/app_router.dart';
import 'package:decora/core/widgets/placeholder_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: 'Onboarding',
      owner: 'أحمد وليد',
      branch: 'feature/onboarding',
      tasks: const [
        '3 صفحات PageView مع مؤشر نقاط',
        'زر تخطي وزر ابدأ ← Auth',
        'حفظ إن الـ Onboarding خلص (shared_preferences)',
      ],
      actions: [
        ElevatedButton(
          onPressed: () => context.go(AppRoutes.auth),
          child: const Text('ابدأ'),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
