import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart';

const webapikey = 'AIzaSyBLsMl_60zUUiHUh-QO-3RDcM239AeEpuc';

class Auth extends ChangeNotifier {
  DateTime? _expiryDate;
  String? _token;
  String? _userId;
  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  void setParameters(Response httpresponse) {
    var response = jsonDecode(httpresponse.body);
    _token = response['idToken'];
    _userId = response['localId'];
    _expiryDate =
        DateTime.now().add(Duration(seconds: int.parse(response['expiresIn'])));
    notifyListeners();
  }

  Future<void> signup(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$webapikey');
    final httpresponse = await http.post(url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }));

    setParameters(httpresponse);
  }

  Future<void> login(String email, String password) async {
    var url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$webapikey');
    var httpresponse = await http.post(url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }));

    setParameters(httpresponse);
  }
}
