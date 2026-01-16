import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProductService {
  FirestoreProductService(this._db);
  final FirebaseFirestore _db;

  // Reference to the 'products' collection
  CollectionReference<Map<String, dynamic>> get _ref =>
      _db.collection("products");

  // tra ve danh sach san pham theo tu khoa tim kiem
  Stream<QuerySnapshot<Map<String, dynamic>>> watchProducts({
    required String searchTerm,
  }) {
    // chuan doi tuong tim kiem
    final q = searchTerm.trim().toLowerCase();
    if (q.isEmpty) {
      return _ref.orderBy('nameLower').snapshots();
    }

    // tra ve danh sach san pham khop voi tu khoa tim kiem
    return _ref
        .orderBy("nameLower")
        .where('nameLower', isGreaterThanOrEqualTo: q)
        .where('nameLower', isLessThanOrEqualTo: '$q\uf8ff')
        .snapshots();
  }

  // Adds a new product
  Future<void> addProduct(Map<String, dynamic> data) => _ref.add(data);

  // Updates an by ID
  Future<void> updateProduct(String id, Map<String, dynamic> data) =>
      _ref.doc(id).update(data);

  // Deletes a product by ID
  Future<void> deleteProduct(String id) => _ref.doc(id).delete();
}
