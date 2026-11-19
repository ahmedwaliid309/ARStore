import 'package:flutter/foundation.dart';
import 'cart_provider.dart';

class AppOrder {
  const AppOrder({
    required this.id,
    required this.items,
    required this.total,
    required this.createdAt,
    this.status = 'قيد التجهيز',
  });

  final String id;
  final List<CartItem> items;
  final double total;
  final DateTime createdAt;
  final String status;
}

/// الطلبات. المسؤول: السيد (Checkout بيسجّل الطلب) ووليد (شاشة السجل بتقرا).
/// الأسماء دي متفق عليها مع باقي التيم، متغيّرهاش من غير ما تبلّغ.
class OrdersProvider extends ChangeNotifier {
  final List<AppOrder> _orders = [];

  List<AppOrder> get orders => List.unmodifiable(_orders);

  AppOrder placeOrder({required List<CartItem> items, required double total}) {
    final now = DateTime.now();
    final order = AppOrder(
      id: 'ORD-${now.millisecondsSinceEpoch}',
      items: List.of(items),
      total: total,
      createdAt: now,
    );
    _orders.insert(0, order);
    notifyListeners();
    return order;
  }
}
