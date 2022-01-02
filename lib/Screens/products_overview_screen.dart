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
  var _showOnlyFavorites = false;
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
                  _showOnlyFavorites = true;
                } else if (selectedValue == FilterOptions.all) {
                  _showOnlyFavorites = false;
                }
              },
              icon: const Icon(
                Icons.more_vert,
              ),
              itemBuilder: (cntx) => [
                    const PopupMenuItem(
                        child: Text('Only Favorites'),
                        value: FilterOptions.favorites),
                    const PopupMenuItem(
                        child: Text('Show All'), value: FilterOptions.all),
                  ]),
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
