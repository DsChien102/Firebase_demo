import 'package:demo/models/app_products.dart';
import 'package:demo/repositories/product_repo.dart';
import 'package:flutter/foundation.dart';

class ProductsViewModel extends ChangeNotifier {
  // constructor
  ProductsViewModel({required ProductRepository productRepository})
    : _repo = productRepository;

  final ProductRepository _repo;

  // search term
  String _searchTerm = '';
  String get searchTerm => _searchTerm;

  // update search term
  void setSearchTerm(String value) {
    _searchTerm = value;
    notifyListeners();
  }

  // stream of products
  Stream<List<AppProduct>> get productsStream {
    return _repo.watchProducts(searchTerm: _searchTerm);
  }

  // add product
  Future<void> add({
    required String name,
    required String price,
    required String description,
  }) {
    final p = AppProduct(
      id: '',
      name: name,
      price: price,
      description: description,
    );
    return _repo.addProduct(p);
  }

  // update product
  Future<void> update({
    required String id,
    required String name,
    required String price,
    required String description,
  }) {
    final p = AppProduct(
      id: id,
      name: name,
      price: price,
      description: description,
    );
    return _repo.updateProduct(p);
  }

  // delete product
  Future<void> delete(String id) => _repo.deleteProduct(id);
}
