import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servetest/models/products.dart';

//import '../screens/product_details_screen.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItemWidget extends StatelessWidget {
//   final String id;
//   final String title;
//   final String imageUrl;

//   ProductItemWidget(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    //final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return Consumer<ProductItem>(
      builder: (ctx, product, child) => Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GridTile(
            child: GestureDetector(
              onTap: () {
//                Navigator.of(context).pushNamed(
//                  ProductDetailsScreen.route,
//                  arguments: product.id,
//                );
              },
              child: Hero(
                tag: product.id,
                child: FadeInImage(
                  placeholder:
                      AssetImage('assets/images/product-placeholder.png'),
                  image: NetworkImage(product.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            footer: GridTileBar(
              backgroundColor: Colors.redAccent,
              title: Text(
                product.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  cart.addItem(
                    product.id.toString(),
                    double.tryParse(product.price),
                    product.name,
                  );
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added item to cart'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          cart.removeSingleItem(product.id.toString());
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
