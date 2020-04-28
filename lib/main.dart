import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import './providers/cart.dart';
import './providers/products_provider.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';

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
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.green,
            fontFamily: 'Lato'),
//      home: ProductOverviewScreen(),
        initialRoute: ProductOverviewScreen.id,
        routes: {
          ProductOverviewScreen.id: (_) => ProductOverviewScreen(),
          ProductDetailScreen.id: (_) => ProductDetailScreen(),
          CartScreen.id: (_) => CartScreen()
        },
      ),
    );
  }
}
