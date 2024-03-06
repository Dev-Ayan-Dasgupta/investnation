import 'dart:convert';
import 'dart:developer';

import 'package:investnation/data/apis/accounts/index.dart';
import 'package:http/http.dart' as http;

class MapPDFCustomerAccountStatement {
  static Future<Map<String, dynamic>> mapPDFCustomerAccountStatement(
      Map<String, dynamic> body) async {
    try {
      http.Response response =
          await GetPDFCustomerAccountStatement.getPDFCustomerAccountStatement(
              body);
      log("getPDFCustomerAccountStatement Status Code -> ${response.statusCode}");
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
