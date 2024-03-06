import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:investnation/data/apis/referral/create_referral_code.dart';

class MapCreateReferralCode {
  static Future<Map<String, dynamic>> mapCreateReferralCode() async {
    try {
      http.Response response = await CreateReferralCode.createReferralCode();
      //log("Status code customer details -> ${response.statusCode}");
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
