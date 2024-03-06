import 'dart:convert';
import 'dart:developer';

import 'package:investnation/data/apis/configurations/get_app_labels.dart';
import 'package:http/http.dart' as http;

class MapAppLabels {
  static Future<List> mapAppLabels(Map<String, dynamic> body) async {
    try {
      http.Response response = await GetAppLabels.getAppLabels(body);
      log("status code -> ${response.statusCode}");
      return jsonDecode(response.body)["labels"];
    } catch (e) {
      log("App Labels Exception -> $e");
      rethrow;
    }
  }
}
