import 'dart:convert';

import 'package:investnation/data/apis/configurations/index.dart';
import 'package:http/http.dart' as http;

class MapPrivacyStatement {
  static Future<String> mapPrivacyStatement(Map<String, dynamic> body) async {
    try {
      http.Response response =
          await GetPrivacyStatement.getPrivacyStatement(body);
      return jsonDecode(response.body)["statement"];
    } catch (_) {
      rethrow;
    }
  }
}
