import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:investnation/data/apis/riskProfiling/index.dart';

class MapRiskProfile {
  static Future<Map<String, dynamic>> mapRiskProfile() async {
    try {
      http.Response response = await GetRiskProfile.getRiskProfile();
      log("Risk Profile Status Code -> ${response.statusCode}");

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
