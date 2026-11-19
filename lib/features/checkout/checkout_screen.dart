// ══════════════════════════════════════════════════════════
//  الشاشة    : Checkout (إتمام الشراء)
//  المسؤول   : السيد أسامة
//  الـ Branch  : feature/checkout
//  الملف     : lib/features/checkout/checkout_screen.dart
// ══════════════════════════════════════════════════════════
//  المطلوب:
//    - فورم عنوان التوصيل مع تحقق
//    - اختيار طريقة الدفع (وهمي)
//    - ملخص الطلب من CartProvider
//    - تأكيد ← OrdersProvider.placeOrder ثم CartProvider.clear ثم OrderConfirmation
//
//  قواعد: شغلك جوه فولدر الشاشة بس. ممنوع تعدّل في core/ أو main.dart أو
//  pubspec.yaml (وليد بس). الألوان من AppColors، والأحجام بـ .w .h .r .sp،
//  والتنقل من AppRoutes. الطلبات في initState (مش build).
// ══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:decora/core/router/app_router.dart';
import 'package:decora/core/widgets/placeholder_screen.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: 'Checkout',
      owner: 'السيد أسامة',
      branch: 'feature/checkout',
      tasks: const [
        'فورم عنوان التوصيل مع تحقق',
        'اختيار طريقة الدفع (وهمي)',
        'ملخص الطلب من CartProvider',
        'تأكيد ← OrdersProvider.placeOrder ثم CartProvider.clear ثم OrderConfirmation',
      ],
      actions: [
        ElevatedButton(
          onPressed: () => context.go(AppRoutes.orderConfirmationPath('demo')),
          child: const Text('تأكيد (تجريبي)'),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
