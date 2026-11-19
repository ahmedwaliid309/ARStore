// ══════════════════════════════════════════════════════════
//  الشاشة    : Order Confirmation (تأكيد الطلب)
//  المسؤول   : معاذ منصور
//  الـ Branch  : feature/order-confirmation
//  الملف     : lib/features/order_confirmation/order_confirmation_screen.dart
// ══════════════════════════════════════════════════════════
//  المطلوب:
//    - رسالة نجاح بحركة بسيطة
//    - رقم الطلب (orderId)
//    - زر "طلباتي" ← Orders، وزر "الرئيسية" ← Home
//
//  قواعد: شغلك جوه فولدر الشاشة بس. ممنوع تعدّل في core/ أو main.dart أو
//  pubspec.yaml (وليد بس). الألوان من AppColors، والأحجام بـ .w .h .r .sp،
//  والتنقل من AppRoutes. الطلبات في initState (مش build).
// ══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:decora/core/router/app_router.dart';
import 'package:decora/core/widgets/placeholder_screen.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: 'Order Confirmation',
      owner: 'معاذ منصور',
      branch: 'feature/order-confirmation',
      tasks: const [
        'رسالة نجاح بحركة بسيطة',
        'رقم الطلب (orderId)',
        'زر "طلباتي" ← Orders، وزر "الرئيسية" ← Home',
      ],
      actions: [
        ElevatedButton(
          onPressed: () => context.go(AppRoutes.orders),
          child: const Text('طلباتي'),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => context.go(AppRoutes.home),
          child: const Text('الرئيسية'),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
