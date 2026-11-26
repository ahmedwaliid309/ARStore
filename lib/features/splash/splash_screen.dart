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
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';
import 'package:decora/core/router/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:decora/core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _goNext() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingDone = prefs.getBool('onboardingCompleted') ?? false;
    final user = await FirebaseAuth.instance.authStateChanges().first;
    if (!mounted) return;

    if (!onboardingDone) {
      context.go(AppRoutes.onboarding);
    } else if (user == null) {
      context.go(AppRoutes.auth);
    } else {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SizedBox.expand(
        child: Lottie.asset(
          'assets/lottie/Decora_Splash.json',
          controller: _controller,
          fit: BoxFit.cover,
          frameRate: FrameRate.max,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration
              ..forward().whenComplete(() async {
                await Future.delayed(
                  const Duration(milliseconds: 400),
                );

                if (mounted) {
                  _goNext();
                }
              });
          },
        ),
      ),
    );
  }
}
