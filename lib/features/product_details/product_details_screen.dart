// ══════════════════════════════════════════════════════════
//  الشاشة    : Product Details (تفاصيل المنتج)
//  المسؤول   : إيمان
//  الـ Branch  : feature/product-details
//  الملف     : lib/features/product_details/product_details_screen.dart
// ══════════════════════════════════════════════════════════
//  المطلوب:
//    - جلب المنتج بـ ProductRepository.byId(productId) في initState، مع تحميل وخطأ
//    - معرض صور (PageView) واسم وسعر ووصف
//    - الأبعاد والألوان المتاحة
//    - زر "شوف في أوضتك (AR)" ← AppRoutes.arPath (الـ AR مؤجل: اعرض رسالة "قريباً")
//    - أضف للسلة (CartProvider.add) وقلب المفضلة (FavoritesProvider.toggle)
//
//  قواعد: شغلك جوه فولدر الشاشة بس. ممنوع تعدّل في core/ أو main.dart أو
//  pubspec.yaml (وليد بس). الألوان من AppColors، والأحجام بـ .w .h .r .sp،
//  والتنقل من AppRoutes. الطلبات في initState (مش build).
// ══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:decora/core/router/app_router.dart';
import 'package:decora/core/widgets/placeholder_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: 'Product Details',
      owner: 'إيمان',
      branch: 'feature/product-details',
      tasks: const [
        'جلب المنتج بـ ProductRepository.byId(productId) في initState، مع تحميل وخطأ',
        'معرض صور (PageView) واسم وسعر ووصف',
        'الأبعاد والألوان المتاحة',
        'زر "شوف في أوضتك (AR)" ← AppRoutes.arPath (الـ AR مؤجل: اعرض رسالة "قريباً")',
        'أضف للسلة (CartProvider.add) وقلب المفضلة (FavoritesProvider.toggle)',
      ],
      actions: [
        ElevatedButton(
          onPressed: () => context.push(AppRoutes.arPath(productId)),
          child: const Text('AR (مؤجل)'),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => context.go(AppRoutes.cart),
          child: const Text('السلة'),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
