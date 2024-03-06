import 'dart:convert';

import 'package:investnation/data/apis/authentication/index.dart';
import 'package:http/http.dart' as http;

class MapUpdateRetailMobileNumber {
  static Future<Map<String, dynamic>> mapUpdateRetailMobileNumber(
      Map<String, dynamic> body) async {
    try {
      http.Response response =
          await UpdateRetailMobileNumber.updateRetailMobileNumber(body);
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
