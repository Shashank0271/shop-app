import 'package:flutter/cupertino.dart';

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
  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
