import 'dart:convert';
import 'dart:developer';

import 'package:investnation/data/apis/accounts/index.dart';
import 'package:http/http.dart' as http;

class MapCardFreeze {
  static Future<Map<String, dynamic>> mapCardFreeze(
      Map<String, dynamic> body) async {
    try {
      http.Response response = await CardFreeze.cardFreeze(body);
      log("Status Code CardFreeze -> ${response.statusCode}");
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        return {"timeout": "Your session has timed out."};
      } else {
        return {"err": "Something went wrong, please try again later."};
      }
    } catch (_) {
      rethrow;
    }
  }
}
