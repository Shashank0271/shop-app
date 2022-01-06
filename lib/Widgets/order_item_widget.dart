import 'package:flutter/material.dart ';
import 'package:my_shop_app/Provider/orders.dart';
import 'package:intl/intl.dart';

class OrderItemWidget extends StatelessWidget {
  final OrderItem order;
  const OrderItemWidget({required this.order});
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('${order.amount}'),
              subtitle: Text(
                DateFormat('dd MM yyyy:mm').format(order.dateTime),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.expand_more),
                onPressed: () {},
              ),
            )
          ],
        ));
  }
}
