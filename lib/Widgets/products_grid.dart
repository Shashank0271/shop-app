import 'package:flutter/material.dart';
import 'package:my_shop_app/Provider/products_provider.dart';
import 'package:my_shop_app/Widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavoritesOnly;
  ProductsGrid(this.showFavoritesOnly);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final loadedProducts =
        showFavoritesOnly ? productsData.favorites : productsData.items;
    return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 10,
        ),
        itemCount: loadedProducts.length,
        itemBuilder: (BuildContext context, int index) {
          return ChangeNotifierProvider.value(
            value: loadedProducts[index],
            child: ProductItem(),
          );
        });
  }
}
