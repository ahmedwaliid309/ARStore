import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/product.dart';

class ProductRepository {
  static const categories = ['Sofas', 'Beds', 'Tables', 'Chairs', 'Lighting'];

  CollectionReference<Map<String, dynamic>> get _col =>
      FirebaseFirestore.instance.collection('products');

  Product _fromDoc(DocumentSnapshot<Map<String, dynamic>> d) =>
      Product.fromJson({...d.data()!, 'id': d.id});

  Future<List<Product>> all() async =>
      (await _col.get()).docs.map(_fromDoc).toList();

  Future<List<Product>> byCategory(String category) async =>
      (await _col.where('category', isEqualTo: category).get())
          .docs
          .map(_fromDoc)
          .toList();

  Future<List<Product>> search(String query) async {
    final q = query.trim().toLowerCase();
    final list = await all();
    if (q.isEmpty) return list;
    return list
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q))
        .toList();
  }

  Future<Product?> byId(String id) async {
    final d = await _col.doc(id).get();
    return d.exists ? _fromDoc(d) : null;
  }
}