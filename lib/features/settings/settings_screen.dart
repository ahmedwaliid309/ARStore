// ══════════════════════════════════════════════════════════
//  الشاشة    : Settings (الإعدادات)
//  المسؤول   : إيمان
//  الـ Branch  : feature/settings
//  الملف     : lib/features/settings/settings_screen.dart
// ══════════════════════════════════════════════════════════
//  المطلوب:
//    - اللغة والوضع الليلي (حسب Figma)
//    - عن التطبيق والإصدار
//    - تسجيل الخروج ← AuthProvider.signOut ثم Auth
//    - ضبط شكل Bottom Nav على Figma بالاتفاق مع وليد (main_shell.dart)
//
//  قواعد: شغلك جوه فولدر الشاشة بس. ممنوع تعدّل في core/ أو main.dart أو
//  pubspec.yaml (وليد بس). الألوان من AppColors، والأحجام بـ .w .h .r .sp،
//  والتنقل من AppRoutes. الطلبات في initState (مش build).
// ══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:decora/core/router/app_router.dart';
import 'package:decora/core/widgets/placeholder_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: 'Settings',
      owner: 'إيمان',
      branch: 'feature/settings',
      tasks: const [
        'اللغة والوضع الليلي (حسب Figma)',
        'عن التطبيق والإصدار',
        'تسجيل الخروج ← AuthProvider.signOut ثم Auth',
        'ضبط شكل Bottom Nav على Figma بالاتفاق مع وليد (main_shell.dart)',
      ],
      actions: [
        ElevatedButton(
          onPressed: () => context.go(AppRoutes.auth),
          child: const Text('تسجيل خروج (تجريبي)'),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
