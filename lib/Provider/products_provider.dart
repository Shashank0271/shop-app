import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:my_shop_app/Provider/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  final String? authToken;
  final String? userId;
  Products(this.authToken, this.userId);
  List<Product> _items = [];
  List<Product> get items {
    return [..._items];
  }

  List<Product> get favorites {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProducts(bool filter) async {
    Uri url;
    if (filter) {
      url = Uri.parse(
          'https://flash-chat-94daf-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken&orderBy="userId"&equalTo="$userId"');
    } else {
      url = Uri.parse(
          'https://flash-chat-94daf-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken');
    }

    try {
      var response = await http.get(url);

      final extractedData = json.decode(response.body);
      // ignore: avoid_print
      print(extractedData);
      //this is a map with string as key and each value is a map with different product properties as keys
      if (extractedData == null ||
          (extractedData as Map<String, dynamic>).isEmpty) {
        _items = [];
        notifyListeners();
        return Future.value(null);
      }
      final surl = Uri.parse(
          'https://flash-chat-94daf-default-rtdb.asia-southeast1.firebasedatabase.app/userFavories/$userId.json?auth=$authToken');
      final httpfav = await http.get(surl);
      final favresponse = json.decode(httpfav.body);
      final List<Product> loadedProducts = [];

      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          title: prodData['title'],
          imageUrl: prodData['imageUrl'],
          id: prodId,
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: favresponse == null
              ? false
              : favresponse[prodId] == null
                  ? false
                  : favresponse[prodId]['isFavorite'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product value) async {
    final url = Uri.parse(
        'https://flash-chat-94daf-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': value.title,
          'id': value.id,
          'description': value.description,
          'price': value.price,
          'imageUrl': value.imageUrl,
          'userId': userId,
        }),
      );
      _items.add(Product(
        imageUrl: value.imageUrl,
        description: value.description,
        title: value.title,
        price: value.price,
        isFavorite: value.isFavorite,
        id: json.decode(response.body)['name'],

        ///the above is the database id
      ));
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product modifiedProduct) async {
    int modIndex = _items.indexWhere((element) => element.id == id);
    final url = Uri.parse(
        'https://flash-chat-94daf-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken');
    await http.patch(url,
        body: json.encode({
          'title': modifiedProduct.title,
          'description': modifiedProduct.description,
          'imageUrl': modifiedProduct.imageUrl,
          'price': modifiedProduct.price,
        }));
    _items[modIndex] = modifiedProduct; //in the local memory
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    var existingProductIndex = _items.indexWhere((element) => element.id == id);
    Product? existingProduct = _items[existingProductIndex];

    _items.removeWhere((element) => element.id == id);
    notifyListeners();

    final url = Uri.parse(
        'https://flash-chat-94daf-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken');
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      // ignore: prefer_const_constructors
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
  }
}
