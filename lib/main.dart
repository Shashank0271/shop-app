import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_shop_app/Screens/auth_screen.dart';
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
import 'Provider/auth_provider.dart';

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
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              fontFamily: 'Lato',
              errorColor: Colors.red,
              colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: Colors.purple, accentColor: Colors.orange),
              textTheme: const TextTheme(
                headline6: TextStyle(color: Colors.white),
              )),
          home:
              auth.isAuth ? const ProductsOverviewScreen() : const AuthScreen(),
          routes: {
            ProductDetailsScreen.routeName: (context) => ProductDetailsScreen(),
            CartScreen.routeName: (context) => const CartScreen(),
            OrdersScreen.routeName: (context) => const OrdersScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            EditProductsScreen.routeName: (context) =>
                const EditProductsScreen(),
            ProductsOverviewScreen.routeName: (context) =>
                const ProductsOverviewScreen()
          },
        ),
      ),
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (_, auth, prevproduct) => Products(auth.token, auth.userId),
          create: (context) => Products(null, null),
        ),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context, auth, previous) => Orders(auth.token, auth.userId),
          create: (context) => Orders(null, null),
        ),
      ],
    );
  }
}
