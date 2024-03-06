import 'dart:convert';

import 'package:investnation/data/apis/configurations/index.dart';
import 'package:http/http.dart' as http;

class MapDropdownLists {
  static Future<List> mapDropdownLists(Map<String, dynamic> body) async {
    try {
      http.Response response = await GetDropdownLists.getDropdownLists(body);
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
