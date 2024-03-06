import 'dart:convert';
import 'dart:developer';

import 'package:investnation/data/apis/configurations/index.dart';
import 'package:http/http.dart' as http;

class MapAllCountries {
  static Future<List> mapAllCountries() async {
    try {
      http.Response response = await GetAllCountries.getAllCountries();
      log("mapAllCountries status code -> ${response.statusCode}");
      return jsonDecode(response.body)["dhabiCountries"];
    } catch (_) {
      rethrow;
    }
  }
}
