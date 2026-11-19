// ══════════════════════════════════════════════════════════
//  الشاشة    : Orders (سجل الطلبات)
//  المسؤول   : أحمد وليد
//  الـ Branch  : feature/orders
//  الملف     : lib/features/orders/orders_screen.dart
// ══════════════════════════════════════════════════════════
//  المطلوب:
//    - قايمة الطلبات من OrdersProvider.orders (رقم الطلب والتاريخ والحالة والإجمالي)
//    - حالة فاضية لو مفيش طلبات
//    - تفاصيل الطلب (اختياري)
//
//  قواعد: شغلك جوه فولدر الشاشة بس. ممنوع تعدّل في core/ أو main.dart أو
//  pubspec.yaml (وليد بس). الألوان من AppColors، والأحجام بـ .w .h .r .sp،
//  والتنقل من AppRoutes. الطلبات في initState (مش build).
// ══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:decora/core/widgets/placeholder_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: 'Orders',
      owner: 'أحمد وليد',
      branch: 'feature/orders',
      tasks: const [
        'قايمة الطلبات من OrdersProvider.orders (رقم الطلب والتاريخ والحالة والإجمالي)',
        'حالة فاضية لو مفيش طلبات',
        'تفاصيل الطلب (اختياري)',
      ],
      actions: [

      ],
    );
  }
}
