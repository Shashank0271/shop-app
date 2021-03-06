import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_shop_app/Provider/products_provider.dart';
import 'package:my_shop_app/Widgets/app_drawer.dart';
import 'edit_products_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('User Products'),
        actions: [
          IconButton(
            onPressed: () {
              ///enables the user to add an item
              Navigator.of(context).pushNamed(EditProductsScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          refreshProducts(context);
        },
        child: FutureBuilder(
          future: refreshProducts(context),
          builder: (cx, snapshot) => snapshot.hasData
              ? const Center(child: CircularProgressIndicator())
              : Consumer<Products>(
                  builder: (context, productData, _) => ListView.builder(
                    itemCount: productData.items.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(productData.items[index].title),
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(productData.items[index].imageUrl),
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  EditProductsScreen.routeName,
                                  arguments: productData.items[index].id,
                                );
                              },
                              icon: const Icon(Icons.edit),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            IconButton(
                              onPressed: () async {
                                try {
                                  productData.deleteProduct(
                                      productData.items[index].id);
                                } catch (error) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                          content: Text(
                                    'Deleting failed',
                                    textAlign: TextAlign.center,
                                  )));
                                }
                              },
                              icon: Icon(Icons.delete,
                                  color: Theme.of(context).errorColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
