import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;
  CartItem(
      {required this.id,
      required this.title,
      required this.price,
      required this.quantity});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(child: Text("$price")),
          title: Text(title),
          subtitle: Text("${price * quantity}"),
          trailing: Text('$quantity x'),
        ),
      ),
    );
  }
}
