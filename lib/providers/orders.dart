import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/providers/product.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });

  static Map<String, dynamic> toMap(
          List<CartItem> products, double amount, String orderedDate) =>
      {
        'amount': amount,
        'products': products.map((cp) => cp.toMap()).toList(),
        "dateTime": orderedDate,
      };

  static OrderItem toOrderItem(String id, dynamic obj) {
    return OrderItem(
        id: id,
        amount: obj['amount'],
        products: obj['products'],
        dateTime: obj['dateTime']);
  }
}

class Orders with ChangeNotifier {
  static const url = 'https://max-flutter-base.firebaseio.com/orders.json';
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
//    return [..._orders];
    return UnmodifiableListView(_orders);
  }

  Future<void> fetchAndSetOrders() async {
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedProduct = [];
      extractedData.forEach((key, value) {
        loadedProduct.add(OrderItem.toOrderItem(key, value));
      });
      _orders = loadedProduct;
      print(json.decode(response.body));
    } catch (error) {
      throw error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode(OrderItem.toMap(
              cartProducts, total, timeStamp.toIso8601String())));
      if (response.statusCode != 200) return;
      final orderOnServerId = json.decode(response.body)['name'];
      print(orderOnServerId);
      final newOrder = OrderItem(
        id: orderOnServerId,
        amount: total,
        products: cartProducts,
        dateTime: timeStamp,
      );
//      _orders.add(newOrder);
      _orders.insert(0, newOrder); // in order to prepend to list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
