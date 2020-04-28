import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;

  CartItem({this.id, this.price, this.quantity, this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: FittedBox(
                child: Text('\$$price'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18.0),
          ),
          subtitle: Text(
            'Total: \$${(price * quantity)}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
          ),
          trailing: Text(
            '$quantity x',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18.0),
          ),
        ),
      ),
    );
  }
}
