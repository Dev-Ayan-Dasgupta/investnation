import 'dart:convert';
import 'dart:developer';

import 'package:investnation/data/apis/authentication/index.dart';
import 'package:http/http.dart' as http;

class MapUaePassLogin {
  static Future<Map<String, dynamic>> mapUaePassLogin(
      Map<String, dynamic> body) async {
    try {
      http.Response response = await UaePassLogin.uaePassLogin(body);
      log("mapAddNewDevice Status Code -> ${response.statusCode}");
      log("Response body -> ${response.body}");

      return jsonDecode(response.body);

      // if (response.statusCode == 200) {
      //   return jsonDecode(response.body);
      // } else if (response.statusCode == 401) {
      //   return {"timeout": "Your session has timed out."};
      // } else {
      //   return {"err": "Something went wrong, please try again later."};
      // }
    } catch (_) {
      rethrow;
    }
  }
}
