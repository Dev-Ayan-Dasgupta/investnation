class FormatCardNumber {
  static String formatCardNumber(String cardNum) {
    String formattedCardNumber = "";

    for (var i = 0; i < cardNum.length; i++) {
      if (i % 4 == 3) {
        formattedCardNumber = "$formattedCardNumber${cardNum[i]} ";
      } else {
        formattedCardNumber = "$formattedCardNumber${cardNum[i]}";
      }
    }
    return formattedCardNumber;
  }
}
