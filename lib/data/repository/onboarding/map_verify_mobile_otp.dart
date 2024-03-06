import 'dart:convert';
import 'dart:developer';

import 'package:investnation/data/apis/onboarding/index.dart';
import 'package:http/http.dart' as http;

class MapVerifyMobileOtp {
  static Future<Map<String, dynamic>> mapVerifyMobileOtp(
      Map<String, dynamic> body) async {
    try {
      http.Response response = await VerifyMobileOtp.verifyMobileOtp(body);
      log("mobile verification response status -> ${response.statusCode}");
      log("response -> ${jsonDecode(response.body)}");

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
