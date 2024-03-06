import 'dart:convert';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:investnation/data/apis/interceptor_contract.dart';

import 'package:http/http.dart' as http;
import 'package:investnation/environment/index.dart';

class Decrypt {
  static Future<http.Response> decrypt(Map<String, dynamic> body) async {
    try {
      final appHttp = InterceptedClient.build(interceptors: [
        InvestNationInterceptor(),
      ]);
      return appHttp.post(
        Uri.parse(Environment.decrypt),
        body: jsonEncode(body),
      );
    } catch (_) {
      rethrow;
    }
  }
}
