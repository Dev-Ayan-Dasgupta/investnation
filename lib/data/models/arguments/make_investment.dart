// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MakeInvestmentArgument {
  final String portfolio;
  final double amount;
  final double referralBonus;
  final bool isTopUp;
  MakeInvestmentArgument({
    required this.portfolio,
    required this.amount,
    required this.referralBonus,
    required this.isTopUp,
  });

  MakeInvestmentArgument copyWith({
    String? portfolio,
    double? amount,
    double? referralBonus,
    bool? isTopUp,
  }) {
    return MakeInvestmentArgument(
      portfolio: portfolio ?? this.portfolio,
      amount: amount ?? this.amount,
      referralBonus: referralBonus ?? this.referralBonus,
      isTopUp: isTopUp ?? this.isTopUp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'portfolio': portfolio,
      'amount': amount,
      'referralBonus': referralBonus,
      'isTopUp': isTopUp,
    };
  }

  factory MakeInvestmentArgument.fromMap(Map<String, dynamic> map) {
    return MakeInvestmentArgument(
      portfolio: map['portfolio'] as String,
      amount: map['amount'] as double,
      referralBonus: map['referralBonus'] as double,
      isTopUp: map['isTopUp'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory MakeInvestmentArgument.fromJson(String source) =>
      MakeInvestmentArgument.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MakeInvestmentArgument(portfolio: $portfolio, amount: $amount, referralBonus: $referralBonus, isTopUp: $isTopUp)';
  }

  @override
  bool operator ==(covariant MakeInvestmentArgument other) {
    if (identical(this, other)) return true;

    return other.portfolio == portfolio &&
        other.amount == amount &&
        other.referralBonus == referralBonus &&
        other.isTopUp == isTopUp;
  }

  @override
  int get hashCode {
    return portfolio.hashCode ^
        amount.hashCode ^
        referralBonus.hashCode ^
        isTopUp.hashCode;
  }
}
