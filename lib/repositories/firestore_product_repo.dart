import 'package:demo/models/app_products.dart';
import 'package:demo/repositories/product_repo.dart';
import 'package:demo/services/firestore_service.dart';

class FirestoreProductRepository implements ProductRepository {
  // constructor and dependencies
  FirestoreProductRepository(this._service);
  final FirestoreProductService _service;

  @override
  // Watch products
  Stream<List<AppProduct>> watchProducts({required String searchTerm}) {
    // filter products by search term
    return _service.watchProducts(searchTerm: searchTerm).map((snapshot) {
      return snapshot.docs
          .map((d) => AppProduct.fromMap(d.id, d.data()))
          .toList();
    });
  }

  // Add product
  @override
  Future<void> addProduct(AppProduct product) {
    return _service.addProduct(product.toMap());
  }

  // delete product
  @override
  Future<void> deleteProduct(String id) {
    return _service.deleteProduct(id);
  }

  // update product
  @override
  Future<void> updateProduct(AppProduct product) {
    return _service.updateProduct(product.id, product.toMap());
  }
}
