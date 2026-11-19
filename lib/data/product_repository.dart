import 'mock_products.dart';
import 'models/product.dart';

/// مصدر بيانات المنتجات. دلوقتي داتا تجريبية، ولاحقاً Firebase (وليد بس
/// هو اللي يبدّل المصدر من جوه الملف ده، والشاشات متتغيرش).
class ProductRepository {
  static const categories = ['كنب', 'سراير', 'ترابيزات', 'كراسي', 'إضاءة'];

  // تأخير بسيط عشان نجرب حالات التحميل
  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 400));

  Future<List<Product>> all() async {
    await _delay();
    return MockProducts.all;
  }

  Future<List<Product>> byCategory(String category) async {
    await _delay();
    return MockProducts.all.where((p) => p.category == category).toList();
  }

  Future<List<Product>> search(String query) async {
    await _delay();
    final q = query.trim();
    if (q.isEmpty) return MockProducts.all;
    return MockProducts.all
        .where((p) => p.name.contains(q) || p.category.contains(q))
        .toList();
  }

  Future<Product?> byId(String id) async {
    await _delay();
    for (final p in MockProducts.all) {
      if (p.id == id) return p;
    }
    return null;
  }
}
