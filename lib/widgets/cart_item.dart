import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem({this.id, this.price, this.quantity, this.title, this.productId});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete, color: Colors.white, size: 40),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Are you sure'),
            content: Text('Do you want to remove the item from the cart?'),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(_).pop(false);
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(_).pop(true);
                },
              )
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
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
              'Total: \$${(price * quantity).toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
            ),
            trailing: Material(
              type: MaterialType.transparency,
              color: Colors.transparent,
              child: Consumer<Cart>(builder: (_, cart, __) {
                return InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  onTap: () {
                    cart.removeSingleQuantity(productId);
                  },
                  onDoubleTap: () {
                    cart.addSameTypeQuantity(productId);
                  },
                  splashColor: Theme.of(context).accentColor,
                  child: Text(
                    '$quantity x',
                    style:
                        TextStyle(fontWeight: FontWeight.w900, fontSize: 18.0),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
