import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';
import 'package:servetest/helpers/dbhelper.dart';
import 'package:servetest/models/products.dart';
import 'package:sqflite/sqflite.dart';

//import '../screens/cart_screen.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

enum FilterOptions { Favourites, All }

class ProductsOverviewScreen extends StatefulWidget {
  static const route = '/overview';

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavourites = false;
  bool _isInit = true;
  bool _isLoading = false;
  bool hasLoadedIntoDb = false;
  var productList;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isLoading = true;
      if (hasLoadedIntoDb) {
        Provider.of<Products>(context).fetchAndSetProducts().then((products) {
          setState(() {
            _isLoading = false;
            for (int i = 0; i < products.length; i++) {
              print(products[i].id);
              _insertProduct(products[i]);
            }
            hasLoadedIntoDb = true;
          });
        });
      } else {
        //fetch data from db
        Provider.of<Products>(context).fetchFromDb().then((value) => {
        setState(() {
          _isLoading = false;
        })
        });

      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }


  _insertProduct(ProductItem product) async {
    print('ID Inserting ${product.id}');

    // get a reference to the database
    // because this is an expensive operation we use async and await
    Database db = await DatabaseHelper.instance.database;

    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: product.id,
      DatabaseHelper.columnName: product.name,
      DatabaseHelper.columnDescription: product.description,
      DatabaseHelper.columnImage: product.image,
      DatabaseHelper.columnPrice: product.price,
    };

    // do the insert and get the id of the inserted row
    int id = await db.insert(DatabaseHelper.table, row);

    // show the results: print all rows in the db
    print(await db.query(DatabaseHelper.table));
  }

//  insertProducts(List<ProductItem> products) async{
//    Database db = await DatabaseHelper.instance.database;
//    var batch = db.batch();
//    batch.insert("products", products.toJson());
//  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Serve Shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValues) {
              setState(() {
                if (selectedValues == FilterOptions.All) {
                  _showOnlyFavourites = false;
                } else {
                  _showOnlyFavourites = true;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) =>
            [
              PopupMenuItem(
                child: Text('Only favourites'),
                value: FilterOptions.Favourites,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) =>
                Badge(
                  child: ch,
                  value: cart.itemCount.toString(),
                ),
            child: IconButton(
              icon: Icon(Icons.shopping_basket),
              onPressed: () {
                //Navigator.of(context).pushNamed(CartScreen.route);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ProductsGrid(),
    );
  }
}
