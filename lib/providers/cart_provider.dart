import 'package:flutter/foundation.dart';
import 'package:decora/data/models/product.dart';

class CartItem {
  CartItem({required this.product, this.quantity = 1});

  final Product product;
  int quantity;

  double get subtotal => product.price * quantity;
}

/// السلة. المسؤول: السيد.
/// TODO(السيد): حفظ محلي (shared_preferences) لو حبيتوا.
/// الأسماء دي متفق عليها مع باقي التيم، متغيّرهاش من غير ما تبلّغ.
class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int get count => _items.fold(0, (sum, i) => sum + i.quantity);
  double get total => _items.fold(0, (sum, i) => sum + i.subtotal);
  bool get isEmpty => _items.isEmpty;

  void add(Product product, {int quantity = 1}) {
    final i = _items.indexWhere((e) => e.product.id == product.id);
    if (i >= 0) {
      _items[i].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void setQuantity(String productId, int quantity) {
    final i = _items.indexWhere((e) => e.product.id == productId);
    if (i < 0) return;
    if (quantity <= 0) {
      _items.removeAt(i);
    } else {
      _items[i].quantity = quantity;
    }
    notifyListeners();
  }

  void remove(String productId) {
    _items.removeWhere((e) => e.product.id == productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
