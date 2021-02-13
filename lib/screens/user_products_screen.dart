import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servetest/models/products.dart';
import 'package:servetest/widgets/product_item.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const route = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchFromDb();
  }

  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              //Navigator.of(context).pushNamed(EditProductScreen.route);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, productsData, _) => ListView.builder(
                        itemCount: productsData.items.length,
                        itemBuilder: (_, index) => UserProductItem(
                          id: productsData.items[index].id.toString(),
                          title: productsData.items[index].name,
                          imageUrl: productsData.items[index].image,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
