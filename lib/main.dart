import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/user_product_screen.dart';
import './screens/orders_screen.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './providers/cart.dart';
import './providers/products_provider.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/add_edit_product_screen.dart';
import './screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductsProvider>(
          create: (_) => ProductsProvider(),
        ),
        ChangeNotifierProvider<Cart>(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider<Orders>(
          create: (_) => Orders(),
        )
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.green,
            fontFamily: 'Lato'),
//      home: ProductOverviewScreen(),
        initialRoute: AuthScreen.id,
        routes: {
          AuthScreen.id: (_) => AuthScreen(),
          ProductOverviewScreen.id: (_) => ProductOverviewScreen(),
          ProductDetailScreen.id: (_) => ProductDetailScreen(),
          CartScreen.id: (_) => CartScreen(),
          OrdersScreen.id: (_) => OrdersScreen(),
          UserProductsScreen.id: (_) => UserProductsScreen(),
          EditProductScreen.id: (_) => EditProductScreen()
        },
      ),
    );
  }
}
