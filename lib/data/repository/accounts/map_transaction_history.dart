import 'dart:convert';
import 'dart:developer';

import 'package:investnation/data/apis/accounts/index.dart';
import 'package:http/http.dart' as http;

class MapTransactionHistory {
  static Future<Map<String, dynamic>> mapTransactionHistory(
      Map<String, dynamic> body) async {
    try {
      http.Response response =
          await GetTransactionHistory.getTransactionHistory(body);
      log("getTransactionHistory Status Code -> ${response.statusCode}");
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
