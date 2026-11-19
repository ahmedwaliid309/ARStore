// ══════════════════════════════════════════════════════════
//  الشاشة    : Splash (شاشة البداية)
//  المسؤول   : أحمد وليد
//  الـ Branch  : feature/splash
//  الملف     : lib/features/splash/splash_screen.dart
// ══════════════════════════════════════════════════════════
//  المطلوب:
//    - شعار Decora بحركة بسيطة (Fade أو Scale)
//    - بعد ثانيتين: أول مرة ← Onboarding، وبعد كده ← Home (قراءة القيمة من shared_preferences لاحقاً)
//    - حالياً: انتقال مباشر لـ Onboarding
//
//  قواعد: شغلك جوه فولدر الشاشة بس. ممنوع تعدّل في core/ أو main.dart أو
//  pubspec.yaml (وليد بس). الألوان من AppColors، والأحجام بـ .w .h .r .sp،
//  والتنقل من AppRoutes. الطلبات في initState (مش build).
// ══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:decora/core/router/app_router.dart';
import 'package:decora/core/widgets/placeholder_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: 'Splash',
      owner: 'أحمد وليد',
      branch: 'feature/splash',
      tasks: const [
        'شعار Decora بحركة بسيطة (Fade أو Scale)',
        'بعد ثانيتين: أول مرة ← Onboarding، وبعد كده ← Home (قراءة القيمة من shared_preferences لاحقاً)',
        'حالياً: انتقال مباشر لـ Onboarding',
      ],
      actions: [
        ElevatedButton(
          onPressed: () => context.go(AppRoutes.onboarding),
          child: const Text('الانتقال لـ Onboarding'),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
