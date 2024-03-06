import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:investnation/data/apis/referral/get_referral_details.dart';

class MapReferralDetails {
  static Future<Map<String, dynamic>> mapReferralDetails() async {
    try {
      http.Response response = await GetReferralDetails.getReferralDetails();
      log("Status code referral details -> ${response.statusCode}");
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
