class ApplicationTaxState {
  final bool isUSCitizen;
  final bool isUSResident;
  final bool isPPonly;
  final bool isTINvalid;
  final bool isCRS;
  final bool hasTIN;
  ApplicationTaxState({
    required this.isUSCitizen,
    required this.isUSResident,
    required this.isPPonly,
    required this.isTINvalid,
    required this.isCRS,
    required this.hasTIN,
  });
}
