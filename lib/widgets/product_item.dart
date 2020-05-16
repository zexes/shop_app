import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
//  final String id;
//  final String title;
//  final String imageUrl;
//
//  ProductItem({this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    // two providers
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.id,
              arguments: product.id,
            );
          },
          child: FadeInImage(
              image: NetworkImage(product.imageUrl),
              placeholder: AssetImage('assets/images/shopping.PNG'),
              fit: BoxFit.cover),
        ),
//        header: GridTileBar(
//          title: ,
//        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border),
            color: Theme.of(context).accentColor,
            onPressed: () {
              product.toggleFavoriteStatus();
            },
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              cart.addItem(
                  id: product.id, price: product.price, title: product.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Added ${product.title} to cart!',
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    textColor: Theme.of(context).primaryColor,
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleQuantity(product.id);
                    },
                  ),
                  backgroundColor: Theme.of(context).accentColor,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
