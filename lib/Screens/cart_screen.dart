import 'package:flutter/material.dart';
import 'package:my_shop_app/Provider/cart.dart';
import 'package:provider/provider.dart';
import 'package:my_shop_app/Widgets/cart_item.dart' as ci;

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total', style: TextStyle(fontSize: 20)),
                  const Spacer(),
                  Chip(
                    label: Text(
                      cart.totalAmount.toString(),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        'ORDER NOW',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ))
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.numberOfItems,
              itemBuilder: (context, index) => ci.CartItem(
                  id: cart.items[index]!.id,
                  title: cart.items[index]!.title,
                  price: cart.items[index]!.price,
                  quantity: cart.items[index]!.quantity),
            ),
          ),
        ],
      ),
    );
  }
}
