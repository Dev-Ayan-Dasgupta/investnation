// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class InvestScreenArgumentModel {
  final bool isTopUp;
  final String fromForecast;
  InvestScreenArgumentModel({
    required this.isTopUp,
    required this.fromForecast,
  });

  InvestScreenArgumentModel copyWith({
    bool? isTopUp,
    String? fromForecast,
  }) {
    return InvestScreenArgumentModel(
      isTopUp: isTopUp ?? this.isTopUp,
      fromForecast: fromForecast ?? this.fromForecast,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isTopUp': isTopUp,
      'fromForecast': fromForecast,
    };
  }

  factory InvestScreenArgumentModel.fromMap(Map<String, dynamic> map) {
    return InvestScreenArgumentModel(
      isTopUp: map['isTopUp'] as bool,
      fromForecast: map['fromForecast'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory InvestScreenArgumentModel.fromJson(String source) =>
      InvestScreenArgumentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'InvestScreenArgumentModel(isTopUp: $isTopUp, fromForecast: $fromForecast)';

  @override
  bool operator ==(covariant InvestScreenArgumentModel other) {
    if (identical(this, other)) return true;

    return other.isTopUp == isTopUp && other.fromForecast == fromForecast;
  }

  @override
  int get hashCode => isTopUp.hashCode ^ fromForecast.hashCode;
}
