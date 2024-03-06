import 'dart:convert';

import 'package:investnation/environment/index.dart';
import 'package:http/http.dart' as http;

class Login {
  static Future<http.Response> login(Map<String, dynamic> body) async {
    try {
      return http.post(
        Uri.parse(Environment.login),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(body),
      );
    } catch (_) {
      rethrow;
    }
  }
}
