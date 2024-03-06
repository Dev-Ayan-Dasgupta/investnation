// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class InvestmentDetailsArgumentModel {
  final String date;
  final String status;
  final String transactionType;
  final String portfolio;
  final String? referenceNumber;
  final String amount;

  InvestmentDetailsArgumentModel({
    required this.date,
    required this.status,
    required this.transactionType,
    required this.portfolio,
    required this.referenceNumber,
    required this.amount,
  });

  InvestmentDetailsArgumentModel copyWith({
    String? date,
    String? status,
    String? transactionType,
    String? portfolio,
    String? referenceNumber,
    String? amount,
  }) {
    return InvestmentDetailsArgumentModel(
      date: date ?? this.date,
      status: status ?? this.status,
      transactionType: transactionType ?? this.transactionType,
      portfolio: portfolio ?? this.portfolio,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'status': status,
      'transactionType': transactionType,
      'portfolio': portfolio,
      'referenceNumber': referenceNumber,
      'amount': amount,
    };
  }

  factory InvestmentDetailsArgumentModel.fromMap(Map<String, dynamic> map) {
    return InvestmentDetailsArgumentModel(
      date: map['date'] as String,
      status: map['status'] as String,
      transactionType: map['transactionType'] as String,
      portfolio: map['portfolio'] as String,
      referenceNumber: map['referenceNumber'] != null
          ? map['referenceNumber'] as String
          : null,
      amount: map['amount'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory InvestmentDetailsArgumentModel.fromJson(String source) =>
      InvestmentDetailsArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'InvestmentDetailsArgumentModel(date: $date, status: $status, transactionType: $transactionType, portfolio: $portfolio, referenceNumber: $referenceNumber, amount: $amount)';
  }

  @override
  bool operator ==(covariant InvestmentDetailsArgumentModel other) {
    if (identical(this, other)) return true;

    return other.date == date &&
        other.status == status &&
        other.transactionType == transactionType &&
        other.portfolio == portfolio &&
        other.referenceNumber == referenceNumber &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    return date.hashCode ^
        status.hashCode ^
        transactionType.hashCode ^
        portfolio.hashCode ^
        referenceNumber.hashCode ^
        amount.hashCode;
  }
}
