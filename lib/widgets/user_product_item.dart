import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import '../screens/add_edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem({this.title, this.imageUrl, this.id});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100.0,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.id, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _showDeleteDialog(context),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }

  Future _showDeleteDialog(BuildContext context) {
    return showDialog(
        context: context,
        child: AlertDialog(
          clipBehavior: Clip.antiAlias,
          title: Text(
            'Delete Confirmation!!!',
            style: TextStyle(color: Color(0xff339900)),
            textAlign: TextAlign.center,
          ),
          content: Text(
            'Are you sure you want to delete product?',
            style: TextStyle(color: Theme.of(context).errorColor),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            SizedBox(
              width: 15,
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Provider.of<ProductsProvider>(context, listen: false)
                    .deleteProduct(id);
                Navigator.of(context).pop(true);
              },
            )
          ],
        ));
  }
}
