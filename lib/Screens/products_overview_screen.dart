import 'package:flutter/material.dart';
import 'package:my_shop_app/Provider/product.dart';
import 'package:my_shop_app/Widgets/products_grid.dart';
import 'package:provider/provider.dart';
import 'package:my_shop_app/Provider/products_provider.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductsOverviewScreen extends StatelessWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final productsContainer = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                if (selectedValue == FilterOptions.favorites) {
                  productsContainer.showFavoritesOnly();
                } else if (selectedValue == FilterOptions.all) {
                  productsContainer.showAll();
                }
              },
              icon: const Icon(
                Icons.more_vert,
              ),
              itemBuilder: (cntx) => [
                    PopupMenuItem(
                        child: Text('Only Favorites'),
                        value: FilterOptions.favorites),
                    PopupMenuItem(
                        child: Text('Show All'), value: FilterOptions.all),
                  ]),
        ],
      ),
      body: ProductsGrid(),
    );
  }
}
