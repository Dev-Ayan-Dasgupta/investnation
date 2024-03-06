import 'dart:convert';
import 'dart:developer';

import 'package:investnation/data/apis/configurations/index.dart';
import 'package:http/http.dart' as http;

class MapAllCities {
  static Future<List> mapAllCities() async {
    try {
      http.Response response = await GetAllCities.getAllCities();
      log("status code -> ${response.statusCode}");
      return jsonDecode(response.body)["cities"];
    } catch (_) {
      rethrow;
    }
  }
}
