// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TransferOutArgumentModel {
  final String recipientname;
  final String iban;
  TransferOutArgumentModel({
    required this.recipientname,
    required this.iban,
  });

  TransferOutArgumentModel copyWith({
    String? recipientname,
    String? iban,
  }) {
    return TransferOutArgumentModel(
      recipientname: recipientname ?? this.recipientname,
      iban: iban ?? this.iban,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'recipientname': recipientname,
      'iban': iban,
    };
  }

  factory TransferOutArgumentModel.fromMap(Map<String, dynamic> map) {
    return TransferOutArgumentModel(
      recipientname: map['recipientname'] as String,
      iban: map['iban'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransferOutArgumentModel.fromJson(String source) =>
      TransferOutArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TransferOutArgumentModel(recipientname: $recipientname, iban: $iban)';

  @override
  bool operator ==(covariant TransferOutArgumentModel other) {
    if (identical(this, other)) return true;

    return other.recipientname == recipientname && other.iban == iban;
  }

  @override
  int get hashCode => recipientname.hashCode ^ iban.hashCode;
}
