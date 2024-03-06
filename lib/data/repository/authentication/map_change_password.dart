// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:investnation/data/apis/authentication/index.dart';

class MapChangePassword {
  static Future<Map<String, dynamic>> mapChangePassword(
      Map<String, dynamic> body) async {
    try {
      http.Response response = await ChangePassword.changePassword(body);
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
