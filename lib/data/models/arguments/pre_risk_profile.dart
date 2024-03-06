// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PreRiskProfileArgumentModel {
  final bool isInitial;
  PreRiskProfileArgumentModel({
    required this.isInitial,
  });

  PreRiskProfileArgumentModel copyWith({
    bool? isInitial,
  }) {
    return PreRiskProfileArgumentModel(
      isInitial: isInitial ?? this.isInitial,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isInitial': isInitial,
    };
  }

  factory PreRiskProfileArgumentModel.fromMap(Map<String, dynamic> map) {
    return PreRiskProfileArgumentModel(
      isInitial: map['isInitial'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory PreRiskProfileArgumentModel.fromJson(String source) =>
      PreRiskProfileArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PreRiskProfileArgumentModel(isInitial: $isInitial)';

  @override
  bool operator ==(covariant PreRiskProfileArgumentModel other) {
    if (identical(this, other)) return true;

    return other.isInitial == isInitial;
  }

  @override
  int get hashCode => isInitial.hashCode;
}
