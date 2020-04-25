import 'package:flutter/material.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyShop',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.green,
          fontFamily: 'Lato'),
//      home: ProductOverviewScreen(),
      initialRoute: ProductOverviewScreen.id,
      routes: {
        ProductOverviewScreen.id: (ctx) => ProductOverviewScreen(),
        ProductDetailScreen.id: (ctx) => ProductDetailScreen()
      },
    );
  }
}
