// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TransactionDetailsArgumentModel {
  final String date;
  final String status;
  final String referenceNumber;
  final String amount;
  final String beneficiaryName;
  TransactionDetailsArgumentModel({
    required this.date,
    required this.status,
    required this.referenceNumber,
    required this.amount,
    required this.beneficiaryName,
  });

  TransactionDetailsArgumentModel copyWith({
    String? date,
    String? status,
    String? referenceNumber,
    String? amount,
    String? beneficiaryName,
  }) {
    return TransactionDetailsArgumentModel(
      date: date ?? this.date,
      status: status ?? this.status,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      amount: amount ?? this.amount,
      beneficiaryName: beneficiaryName ?? this.beneficiaryName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'status': status,
      'referenceNumber': referenceNumber,
      'amount': amount,
      'beneficiaryName': beneficiaryName,
    };
  }

  factory TransactionDetailsArgumentModel.fromMap(Map<String, dynamic> map) {
    return TransactionDetailsArgumentModel(
      date: map['date'] as String,
      status: map['status'] as String,
      referenceNumber: map['referenceNumber'] as String,
      amount: map['amount'] as String,
      beneficiaryName: map['beneficiaryName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionDetailsArgumentModel.fromJson(String source) =>
      TransactionDetailsArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TransactionDetailsArgumentModel(date: $date, status: $status, referenceNumber: $referenceNumber, amount: $amount, beneficiaryName: $beneficiaryName)';
  }

  @override
  bool operator ==(covariant TransactionDetailsArgumentModel other) {
    if (identical(this, other)) return true;

    return other.date == date &&
        other.status == status &&
        other.referenceNumber == referenceNumber &&
        other.amount == amount &&
        other.beneficiaryName == beneficiaryName;
  }

  @override
  int get hashCode {
    return date.hashCode ^
        status.hashCode ^
        referenceNumber.hashCode ^
        amount.hashCode ^
        beneficiaryName.hashCode;
  }
}
