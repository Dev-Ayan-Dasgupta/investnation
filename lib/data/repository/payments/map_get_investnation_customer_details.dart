import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:investnation/data/apis/payments/index.dart';

class MapGetInvestnationCustomerDetails {
  static Future<Map<String, dynamic>> mapGetInvestnationCustomerDetails(
      Map<String, dynamic> body) async {
    try {
      http.Response response =
          await GetInvestnationCustomerDetails.getInvestnationCustomerDetails(
              body);

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
