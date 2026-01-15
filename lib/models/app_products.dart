class AppProduct {
  final String id;
  final String name;
  final num price;
  final String description;

  const AppProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'nameLower': name.toLowerCase(),
      'price': price,
      'description': description,
    };
  }

  static AppProduct fromMap(String id, Map<String, dynamic> map) {
    final rawPrice = map['price'];
    final price = rawPrice is num
        ? rawPrice
        : num.tryParse(rawPrice?.toString() ?? '') ?? 0;

    return AppProduct(
      id: id,
      name: map['name'],
      price: price,
      description: map['description'],
    );
  }
}
