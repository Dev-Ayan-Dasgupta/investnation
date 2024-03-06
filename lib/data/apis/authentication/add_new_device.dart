import 'dart:convert';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:investnation/data/apis/interceptor_contract.dart';
import 'package:investnation/environment/index.dart';
import 'package:http/http.dart' as http;

class AddNewDevice {
  static Future<http.Response> addNewDevice(Map<String, dynamic> body) async {
    try {
      final appHttp = InterceptedClient.build(interceptors: [
        InvestNationInterceptor(),
      ]);

      return appHttp.post(
        Uri.parse(Environment.addNewDevice),
        body: jsonEncode(body),
      );
    } catch (_) {
      rethrow;
    }
  }
}
