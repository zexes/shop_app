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

  Future<String> _urlBuilder(String action) async {
    final apiKey = await getApiKey();
    var sb = StringBuffer();
    sb.write(BASE_URL);
    sb.write(action);
    sb.write('?');
    sb.write(URL_KEY);
    sb.write('=');
    sb.write(apiKey);
    return sb.toString();
  }

  Future<void> authenticate(String email, String password, String url) async {
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            'password': password,
            "returnSecureToken": true
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    const action = 'signUp';
    final url = await _urlBuilder(action);

    return authenticate(email, password, url);
  }

  Future<void> signIn(String email, String password) async {
    const action = 'signInWithPassword';
    final url = await _urlBuilder(action);

    print(">>>>>>>>>>>>>>>>>$url");
    return authenticate(email, password, url);
  }

  Future<String> getApiKey() async {
    Secret sec = await SecretLoader(secretPath: "assets/secrets.json")
        .load(); // Future<Secret>
    print("key>>>>>>>>>>>>>>>>>>>>>: ${sec.apiKey}");
    return sec.apiKey;
  }
}
