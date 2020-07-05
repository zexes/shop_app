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
  bool _isLoading = false;

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
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context, listen: false)
          .fetchAndSetProducts()
          .then((_) {
        print('am seriously here');
      });
      setState(() {
        _isLoading = false;
      });
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductGrid(showOnlyFavorites: _showOnlyFavorites),
    );
  }
}

//A ProductsProvider was used after being disposed.
//I/flutter ( 5761): Once you have called dispose() on a ProductsProvider, it can no longer be used.
//E/flutter ( 5761): [ERROR:flutter/lib/ui/ui_dart_state.cc(157)] Unhandled Exception: setState() called after dispose(): _ProductOverviewScreenState#5f66f(lifecycle state: defunct, not mounted)
//E/flutter ( 5761): This error happens if you call setState() on a State object for a widget that no longer appears in the widget tree (e.g., whose parent widget no longer includes the widget in its build). This error can occur when code calls setState() from a timer or an animation callback.
//E/flutter ( 5761): The preferred solution is to cancel the timer or stop listening to the animation in the dispose() callback. Another solution is to check the "mounted" property of this object before calling setState() to ensure the object is still in the tree.
//E/flutter ( 5761): This error might indicate a memory leak if setState() is being called because another object is retaining a reference to this State object after it has been removed from the tree. To avoid memory leaks, consider breaking the reference to this object during dispose().
