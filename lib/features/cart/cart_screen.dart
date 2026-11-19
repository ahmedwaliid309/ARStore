// ══════════════════════════════════════════════════════════
//  الشاشة    : Cart (السلة)
//  المسؤول   : السيد أسامة
//  الـ Branch  : feature/cart
//  الملف     : lib/features/cart/cart_screen.dart
// ══════════════════════════════════════════════════════════
//  المطلوب:
//    - عناصر السلة من CartProvider.items (صورة واسم وسعر وكمية + و -)
//    - حذف عنصر، وإجمالي السعر (total)
//    - حالة سلة فاضية
//    - زر "إتمام الشراء" ← Checkout
//
//  قواعد: شغلك جوه فولدر الشاشة بس. ممنوع تعدّل في core/ أو main.dart أو
//  pubspec.yaml (وليد بس). الألوان من AppColors، والأحجام بـ .w .h .r .sp،
//  والتنقل من AppRoutes. الطلبات في initState (مش build).
// ══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:decora/core/router/app_router.dart';
import 'package:decora/core/widgets/placeholder_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: 'Cart',
      owner: 'السيد أسامة',
      branch: 'feature/cart',
      tasks: const [
        'عناصر السلة من CartProvider.items (صورة واسم وسعر وكمية + و -)',
        'حذف عنصر، وإجمالي السعر (total)',
        'حالة سلة فاضية',
        'زر "إتمام الشراء" ← Checkout',
      ],
      actions: [
        ElevatedButton(
          onPressed: () => context.push(AppRoutes.checkout),
          child: const Text('إتمام الشراء'),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
