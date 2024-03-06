import 'dart:convert';
import 'dart:developer';

import 'package:investnation/data/apis/configurations/index.dart';
import 'package:http/http.dart' as http;

class MapFaqs {
  static Future<Map<String, dynamic>> mapFaqs() async {
    try {
      http.Response response = await GetFaqs.getFaqs();
      log("Faq status code -> ${response.statusCode}");
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"err": "Something went wrong"};
      }
    } catch (e) {
      log("Faq exception -> $e");
      rethrow;
    }
  }
}
