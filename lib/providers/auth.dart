import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/model/secret.dart';
import 'package:shop_app/model/secret_loader.dart';
import '../model/http_exception.dart';

class Auth with ChangeNotifier {
  static const BASE_URL = 'https://identitytoolkit.googleapis.com/v1/accounts:';
  static const URL_KEY = 'key';

  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) return _token;
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<String> _urlBuilder(String action) async {
    final apiKeyValue = await _apiKey;
    var sb = StringBuffer();
    sb.write(BASE_URL);
    sb.write(action);
    sb.write('?');
    sb.write(URL_KEY);
    sb.write('=');
    sb.write(apiKeyValue);
    return sb.toString();
  }

  Future<void> _authenticate(String email, String password, String url) async {
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            'password': password,
            "returnSecureToken": true
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null)
        throw HttpException(responseData['error']['message']);
//if no error
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
    } catch (error) {
      throw error;
    } finally {
      print('am here now');
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    const action = 'signUp';
    final url = await _urlBuilder(action);
    return _authenticate(email, password, url);
  }

  Future<void> signIn(String email, String password) async {
    const action = 'signInWithPassword';
    final url = await _urlBuilder(action);
    return _authenticate(email, password, url);
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    notifyListeners();
  }

  Future<String> get _apiKey async {
    Secret sec = await SecretLoader(secretPath: "assets/secrets.json")
        .load(); // Future<Secret>
    return sec.apiKey;
  }
}
