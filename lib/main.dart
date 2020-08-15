import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helpers/custom_route.dart';
import './screens/splash_screen.dart';
import './providers/auth.dart';
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
        ChangeNotifierProvider<Auth>.value(
          // verify if create ot value as this caused issue
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: (_) => ProductsProvider("", "", []),
          update: (_, auth, previousProductsProvider) => ProductsProvider(
              auth.token,
              auth.userId,
              previousProductsProvider == null
                  ? []
                  : previousProductsProvider.items),
        ),
        ChangeNotifierProvider<Cart>(
          create: (_) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders("", "", []),
          update: (_, auth, previousOrders) => Orders(auth.token, auth.userId,
              previousOrders == null ? [] : previousOrders.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.green,
              fontFamily: 'Lato',
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              }),
          ),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
//          initialRoute: auth.isAuth ? ProductOverviewScreen.id : AuthScreen.id,
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
      ),
    );
  }
}
