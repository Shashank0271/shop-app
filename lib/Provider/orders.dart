import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  final String? authToken;
  final String? userId;
  Orders(this.authToken, this.userId);
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://flash-chat-94daf-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
    try {
      var resp = await http.get(url);
      var response = json.decode(resp.body) as Map<String, dynamic>;
      // if (response == null) {
      //   return;
      // }
      _orders = [];
      List<OrderItem> loadedOrders = [];

      for (var key in response.keys) {
        var loadedOrder = OrderItem(
          id: key,
          amount: response[key]!['amount'],
          products: (response[key]!['products']
                  as List<dynamic>) //a list of maps , i.e. (e) is a map
              .map(
                (e) => CartItem(
                  id: e['id'],
                  title: e['title'],
                  quantity: e['quantity'],
                  price: e['price'],
                ),
              )
              .toList(),
          dateTime: DateTime.parse(response[key]!['datetime']),
        );
        loadedOrders.add(loadedOrder);
      }
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      // print(error);
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://flash-chat-94daf-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
    final timeStamp = DateTime.now();
    await http.post(url,
        body: json.encode({
          'amount': total,
          'datetime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price,
                  })
              .toList(),
        }));
    _orders.insert(
      0,
      OrderItem(
        id: timeStamp.toString(),
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
