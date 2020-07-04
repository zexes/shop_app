import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';
import '../providers/orders.dart' show Orders;

class OrdersScreen extends StatelessWidget {
  static const String id = 'orders_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (dataSnapshot.error != null) {
              //handle error
              return Center(child: Text('An error occurred'));
            } else {
              return Consumer<Orders>(
                builder: (ctx, ordersData, Widget child) {
                  if (ordersData.orders.isEmpty)
                    return Center(
                      child: Text('No Orders Placed Yet'),
                    );
                  return ListView.builder(
                    itemBuilder: (ctx, index) {
                      return OrderItem(order: ordersData.orders[index]);
                    },
                    itemCount: ordersData.orders.length,
                  );
                },
              );
            }
          },
        ));
  }
}
