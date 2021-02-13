import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:servetest/helpers/dbhelper.dart';
import 'package:servetest/models/products.dart';

import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<ProductItem> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<ProductItem> get items {
    return [..._items];
  }


  Future<List<ProductItem>> fetchAndSetProducts(
      [bool filterByUser = false]) async {
    var url =
        'https://gorest.co.in/public-api/products';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<ProductItem> loadedProducts = productsFromJson(response.body)
          .data;
      if (extractedData == null) {
        return null;
      }
      _items = loadedProducts;
      notifyListeners();
      return _items;
    } catch (error) {
      throw error;
    }
  }

  Future<List<ProductItem>> fetchFromDb() async {
    List<ProductItem> productList;
    try {
      var rows = DatabaseHelper.instance.queryAllRows().then((value) =>
      {
        print('Rows oo ${value.length}'),
        productList = List.generate(value.length, (i) {
          return ProductItem(
              id: value[i]['id'],
              name: value[i]['name'],
              image: value[i]['image'],
              description: value[i]['description']);
        })
      }).then((value) =>
      {
        print('Prods ${productList.length}'),
        _items = productList,
        notifyListeners()
      });

    }

      //print('Prods ${productList.length}');
          catch(error) {
  throw error;
  }
}}
