import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_shop_app/Screens/products_overview_screen.dart';
import 'package:my_shop_app/Screens/product_details_screen.dart';
import 'package:my_shop_app/Screens/user_products_screen.dart';
import 'package:provider/provider.dart';
import 'package:my_shop_app/Provider/products_provider.dart';
import 'package:my_shop_app/Provider/cart.dart';
import 'package:my_shop_app/Screens/cart_screen.dart';
import 'package:my_shop_app/Provider/orders.dart';
import 'package:my_shop_app/Screens/orders_screen.dart';
import 'Screens/edit_products_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: 'Lato',
            colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.purple, accentColor: Colors.orange),
            textTheme: const TextTheme(
              headline6: TextStyle(color: Colors.white),
            )),
        home: const ProductsOverviewScreen(),
        routes: {
          ProductDetailsScreen.routeName: (context) => ProductDetailsScreen(),
          CartScreen.routeName: (context) => CartScreen(),
          OrdersScreen.routeName: (context) => OrdersScreen(),
          UserProductsScreen.routeName: (context) => UserProductsScreen(),
          EditProductsScreen.routeName: (context) => EditProductsScreen(),
        },
      ),
      providers: [
        ChangeNotifierProvider(create: (context) => Products()),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProvider(create: (context) => Orders()),
      ],
    );
  }
}
