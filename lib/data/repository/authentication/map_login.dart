import 'dart:convert';
import 'dart:developer';

import 'package:investnation/data/apis/authentication/index.dart';
import 'package:http/http.dart' as http;

class MapLogin {
  static Future<Map<String, dynamic>> mapLogin(
      Map<String, dynamic> body) async {
    try {
      http.Response response = await Login.login(body);

      log("Status Code login -> ${response.statusCode}");
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
