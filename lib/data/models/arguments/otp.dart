// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OTPArgumentModel {
  final String emailOrPhone;
  final bool isEmail;
  final bool isBusiness;
  final bool isInitial;
  final bool isLogin;
  final bool isEmailIdUpdate;
  final bool isMobileUpdate;
  final bool isReKyc;
  final bool isAddBeneficiary;
  final bool isMakeTransfer;
  final bool isMakeInvestment;
  final bool isRedeem;
  OTPArgumentModel({
    required this.emailOrPhone,
    required this.isEmail,
    required this.isBusiness,
    required this.isInitial,
    required this.isLogin,
    required this.isEmailIdUpdate,
    required this.isMobileUpdate,
    required this.isReKyc,
    required this.isAddBeneficiary,
    required this.isMakeTransfer,
    required this.isMakeInvestment,
    required this.isRedeem,
  });

  OTPArgumentModel copyWith({
    String? emailOrPhone,
    bool? isEmail,
    bool? isBusiness,
    bool? isInitial,
    bool? isLogin,
    bool? isEmailIdUpdate,
    bool? isMobileUpdate,
    bool? isReKyc,
    bool? isAddBeneficiary,
    bool? isMakeTransfer,
    bool? isMakeInvestment,
    bool? isRedeem,
  }) {
    return OTPArgumentModel(
      emailOrPhone: emailOrPhone ?? this.emailOrPhone,
      isEmail: isEmail ?? this.isEmail,
      isBusiness: isBusiness ?? this.isBusiness,
      isInitial: isInitial ?? this.isInitial,
      isLogin: isLogin ?? this.isLogin,
      isEmailIdUpdate: isEmailIdUpdate ?? this.isEmailIdUpdate,
      isMobileUpdate: isMobileUpdate ?? this.isMobileUpdate,
      isReKyc: isReKyc ?? this.isReKyc,
      isAddBeneficiary: isAddBeneficiary ?? this.isAddBeneficiary,
      isMakeTransfer: isMakeTransfer ?? this.isMakeTransfer,
      isMakeInvestment: isMakeInvestment ?? this.isMakeInvestment,
      isRedeem: isRedeem ?? this.isRedeem,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'emailOrPhone': emailOrPhone,
      'isEmail': isEmail,
      'isBusiness': isBusiness,
      'isInitial': isInitial,
      'isLogin': isLogin,
      'isEmailIdUpdate': isEmailIdUpdate,
      'isMobileUpdate': isMobileUpdate,
      'isReKyc': isReKyc,
      'isAddBeneficiary': isAddBeneficiary,
      'isMakeTransfer': isMakeTransfer,
      'isMakeInvestment': isMakeInvestment,
      'isRedeem': isRedeem,
    };
  }

  factory OTPArgumentModel.fromMap(Map<String, dynamic> map) {
    return OTPArgumentModel(
      emailOrPhone: map['emailOrPhone'] as String,
      isEmail: map['isEmail'] as bool,
      isBusiness: map['isBusiness'] as bool,
      isInitial: map['isInitial'] as bool,
      isLogin: map['isLogin'] as bool,
      isEmailIdUpdate: map['isEmailIdUpdate'] as bool,
      isMobileUpdate: map['isMobileUpdate'] as bool,
      isReKyc: map['isReKyc'] as bool,
      isAddBeneficiary: map['isAddBeneficiary'] as bool,
      isMakeTransfer: map['isMakeTransfer'] as bool,
      isMakeInvestment: map['isMakeInvestment'] as bool,
      isRedeem: map['isRedeem'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory OTPArgumentModel.fromJson(String source) =>
      OTPArgumentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OTPArgumentModel(emailOrPhone: $emailOrPhone, isEmail: $isEmail, isBusiness: $isBusiness, isInitial: $isInitial, isLogin: $isLogin, isEmailIdUpdate: $isEmailIdUpdate, isMobileUpdate: $isMobileUpdate, isReKyc: $isReKyc, isAddBeneficiary: $isAddBeneficiary, isMakeTransfer: $isMakeTransfer, isMakeInvestment: $isMakeInvestment, isRedeem: $isRedeem)';
  }

  @override
  bool operator ==(covariant OTPArgumentModel other) {
    if (identical(this, other)) return true;

    return other.emailOrPhone == emailOrPhone &&
        other.isEmail == isEmail &&
        other.isBusiness == isBusiness &&
        other.isInitial == isInitial &&
        other.isLogin == isLogin &&
        other.isEmailIdUpdate == isEmailIdUpdate &&
        other.isMobileUpdate == isMobileUpdate &&
        other.isReKyc == isReKyc &&
        other.isAddBeneficiary == isAddBeneficiary &&
        other.isMakeTransfer == isMakeTransfer &&
        other.isMakeInvestment == isMakeInvestment &&
        other.isRedeem == isRedeem;
  }

  @override
  int get hashCode {
    return emailOrPhone.hashCode ^
        isEmail.hashCode ^
        isBusiness.hashCode ^
        isInitial.hashCode ^
        isLogin.hashCode ^
        isEmailIdUpdate.hashCode ^
        isMobileUpdate.hashCode ^
        isReKyc.hashCode ^
        isAddBeneficiary.hashCode ^
        isMakeTransfer.hashCode ^
        isMakeInvestment.hashCode ^
        isRedeem.hashCode;
  }
}
