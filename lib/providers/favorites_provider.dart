import 'package:flutter/foundation.dart';
import 'package:decora/data/models/product.dart';

/// المفضلة. المسؤول: أحمد عطا.
/// TODO(عطا): حفظ محلي بـ shared_preferences (Product فيه toJson و fromJson).
/// الأسماء دي متفق عليها مع باقي التيم، متغيّرهاش من غير ما تبلّغ.
class FavoritesProvider extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);

  bool isFavorite(String productId) => _items.any((p) => p.id == productId);

  void toggle(Product product) {
    final i = _items.indexWhere((p) => p.id == product.id);
    if (i >= 0) {
      _items.removeAt(i);
    } else {
      _items.insert(0, product);
    }
    notifyListeners();
  }
}
