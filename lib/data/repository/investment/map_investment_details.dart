import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:investnation/data/apis/investment/get_investment_details.dart';

class MapInvestmentDetails {
  static Future<Map<String, dynamic>> mapInvestmentDetails() async {
    try {
      http.Response response =
          await GetInvestmentDetails.getInvestmentDetails();
      log("Status inv card details -> ${response.statusCode}");
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
