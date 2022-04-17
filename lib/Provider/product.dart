import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  Product({
    required this.title,
    required this.imageUrl,
    required this.id,
    required this.description,
    required this.price,
    this.isFavorite = false,
  });
  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        'https://flash-chat-94daf-default-rtdb.asia-southeast1.firebasedatabase.app/userFavories/$userId/$id.json?auth=$authToken');
    try {
      final response = await http.put(url,
          body: json.encode({
            'isFavorite': isFavorite,
          }));
      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      //server side errors
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
