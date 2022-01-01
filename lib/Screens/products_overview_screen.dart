import 'package:flutter/material.dart';
import 'package:my_shop_app/Models/product.dart';
import 'package:my_shop_app/Widgets/products_grid.dart';

class ProductsOverviewScreen extends StatelessWidget {
  // static const routeName = '/product_overview_screen';
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Product currentProduct;
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
      ),
      body: ProductsGrid(),
    );
  }
}
