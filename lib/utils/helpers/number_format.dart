import 'package:intl/intl.dart';

class NumberFormatter {
  static String numberFormat(double number) {
    return number >= 1000
        ? NumberFormat('#,000.00').format(number)
        : number.toStringAsFixed(2);
  }
}
