import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/model/secret.dart';
import 'package:shop_app/model/secret_loader.dart';
import '../model/http_exception.dart';

class Auth with ChangeNotifier {
  static const BASE_URL = 'https://identitytoolkit.googleapis.com/v1/accounts:';
  static const URL_KEY = 'key';

  String _token;
  DateTime _expiryDate;
  String _userId;
  String _emailFromResponse;
  Timer _authTimer;

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

  String get email {
    return _emailFromResponse;
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
      _emailFromResponse = responseData['email'] as String;
      if (responseData['error'] != null)
        throw HttpException(responseData['error']['message']);
//if no error
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String()
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
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

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;

    final extractedSavedData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedSavedData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) return false;

    _token = extractedSavedData['token'];
    _userId = extractedSavedData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
//    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) _authTimer.cancel();
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<String> get _apiKey async {
    Secret sec = await SecretLoader(secretPath: "assets/secrets.json")
        .load(); // Future<Secret>
    return sec.apiKey;
  }
}
