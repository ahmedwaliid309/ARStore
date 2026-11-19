// ══════════════════════════════════════════════════════════
//  الشاشة    : Login / Register (تسجيل الدخول)
//  المسؤول   : سارة
//  الـ Branch  : feature/auth
//  الملف     : lib/features/auth/auth_screen.dart
// ══════════════════════════════════════════════════════════
//  المطلوب:
//    - تبويبين: تسجيل دخول وحساب جديد
//    - فورم مع تحقق (إيميل وباسورد)
//    - AuthProvider.signIn و register (وهمي دلوقتي، Firebase لاحقاً)
//    - نجاح ← Home، مع حالة تحميل ورسالة خطأ
//
//  قواعد: شغلك جوه فولدر الشاشة بس. ممنوع تعدّل في core/ أو main.dart أو
//  pubspec.yaml (وليد بس). الألوان من AppColors، والأحجام بـ .w .h .r .sp،
//  والتنقل من AppRoutes. الطلبات في initState (مش build).
// ══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:decora/core/router/app_router.dart';
import 'package:decora/core/widgets/placeholder_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: 'Login / Register',
      owner: 'سارة',
      branch: 'feature/auth',
      tasks: const [
        'تبويبين: تسجيل دخول وحساب جديد',
        'فورم مع تحقق (إيميل وباسورد)',
        'AuthProvider.signIn و register (وهمي دلوقتي، Firebase لاحقاً)',
        'نجاح ← Home، مع حالة تحميل ورسالة خطأ',
      ],
      actions: [
        ElevatedButton(
          onPressed: () => context.go(AppRoutes.home),
          child: const Text('دخول (تجريبي)'),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
