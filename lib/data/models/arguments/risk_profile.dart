// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RiskProfileArgumentModel {
  final String riskProfile;
  final String desc;
  final bool isInitial;
  RiskProfileArgumentModel({
    required this.riskProfile,
    required this.desc,
    required this.isInitial,
  });

  RiskProfileArgumentModel copyWith({
    String? riskProfile,
    String? desc,
    bool? isInitial,
  }) {
    return RiskProfileArgumentModel(
      riskProfile: riskProfile ?? this.riskProfile,
      desc: desc ?? this.desc,
      isInitial: isInitial ?? this.isInitial,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'riskProfile': riskProfile,
      'desc': desc,
      'isInitial': isInitial,
    };
  }

  factory RiskProfileArgumentModel.fromMap(Map<String, dynamic> map) {
    return RiskProfileArgumentModel(
      riskProfile: map['riskProfile'] as String,
      desc: map['desc'] as String,
      isInitial: map['isInitial'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory RiskProfileArgumentModel.fromJson(String source) =>
      RiskProfileArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'RiskProfileArgumentModel(riskProfile: $riskProfile, desc: $desc, isInitial: $isInitial)';

  @override
  bool operator ==(covariant RiskProfileArgumentModel other) {
    if (identical(this, other)) return true;

    return other.riskProfile == riskProfile &&
        other.desc == desc &&
        other.isInitial == isInitial;
  }

  @override
  int get hashCode => riskProfile.hashCode ^ desc.hashCode ^ isInitial.hashCode;
}
