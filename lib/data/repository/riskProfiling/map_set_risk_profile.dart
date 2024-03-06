import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:investnation/data/apis/riskProfiling/index.dart';

class MapSetRiskProfile {
  static Future<Map<String, dynamic>> mapSetRiskProfile(
      Map<String, dynamic> body) async {
    try {
      http.Response response = await SetRiskProfile.setRiskProfile(body);

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
