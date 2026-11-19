// ══════════════════════════════════════════════════════════
//  الشاشة    : Products (قايمة المنتجات)
//  المسؤول   : أحمد عطا
//  الـ Branch  : feature/products
//  الملف     : lib/features/products/products_screen.dart
// ══════════════════════════════════════════════════════════
//  المطلوب:
//    - شبكة منتجات بـ ProductCard من ProductRepository (category لو جاي من Home)
//    - شريط بحث مع Debounce
//    - فلترة بالسعر والتصنيف (Bottom Sheet) وترتيب
//    - تطوير ProductCard نفسه وضبطه على Figma (إنت مسؤول عنه)
//    - الضغط على منتج ← تفاصيل، والقلب ← FavoritesProvider.toggle
//
//  قواعد: شغلك جوه فولدر الشاشة بس. ممنوع تعدّل في core/ أو main.dart أو
//  pubspec.yaml (وليد بس). الألوان من AppColors، والأحجام بـ .w .h .r .sp،
//  والتنقل من AppRoutes. الطلبات في initState (مش build).
// ══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:decora/core/router/app_router.dart';
import 'package:decora/core/widgets/placeholder_screen.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key, this.category});

  final String? category;

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: 'Products',
      owner: 'أحمد عطا',
      branch: 'feature/products',
      tasks: const [
        'شبكة منتجات بـ ProductCard من ProductRepository (category لو جاي من Home)',
        'شريط بحث مع Debounce',
        'فلترة بالسعر والتصنيف (Bottom Sheet) وترتيب',
        'تطوير ProductCard نفسه وضبطه على Figma (إنت مسؤول عنه)',
        'الضغط على منتج ← تفاصيل، والقلب ← FavoritesProvider.toggle',
      ],
      actions: [
        ElevatedButton(
          onPressed: () => context.push(AppRoutes.productPath('1')),
          child: const Text('تفاصيل منتج'),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
