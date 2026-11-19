// ══════════════════════════════════════════════════════════
//  الشاشة    : Favorites (المفضلة)
//  المسؤول   : أحمد عطا
//  الـ Branch  : feature/favorites
//  الملف     : lib/features/favorites/favorites_screen.dart
// ══════════════════════════════════════════════════════════
//  المطلوب:
//    - شبكة من FavoritesProvider.items بـ ProductCard
//    - حالة فاضية بزر "تصفح المنتجات" ← Home
//    - حفظ محلي في FavoritesProvider (shared_preferences)
//
//  قواعد: شغلك جوه فولدر الشاشة بس. ممنوع تعدّل في core/ أو main.dart أو
//  pubspec.yaml (وليد بس). الألوان من AppColors، والأحجام بـ .w .h .r .sp،
//  والتنقل من AppRoutes. الطلبات في initState (مش build).
// ══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:decora/core/router/app_router.dart';
import 'package:decora/core/widgets/placeholder_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: 'Favorites',
      owner: 'أحمد عطا',
      branch: 'feature/favorites',
      tasks: const [
        'شبكة من FavoritesProvider.items بـ ProductCard',
        'حالة فاضية بزر "تصفح المنتجات" ← Home',
        'حفظ محلي في FavoritesProvider (shared_preferences)',
      ],
      actions: [
        ElevatedButton(
          onPressed: () => context.go(AppRoutes.home),
          child: const Text('تصفح المنتجات'),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
