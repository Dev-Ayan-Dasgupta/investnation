import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:investnation/data/apis/investment/index.dart';

class MapPortfolioAllocationDetails {
  static Future<Map<String, dynamic>> mapPortfolioAllocationDetails(
    Map<String, dynamic> body,
  ) async {
    try {
      http.Response response =
          await PortfolioAllocationDetails.portfolioAllocationDetails(
        body,
      );
      log("createInvestment status code -> ${response.statusCode}");
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
