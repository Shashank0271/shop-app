import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_shop_app/Widgets/order_item_widget.dart';
import '/Provider/orders.dart';
import 'package:my_shop_app/Widgets/app_drawer.dart';

//optimistic updating : storing the old value and restoring it if an error occurs
class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders-screen';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future? _ordersFuture;
  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    super.initState();
    _ordersFuture = _obtainOrdersFuture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Orders')),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError) {
              return const Center(child: Text('An error occured !'));
            }
            return Consumer<Orders>(
              builder: (cx, orderItemData, child) => ListView.builder(
                itemCount: orderItemData.orders.length,
                itemBuilder: (context, index) => OrderItemWidget(
                  order: orderItemData.orders[index],
                ),
              ),
            );
          }
        },
      ),
      drawer: const AppDrawer(),
    );
  }
}
