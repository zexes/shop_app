import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../model/http_exception.dart';

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

  Future<bool> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://max-flutter-base.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    final response = await http.put(url, body: json.encode(isFavorite));
    if (response.statusCode >= 400) {
      isFavorite = oldStatus;
      notifyListeners();
      throw HttpException('Failed to mark as favorite.');
    }
    return isFavorite;
  }

  Map<String, dynamic> toMap(String userId) => {
        "title": title,
        "description": description,
        "imageUrl": imageUrl,
        "price": price,
        'creatorId': userId,
      };

  Map<String, dynamic> toMapPatch() => {
        "title": title,
        "description": description,
        "imageUrl": imageUrl,
        "price": price,
      };

  static Product toProduct(String id, dynamic obj, dynamic favoriteData) {
    return Product(
        id: id,
        title: obj['title'],
        description: obj['description'],
        price: obj['price'],
        imageUrl: obj['imageUrl'],
        isFavorite: favoriteData == null ? false : favoriteData[id] ?? false);
  }
}
