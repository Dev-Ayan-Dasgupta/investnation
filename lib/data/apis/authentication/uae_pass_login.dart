import 'dart:convert';

import 'package:investnation/environment/index.dart';
import 'package:http/http.dart' as http;

class UaePassLogin {
  static Future<http.Response> uaePassLogin(Map<String, dynamic> body) async {
    try {
      return http.post(
        Uri.parse(Environment.uaePassLogin),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(body),
      );
    } catch (_) {
      rethrow;
    }
  }
}
