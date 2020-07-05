import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';
import '../screens/products_overview_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Auth>(context, listen: false);
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Greetings ${provider.email}'),
            automaticallyImplyLeading: false, // not to add back button
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProductOverviewScreen.id);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrdersScreen.id);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(UserProductsScreen.id);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => Provider.of<Auth>(context, listen: false).logout(),
//            onTap: () {
//              Navigator.of(context).pop();
//              Navigator.of(context).pushReplacementNamed('/');
//              Provider.of<Auth>(context, listen: false).logout();
//            },
          ),
        ],
      ),
    );
  }
}
