import 'dart:convert';

import 'package:investnation/data/apis/accounts/index.dart';
import 'package:http/http.dart' as http;

class MapCreateBeneficiary {
  static Future<Map<String, dynamic>> mapCreateBeneficiary(
      Map<String, dynamic> body) async {
    try {
      http.Response response = await CreateBeneficiary.createBeneficiary(body);

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
