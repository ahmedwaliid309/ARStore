import 'package:cloud_firestore/cloud_firestore.dart';
import 'mock_products.dart';

Future<void> seedProducts() async {
  final db = FirebaseFirestore.instance;
  final batch = db.batch();
  for (final p in MockProducts.all) {
    batch.set(db.collection('products').doc(p.id), p.toJson());
  }
  await batch.commit();
}