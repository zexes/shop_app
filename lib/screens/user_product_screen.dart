import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/add_edit_product_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import '../providers/products_provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const String id = 'User_Products_Screen';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.id);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(
            itemBuilder: (_, i) => UserProductItem(
              id: productsData.items[i].id,
              title: productsData.items[i].title,
              imageUrl: productsData.items[i].imageUrl,
            ),
            itemCount: productsData.items.length,
            separatorBuilder: (__, i) => Divider(),
          ),
        ),
      ),
    );
  }
}
