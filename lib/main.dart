import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servetest/providers/auth.dart';
import 'package:servetest/providers/cart.dart';
import 'package:servetest/providers/products.dart';
import 'package:servetest/screens/auth_screen.dart';
import 'package:servetest/screens/cart_screen.dart';
import 'package:servetest/screens/edit_product_screen.dart';
import 'package:servetest/screens/products_overview_screens.dart';
import 'package:servetest/screens/splash_screen.dart';
import 'package:servetest/screens/user_products_screen.dart';

import 'helpers/custom_route.dart';
import 'providers/orders.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(
              auth.token,
              auth.getUserId,
              previousProducts == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) => Orders(
              auth.token,
              auth.getUserId,
              previousOrders == null ? [] : previousOrders.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Serve Shop',
          theme: ThemeData(
            primarySwatch: Colors.red,
            accentColor: Colors.redAccent,
            fontFamily: 'Montserrat',
            textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
              headline4: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              headline6: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              headline1: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 60,
              ),
            ),
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
              },
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
            future: auth.tryAutoLogin(),
            builder: (ctx, authResultSnapshot) =>
            authResultSnapshot.connectionState ==
                ConnectionState.waiting
                ? SplashScreen()
                : AuthScreen(),
          ),
          routes: {
//            ProductDetailsScreen.route: (context) => ProductDetailsScreen(),
            CartScreen.route: (context) => CartScreen(),
//            OrdersScreen.route: (context) => OrdersScreen(),
            UserProductsScreen.route: (context) => UserProductsScreen(),
            EditProductScreen.route: (context) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}


