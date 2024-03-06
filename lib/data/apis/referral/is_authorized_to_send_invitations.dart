import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:investnation/data/apis/interceptor_contract.dart';
import 'package:investnation/environment/index.dart';
import 'package:http/http.dart' as http;

class IsAuthorizedToSendInvitations {
  static Future<http.Response> isAuthorizedToSendInvitations() async {
    try {
      final appHttp = InterceptedClient.build(interceptors: [
        InvestNationInterceptor(),
      ]);
      return appHttp.post(
        Uri.parse(Environment.isAuthorizedToSendInvitations),
      );
    } catch (_) {
      rethrow;
    }
  }
}
