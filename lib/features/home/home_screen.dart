// ══════════════════════════════════════════════════════════
//  الشاشة    : Home (الرئيسية)
//  المسؤول   : معاذ منصور
//  الـ Branch  : feature/home
//  الملف     : lib/features/home/home_screen.dart
// ══════════════════════════════════════════════════════════
//  المطلوب:
//    - بانر عروض أعلى الشاشة
//    - شريط التصنيفات من ProductRepository.categories: الضغط ← Products بالتصنيف
//    - منتجات مميزة بـ ProductCard (core/widgets/product_card.dart)
//    - الضغط على منتج ← تفاصيل
//    - حالات تحميل وخطأ ولا نتايج (الطلب في initState مش build)
//
//  قواعد: شغلك جوه فولدر الشاشة بس. ممنوع تعدّل في core/ أو main.dart أو
//  pubspec.yaml (وليد بس). الألوان من AppColors، والأحجام بـ .w .h .r .sp،
//  والتنقل من AppRoutes. الطلبات في initState (مش build).
// ══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:decora/core/router/app_router.dart';
import 'package:decora/core/widgets/placeholder_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: 'Home',
      owner: 'معاذ منصور',
      branch: 'feature/home',
      tasks: const [
        'بانر عروض أعلى الشاشة',
        'شريط التصنيفات من ProductRepository.categories: الضغط ← Products بالتصنيف',
        'منتجات مميزة بـ ProductCard (core/widgets/product_card.dart)',
        'الضغط على منتج ← تفاصيل',
        'حالات تحميل وخطأ ولا نتايج (الطلب في initState مش build)',
      ],
      actions: [
        ElevatedButton(
          onPressed: () => context.push(AppRoutes.products),
          child: const Text('كل المنتجات'),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => context.push(AppRoutes.productPath('1')),
          child: const Text('تفاصيل منتج'),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
