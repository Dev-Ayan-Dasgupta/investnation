import 'package:http_interceptor/http_interceptor.dart';
import 'package:investnation/data/apis/interceptor_contract.dart';
import 'package:investnation/environment/index.dart';
import 'package:http/http.dart' as http;

class RenewToken {
  static Future<http.Response> renewToken() async {
    try {
      final appHttp = InterceptedClient.build(interceptors: [
        InvestNationInterceptor(),
      ]);

      return appHttp.post(
        Uri.parse(Environment.renewToken),
      );
    } catch (_) {
      rethrow;
    }
  }
}
