import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:investnation/data/apis/authentication/index.dart';

class MapDecrypt {
  static Future<Map<String, dynamic>> mapDecrypt(
      Map<String, dynamic> body) async {
    try {
      http.Response response = await Decrypt.decrypt(body);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
