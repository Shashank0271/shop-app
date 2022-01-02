import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_shop_app/Screens/products_overview_screen.dart';
import 'package:my_shop_app/Screens/product_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:my_shop_app/Provider/products_provider.dart';

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
    return ChangeNotifierProvider(
      create: (ctx) => Products(),
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Lato',
          colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.purple, accentColor: Colors.orange),
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailsScreen.routeName: (context) => ProductDetailsScreen(),
        },
      ),
    );
  }
}
