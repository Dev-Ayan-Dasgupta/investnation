// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PlanArgumentModel {
  final int planType;
  final bool isExplore;
  final int onboardingState;
  PlanArgumentModel({
    required this.planType,
    required this.isExplore,
    required this.onboardingState,
  });

  PlanArgumentModel copyWith({
    int? planType,
    bool? isExplore,
    int? onboardingState,
  }) {
    return PlanArgumentModel(
      planType: planType ?? this.planType,
      isExplore: isExplore ?? this.isExplore,
      onboardingState: onboardingState ?? this.onboardingState,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'planType': planType,
      'isExplore': isExplore,
      'onboardingState': onboardingState,
    };
  }

  factory PlanArgumentModel.fromMap(Map<String, dynamic> map) {
    return PlanArgumentModel(
      planType: map['planType'] as int,
      isExplore: map['isExplore'] as bool,
      onboardingState: map['onboardingState'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlanArgumentModel.fromJson(String source) =>
      PlanArgumentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PlanArgumentModel(planType: $planType, isExplore: $isExplore, onboardingState: $onboardingState)';

  @override
  bool operator ==(covariant PlanArgumentModel other) {
    if (identical(this, other)) return true;

    return other.planType == planType &&
        other.isExplore == isExplore &&
        other.onboardingState == onboardingState;
  }

  @override
  int get hashCode =>
      planType.hashCode ^ isExplore.hashCode ^ onboardingState.hashCode;
}
