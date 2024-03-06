import 'package:clevertap_plugin/clevertap_plugin.dart';

class GenerateCleverTapJson {
  static generateCleverTapJson(
      String name, String identity, String email, String phone, String dob) {
    if (phone == "") {
      return {
        'Email': email,
      };
    } else if (name == "" || identity == "" || dob == "") {
      return {
        'Email': email,
        'Phone': phone,
      };
    } else {
      return {
        'Name': name,
        'Identity': identity,
        'Email': email,
        'Phone': phone,
        'dob': CleverTapPlugin.getCleverTapDate(DateTime.parse(dob)),
      };
    }
  }
}
