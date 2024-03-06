// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BeneficiaryListArgumentModel {
  final bool isBeneficiary;
  BeneficiaryListArgumentModel({
    required this.isBeneficiary,
  });

  BeneficiaryListArgumentModel copyWith({
    bool? isBeneficiary,
  }) {
    return BeneficiaryListArgumentModel(
      isBeneficiary: isBeneficiary ?? this.isBeneficiary,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isBeneficiary': isBeneficiary,
    };
  }

  factory BeneficiaryListArgumentModel.fromMap(Map<String, dynamic> map) {
    return BeneficiaryListArgumentModel(
      isBeneficiary: map['isBeneficiary'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory BeneficiaryListArgumentModel.fromJson(String source) =>
      BeneficiaryListArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'BeneficiaryListArgumentModel(isBeneficiary: $isBeneficiary)';

  @override
  bool operator ==(covariant BeneficiaryListArgumentModel other) {
    if (identical(this, other)) return true;

    return other.isBeneficiary == isBeneficiary;
  }

  @override
  int get hashCode => isBeneficiary.hashCode;
}
