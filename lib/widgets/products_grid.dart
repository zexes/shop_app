import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';
import '../widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    final productsData = Provider.of<ProductsProvider>(context).items;
    return Consumer<ProductsProvider>(
      builder: (ctx, productsData, Widget child) {
        final productList = productsData.items;
        return GridView.builder(
          padding: const EdgeInsets.all(10.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (ctx, index) => ChangeNotifierProvider(
            create: (_) => productList[index],
            child: ProductItem(
//              id: productsList[index].id,
//              title: productsList[index].title,
//              imageUrl: productsList[index].imageUrl,
                ),
          ),
          itemCount: productList.length,
        );
      },
    );
  }
}
