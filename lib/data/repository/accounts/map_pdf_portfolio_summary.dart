import 'dart:convert';
import 'dart:developer';

import 'package:investnation/data/apis/accounts/index.dart';
import 'package:http/http.dart' as http;

class MapPDFPortfolioSummary {
  static Future<Map<String, dynamic>> mapPDFPortfolioSummary(
      Map<String, dynamic> body) async {
    try {
      http.Response response =
          await GetPDFPortfolioSummary.getPDFPortfolioSummary(body);
      log("getPDFPortfolioSummary Status Code -> ${response.statusCode}");
      return jsonDecode(response.body);
    } catch (_) {
      rethrow;
    }
  }
}
