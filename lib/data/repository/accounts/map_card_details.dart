import 'dart:convert';
import 'dart:developer';

import 'package:investnation/data/apis/accounts/index.dart';
import 'package:http/http.dart' as http;

class MapCardDetails {
  static Future<Map<String, dynamic>> mapCardDetails() async {
    try {
      http.Response response = await GetCardDetails.getCardDetails();
      log("Status code card details -> ${response.statusCode}");
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
