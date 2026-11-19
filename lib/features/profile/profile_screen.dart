// ══════════════════════════════════════════════════════════
//  الشاشة    : Profile (حسابي)
//  المسؤول   : سارة
//  الـ Branch  : feature/profile
//  الملف     : lib/features/profile/profile_screen.dart
// ══════════════════════════════════════════════════════════
//  المطلوب:
//    - اسم المستخدم والإيميل من AuthProvider
//    - روابط: طلباتي ← Orders، الإعدادات ← Settings
//    - تسجيل الخروج، ولو مش مسجل: زر دخول ← Auth
//
//  قواعد: شغلك جوه فولدر الشاشة بس. ممنوع تعدّل في core/ أو main.dart أو
//  pubspec.yaml (وليد بس). الألوان من AppColors، والأحجام بـ .w .h .r .sp،
//  والتنقل من AppRoutes. الطلبات في initState (مش build).
// ══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:decora/core/router/app_router.dart';
import 'package:decora/core/widgets/placeholder_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: 'Profile',
      owner: 'سارة',
      branch: 'feature/profile',
      tasks: const [
        'اسم المستخدم والإيميل من AuthProvider',
        'روابط: طلباتي ← Orders، الإعدادات ← Settings',
        'تسجيل الخروج، ولو مش مسجل: زر دخول ← Auth',
      ],
      actions: [
        ElevatedButton(
          onPressed: () => context.push(AppRoutes.orders),
          child: const Text('طلباتي'),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => context.push(AppRoutes.settings),
          child: const Text('الإعدادات'),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => context.go(AppRoutes.auth),
          child: const Text('تسجيل الدخول'),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
