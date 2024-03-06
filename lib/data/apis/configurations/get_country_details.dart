import 'dart:convert';

import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:investnation/data/apis/interceptor_contract.dart';
import 'package:investnation/environment/index.dart';
import 'package:http/http.dart' as http;

class GetCountryDetails {
  static Future<http.Response> getCountryDetails(
      Map<String, dynamic> body) async {
    try {
      final appHttp = InterceptedClient.build(interceptors: [
        InvestNationInterceptor(),
      ]);
      return appHttp.post(
        Uri.parse(
          Environment.getCountryDetails,
        ),
        body: jsonEncode(body),
      );
    } catch (_) {
      rethrow;
    }
  }
}
