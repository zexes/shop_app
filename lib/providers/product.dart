import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Map<String, dynamic> toMap() => {
        "title": title,
        "description": description,
        "imageUrl": imageUrl,
        "price": price,
        'isFavorite': isFavorite
      };

  static Product toProduct(String id, dynamic obj) {
    return Product(
        id: id,
        title: obj['title'],
        description: obj['description'],
        price: obj['price'],
        imageUrl: obj['imageUrl'],
        isFavorite: obj['isFavorite']);
  }
}
