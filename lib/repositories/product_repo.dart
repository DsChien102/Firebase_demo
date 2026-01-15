import 'package:demo/models/app_products.dart';

abstract class ProductRepository {
  Stream<List<AppProduct>> watchProducts({required String searchTerm});

  Future<void> addProduct(AppProduct product);

  Future<void> updateProduct(AppProduct product);

  Future<void> deleteProduct(String id);
}
