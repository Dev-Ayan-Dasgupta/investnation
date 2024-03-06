import 'dart:convert';
import 'dart:developer';

import 'package:investnation/data/apis/configurations/index.dart';
import 'package:http/http.dart' as http;

class MapBankDetails {
  static Future<List> mapBankDetails() async {
    try {
      http.Response response = await GetBankDetails.getBankDetails();
      log("status code -> ${response.statusCode}");
      return jsonDecode(response.body)["banks"];
    } catch (_) {
      rethrow;
    }
  }
}
