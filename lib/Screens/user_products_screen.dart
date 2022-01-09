import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_shop_app/Provider/products_provider.dart';
import 'package:my_shop_app/Widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  @override
  Widget build(BuildContext context) {
    var productData = Provider.of<Products>(context, listen: false);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('User Products'),
        actions: [
          IconButton(
            onPressed: () {
              ///enables the user to add an item
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: productData.items.length,
        itemBuilder: (_, index) => ListTile(
          title: Text(productData.items[index].title),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(productData.items[index].imageUrl),
          ),
          trailing: SizedBox(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  onPressed: null,
                  icon: const Icon(Icons.edit),
                  color: Theme.of(context).colorScheme.primary,
                ),
                IconButton(
                  onPressed: null,
                  icon: const Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
