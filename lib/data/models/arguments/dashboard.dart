// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DashboardArgumentModel {
  final int onboardingState;
  DashboardArgumentModel({
    required this.onboardingState,
  });

  DashboardArgumentModel copyWith({
    int? onboardingState,
  }) {
    return DashboardArgumentModel(
      onboardingState: onboardingState ?? this.onboardingState,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'onboardingState': onboardingState,
    };
  }

  factory DashboardArgumentModel.fromMap(Map<String, dynamic> map) {
    return DashboardArgumentModel(
      onboardingState: map['onboardingState'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory DashboardArgumentModel.fromJson(String source) =>
      DashboardArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DashboardArgumentModel(onboardingState: $onboardingState)';

  @override
  bool operator ==(covariant DashboardArgumentModel other) {
    if (identical(this, other)) return true;

    return other.onboardingState == onboardingState;
  }

  @override
  int get hashCode => onboardingState.hashCode;
}
