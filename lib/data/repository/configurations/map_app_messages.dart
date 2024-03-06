import 'dart:convert';
import 'dart:developer';

import 'package:investnation/data/apis/configurations/index.dart';
import 'package:http/http.dart' as http;

class MapAppMessages {
  static Future<List> mapAppMessages(Map<String, dynamic> body) async {
    try {
      http.Response response = await GetAppMessages.getAppMessages(body);
      log("mapAppMessages status code -> ${response.statusCode}");
      return jsonDecode(response.body)["messages"];
    } catch (_) {
      rethrow;
    }
  }
}
