import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  static const BASE_URL = 'https://identitytoolkit.googleapis.com/v1/accounts:';
  static const URL_KEY = 'key';
  static const KEY_VALUE = 'AIzaSyDOilA3DNA-EVQpp0jwsHuEw1qOnX5BuMk';

  String _token;
  DateTime _expiryDate;
  String _userId;

  String _urlBuilder(String action) {
    var sb = StringBuffer();
    sb.write(BASE_URL);
    sb.write(action);
    sb.write('?');
    sb.write(URL_KEY);
    sb.write('=');
    sb.write(KEY_VALUE);
    return sb.toString();
  }

  Future<void> authenticate(String email, String password, String url) async {
    final response = await http.post(url,
        body: json.encode(
            {"email": email, 'password': password, "returnSecureToken": true}));
    print(json.decode(response.body));
  }

  Future<void> signUp(String email, String password) async {
    const action = 'signUp';
    final url = _urlBuilder(action);

    return authenticate(email, password, url);
  }

  Future<void> signIn(String email, String password) async {
    const action = 'signInWithPassword';
    final url = _urlBuilder(action);

    return authenticate(email, password, url);
  }
}
