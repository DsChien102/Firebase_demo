import 'package:demo/models/app_products.dart';
import 'package:demo/repositories/product_repo.dart';
import 'package:flutter/foundation.dart';

class ProductsViewModel extends ChangeNotifier {
  ProductsViewModel({required ProductRepository productRepository})
    : _repo = productRepository;

  final ProductRepository _repo;

  String _searchTerm = '';
  String get searchTerm => _searchTerm;

  void setSearchTerm(String value) {
    _searchTerm = value;
    notifyListeners();
  }

  Stream<List<AppProduct>> get productsStream {
    return _repo.watchProducts(searchTerm: _searchTerm);
  }

  Future<void> add({
    required String name,
    required num price,
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

  Future<void> update({
    required String id,
    required String name,
    required num price,
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

  Future<void> delete(String id) => _repo.deleteProduct(id);
}
