import 'dart:convert';
import 'dart:developer';

import 'package:investnation/data/apis/onboarding/index.dart';
import 'package:http/http.dart' as http;

class MapIfEidExists {
  static Future<bool> mapIfEidExists(Map<String, dynamic> body) async {
    try {
      http.Response response = await IfEidExists.ifEidExists(body);

      log("If EID Exists Status Code -> ${response.statusCode}");

      return jsonDecode(response.body)["exists"];
    } catch (_) {
      rethrow;
    }
  }
}
