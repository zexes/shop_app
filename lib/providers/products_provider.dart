import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import '../model/http_exception.dart';
import 'product.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
//    Product(
//      id: 'p1',
//      title: 'Red Shirt',
//      description: 'A red shirt - it is pretty red!',
//      price: 29.99,
//      imageUrl:
//          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//    ),
//    Product(
//      id: 'p2',
//      title: 'Trousers',
//      description: 'A nice pair of trousers.',
//      price: 59.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//    ),
//    Product(
//      id: 'p3',
//      title: 'Yellow Scarf',
//      description: 'Warm and cozy - exactly what you need for the winter.',
//      price: 19.99,
//      imageUrl:
//          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//    ),
//    Product(
//      id: 'p4',
//      title: 'A Pan',
//      description: 'Prepare any meal you want.',
//      price: 49.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//    )
  ];

//  List<Product> get items{
//    return [..._items];
//  }
  final String token;

  ProductsProvider(this.token, this._items);

  List<Product> get items {
    return UnmodifiableListView(_items);
  }

  List<Product> get favoriteItems {
    return UnmodifiableListView(_items)
        .where((item) => item.isFavorite)
        .toList();
  }

  Product findById(String id) {
    return _items.firstWhere((data) => data.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    final url =
        'https://max-flutter-base.firebaseio.com/products.json?auth=$token';
    try {
      final List<Product> loadedProduct = [];
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      extractedData.forEach((key, value) {
        loadedProduct.add(Product.toProduct(key, value));
      });
      _items = loadedProduct;
      print(json.decode(response.body));
    } catch (error) {
      throw error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://max-flutter-base.firebaseio.com/products.json';
    try {
      final response = await http.post(url, body: json.encode(product.toMap()));
      if (response.statusCode != 200) return;
      final productOnServerId = json.decode(response.body)['name'];
      print(productOnServerId);
      final newProduct = Product(
        id: productOnServerId,
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
//    _items.insert(0, newProduct); // in order to prepend to list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((product) => product.id == id);
    if (productIndex >= 0) {
      final url = 'https://max-flutter-base.firebaseio.com/products/$id.json';
      await http.patch(url,
          body: json.encode(newProduct.toMapPatch())); //cloud update
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://max-flutter-base.firebaseio.com/products/$id.json';
    final existingProductIndex =
        _items.indexWhere((product) => product.id == id);
    Product existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex); //removing locally
    notifyListeners();
    //if any error occur on deleting cloud will not delete hence we should reinsert locally too n probably handle error
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
