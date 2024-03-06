import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:investnation/data/apis/referral/is_authorized_to_send_invitations.dart';

class MapAuthorizedToSendInvitations {
  static Future<Map<String, dynamic>> mapAuthorizedToSendInvitations() async {
    try {
      http.Response response =
          await IsAuthorizedToSendInvitations.isAuthorizedToSendInvitations();
      log("Status code authorized invitations -> ${response.statusCode}");
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        return {"timeout": "Your session has timed out."};
      } else {
        return {"err": "Something went wrong, please try again later."};
      }
    } catch (_) {
      rethrow;
    }
  }
}
