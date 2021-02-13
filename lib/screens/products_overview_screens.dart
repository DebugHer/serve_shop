import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';
import 'package:servetest/helpers/dbhelper.dart';
import 'package:servetest/helpers/preference_helper.dart';
import 'package:servetest/models/products.dart';
import 'package:sqflite/sqflite.dart';

//import '../screens/cart_screen.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import 'cart_screen.dart';

enum FilterOptions { Favourites, All }

class ProductsOverviewScreen extends StatefulWidget {
  static const route = '/overview';

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  final TextEditingController _searchQuery = new TextEditingController();
  bool _showOnlyFavourites = false;
  bool _isInit = true;
  bool _isLoading = false;
  bool hasLoadedIntoDb = false;
  var productList;

  Widget appBarTitle = Text(
    "Serve Shop",
    style: TextStyle(color: Colors.white),
  );

  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
  );

  bool _isSearching = false;

  @override
  void didChangeDependencies() {
     PreferenceHelper().getIsCached().then((value) => {
       hasLoadedIntoDb = value
    });
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
            PreferenceHelper().isCached();
            //hasLoadedIntoDb = true;
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
          new IconButton(icon: actionIcon, onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                this.actionIcon = new Icon(Icons.close, color: Colors.orange,);
                this.appBarTitle = new TextField(
                  controller: _searchQuery,
                  style: new TextStyle(
                    color: Colors.orange,
                  ),
                  decoration: new InputDecoration(
                      hintText: "Search here..",
                      hintStyle: new TextStyle(color: Colors.white)
                  ),
                );
                _handleSearchStart();
              }
              else {
                _handleSearchEnd();
              }
            });
          },),
          Consumer<Cart>(
            builder: (_, cart, ch) =>
                Badge(
                  child: ch,
                  value: cart.itemCount.toString(),
                ),
            child: IconButton(
              icon: Icon(Icons.shopping_basket),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.route);
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

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }
  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(Icons.search, color: Colors.orange,);
      this.appBarTitle = new Text("Serve Shop", style: new TextStyle(color: Colors.white),);
      _isSearching = false;
      _searchQuery.clear();
    });
  }
}
