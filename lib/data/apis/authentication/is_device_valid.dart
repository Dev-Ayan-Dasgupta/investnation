import 'dart:convert';

import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:investnation/data/apis/interceptor_contract.dart';
import 'package:investnation/environment/index.dart';
import 'package:http/http.dart' as http;
import 'package:investnation/main.dart';

class IsDeviceValid {
  static Future<http.Response> isDeviceValid(Map<String, dynamic> body) async {
    try {
      final appHttp = InterceptedClient.build(interceptors: [
        InvestNationInterceptor(),
      ]);

      return appHttp.post(
        Uri.parse(Environment.isDeviceValid),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${await storage.read(key: "token")}',
        },
        body: jsonEncode(body),
      );
    } catch (_) {
      rethrow;
    }
  }
}
