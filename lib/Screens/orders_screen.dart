import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_shop_app/Widgets/order_item_widget.dart';
import '/Provider/orders.dart';
import 'package:my_shop_app/Widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders-screen';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  Widget build(BuildContext context) {
    final orderItemData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Your Orders')),
      body: ListView.builder(
        itemCount: orderItemData.orders.length,
        itemBuilder: (context, index) => OrderItemWidget(
          order: orderItemData.orders[index],
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
