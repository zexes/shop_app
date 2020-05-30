import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../widgets/app_drawer.dart';
import '../screens/cart_screen.dart';
import '../providers/cart.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';

enum FilterOptions { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  static const String id = "product_overview_screen";

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showOnlyFavorites = false;
  bool _isInit = true;

  @override
  void initState() {
//    Provider.of<ProductsProvider>(context).fetchAndSetProducts(); // work only listen: false
//    Future.delayed(Duration.zero).then(
//      (value) => Provider.of<ProductsProvider>(context).fetchAndSetProducts(),
//    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<ProductsProvider>(context).fetchAndSetProducts();
    }
    _isInit =
        false; // since didChangeDependencies run very often we need do this check so as to skip whatever we placed in the parenthesis. Hence runs only when page first loads
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop"),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
            ),
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              )
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, noRebuildChild) {
              //child : noRebuildChild (ICON) passed outside to prevent rebuilding
              return Badge(
                child: noRebuildChild,
                value: cart.itemCount.toString(),
              );
            },
            child: IconButton(
              // static
              splashColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.id);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: ProductGrid(showOnlyFavorites: _showOnlyFavorites),
    );
  }
}
