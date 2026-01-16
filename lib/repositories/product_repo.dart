import 'package:demo/models/app_products.dart';

abstract class ProductRepository {
  // Watch products
  Stream<List<AppProduct>> watchProducts({required String searchTerm});

  // Add product
  Future<void> addProduct(AppProduct product);

  // Update product
  Future<void> updateProduct(AppProduct product);

  // Delete product
  Future<void> deleteProduct(String id);
}
