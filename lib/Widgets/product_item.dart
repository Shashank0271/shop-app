import 'package:flutter/material.dart';
import 'package:my_shop_app/Provider/cart.dart';
import 'package:my_shop_app/Screens/product_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:my_shop_app/Provider/product.dart';
import 'package:my_shop_app/Provider/auth_provider.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final token = Provider.of<Auth>(context, listen: false).token;
    final cart = Provider.of<Cart>(context, listen: true);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, ProductDetailsScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(product.imageUrl),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
              builder: (ctx, product, child) => IconButton(
                    icon: Icon(
                      product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                    onPressed: () {
                      product.toggleFavoriteStatus(token!);
                    },
                    color: Theme.of(context).colorScheme.secondary,
                  )),
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.left,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              //undo option after adding to cart :
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text(
                  'Item added to cart',
                  textAlign: TextAlign.center,
                ),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    cart.undoRemove(product.id);
                  },
                ),
              ));
            },
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
