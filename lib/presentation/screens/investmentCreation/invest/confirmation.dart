// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:investnation/bloc/index.dart';
import 'package:investnation/data/models/widgets/index.dart';
import 'package:investnation/data/repository/investment/index.dart';
import 'package:investnation/data/repository/onboarding/index.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/screens/investmentCreation/index.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:investnation/utils/helpers/index.dart';

import '../../../../data/models/arguments/index.dart';

class InvestmentConfirmationScreen extends StatefulWidget {
  const InvestmentConfirmationScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<InvestmentConfirmationScreen> createState() =>
      _InvestmentConfirmationScreenState();
}

double amountBeingInvested = 0;
double referralBonusInvested = 0;

class _InvestmentConfirmationScreenState
    extends State<InvestmentConfirmationScreen> {
  List<DetailsTileModel> investmentDetails = [];

  bool isCheckBox1Selected = false;
  bool isCheckBox2Selected = false;

  bool isLoading = false;

  late MakeInvestmentArgument makeInvestmentArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    populateInvestmentDetails();
  }

  void argumentInitialization() {
    makeInvestmentArgument =
        MakeInvestmentArgument.fromMap(widget.argument as dynamic ?? {});
  }

  void populateInvestmentDetails() {
    investmentDetails.add(
      DetailsTileModel(key: "Details", value: ""),
    );
    investmentDetails.add(
      DetailsTileModel(
          key: makeInvestmentArgument.isTopUp
              ? "Top up amount"
              : "Investment Amount",
          value:
              "AED ${NumberFormatter.numberFormat(makeInvestmentArgument.amount)}"),
    );
    investmentDetails.add(
      DetailsTileModel(
          key: "Referral Bonus",
          value:
              "AED ${NumberFormatter.numberFormat(makeInvestmentArgument.referralBonus)}"),
    );
    investmentDetails.add(
      DetailsTileModel(
          key: "Total Investment",
          value:
              "AED ${NumberFormatter.numberFormat(makeInvestmentArgument.amount + makeInvestmentArgument.referralBonus)}"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        actions: [
          InkWell(
            onTap: () {
              ShowFaqSmile.showFaqSmile(context);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (16 / Dimensions.designWidth).w,
                vertical: (5 / Dimensions.designWidth).w,
              ),
              child: SvgPicture.asset(ImageConstants.support),
            ),
          ),
          const SizeBox(width: PaddingConstants.horizontalPadding),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Confirmation for ${portfolioBeingInvested.toTitleCase()}",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.dark100,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    "Let's get the most out of your investment!",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark80,
                      fontSize: (14 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Expanded(
                    child: DetailsTile(
                      length: investmentDetails.length,
                      details: investmentDetails,
                      boldIndices: const [0, 3],
                    ),
                  ),
                  // const SizeBox(height: 450),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    BlocBuilder<CheckBoxBloc, CheckBoxState>(
                      builder: buildCheckBox2,
                    ),
                    const SizeBox(width: 5),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, Routes.termsAndConditions);
                        },
                        child: RichText(
                          text: TextSpan(
                            text:
                                "I have read and understood the product details. I'm ready to invest and agree to the ",
                            style: TextStyles.primaryMedium.copyWith(
                              fontSize: (12 / Dimensions.designWidth).w,
                              color: AppColors.dark80,
                            ),
                            children: [
                              TextSpan(
                                text: "Terms & Conditions",
                                style: TextStyles.primaryMedium.copyWith(
                                  fontSize: (12 / Dimensions.designWidth).w,
                                  color: AppColors.primary100,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizeBox(height: 15),
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    if (isCheckBox2Selected) {
                      return GradientButton(
                        onTap: () async {
                          portfolioBeingInvested =
                              makeInvestmentArgument.portfolio;
                          log("portfolioBeingInvested -> $portfolioBeingInvested");
                          amountBeingInvested = makeInvestmentArgument.amount +
                              makeInvestmentArgument.referralBonus;
                          if (!isLoading) {
                            ShowButtonBloc showButtonBloc =
                                context.read<ShowButtonBloc>();
                            isLoading = true;
                            showButtonBloc
                                .add(ShowButtonEvent(show: isLoading));

                            log("checkDailyInvLimit Req -> ${{
                              "portfolio": makeInvestmentArgument.portfolio,
                              "amount": makeInvestmentArgument.amount,
                              "referralBonus":
                                  makeInvestmentArgument.referralBonus,
                            }}");

                            try {
                              var checkDailyInvLimitRes =
                                  await MapCheckDailyInvLimit
                                      .mapCheckDailyInvLimit(
                                {
                                  "portfolio": makeInvestmentArgument.portfolio,
                                  "amount": makeInvestmentArgument.amount,
                                  "referralBonus":
                                      makeInvestmentArgument.referralBonus,
                                },
                              );

                              log("checkDailyInvLimitRes -> $checkDailyInvLimitRes");
                              if (checkDailyInvLimitRes["success"]) {
                                if (context.mounted) {
                                  log("Send Mobile Otp Req -> ${{
                                    "mobileNo": storageMobileNumber,
                                  }}");
                                  try {
                                    var sendMobOtpResult =
                                        await MapSendMobileOtp.mapSendMobileOtp(
                                      {
                                        "mobileNo": storageMobileNumber,
                                      },
                                    );
                                    log("sendMobOtpResult -> $sendMobOtpResult");
                                    if (sendMobOtpResult["success"]) {
                                      if (context.mounted) {
                                        Navigator.pushNamed(
                                          context,
                                          Routes.otp,
                                          arguments: OTPArgumentModel(
                                            emailOrPhone:
                                                storageMobileNumber ?? "",
                                            isEmail: false,
                                            isBusiness: false,
                                            isInitial: false,
                                            isLogin: false,
                                            isEmailIdUpdate: false,
                                            isMobileUpdate: false,
                                            isReKyc: false,
                                            isAddBeneficiary: false,
                                            isMakeTransfer: false,
                                            isMakeInvestment: true,
                                            isRedeem: false,
                                          ).toMap(),
                                        );
                                      }
                                    } else {
                                      if (context.mounted) {
                                        showAdaptiveDialog(
                                          context: context,
                                          builder: (context) {
                                            return CustomDialog(
                                              svgAssetPath:
                                                  ImageConstants.warning,
                                              title: "Sorry",
                                              message: sendMobOtpResult[
                                                      "message"] ??
                                                  "There was an error sending OTP to your mobile. Please try again later.",
                                              actionWidget: GradientButton(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                text: "Okay",
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    }
                                  } catch (e) {
                                    log(e.toString());
                                  }
                                }
                              } else {
                                if (context.mounted) {
                                  showAdaptiveDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomDialog(
                                        svgAssetPath: ImageConstants.warning,
                                        title: "Limit Exceeded",
                                        message: checkDailyInvLimitRes[
                                                "message"] ??
                                            "You have exceeded the daily investment limit.",
                                        actionWidget: GradientButton(
                                          onTap: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                          text: "Okay",
                                        ),
                                      );
                                    },
                                  );
                                }
                              }
                            } catch (e) {
                              log(e.toString());
                            }

                            isLoading = false;
                            showButtonBloc
                                .add(ShowButtonEvent(show: isLoading));
                          }
                        },
                        text: "Invest",
                        auxWidget:
                            isLoading ? const LoaderRow() : const SizeBox(),
                      );
                    } else {
                      return SolidButton(
                        onTap: () {},
                        text: "Invest",
                      );
                    }
                  },
                ),
                SizeBox(
                  height: PaddingConstants.bottomPadding +
                      MediaQuery.paddingOf(context).bottom,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void triggerCheckBoxEvent(bool isChecked) {
    final CheckBoxBloc checkBoxBloc = context.read<CheckBoxBloc>();
    checkBoxBloc.add(CheckBoxEvent(isChecked: isChecked));
  }

  Widget buildCheckBox1(BuildContext context, CheckBoxState state) {
    if (isCheckBox1Selected) {
      return InkWell(
        onTap: () {
          isCheckBox1Selected = false;
          triggerCheckBoxEvent(isCheckBox1Selected);
          triggerAllTrueEvent();
        },
        child: Padding(
          padding: EdgeInsets.all((5 / Dimensions.designWidth).w),
          child: SvgPicture.asset(
            ImageConstants.checkedBox,
            width: (14 / Dimensions.designWidth).w,
            height: (14 / Dimensions.designWidth).w,
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          isCheckBox1Selected = true;
          triggerCheckBoxEvent(isCheckBox1Selected);
          triggerAllTrueEvent();
        },
        child: Padding(
          padding: EdgeInsets.all((5 / Dimensions.designWidth).w),
          child: SvgPicture.asset(
            ImageConstants.uncheckedBox,
            width: (14 / Dimensions.designWidth).w,
            height: (14 / Dimensions.designWidth).w,
          ),
        ),
      );
    }
  }

  Widget buildCheckBox2(BuildContext context, CheckBoxState state) {
    if (isCheckBox2Selected) {
      return InkWell(
        onTap: () {
          isCheckBox2Selected = false;
          triggerCheckBoxEvent(isCheckBox2Selected);
          triggerAllTrueEvent();
        },
        child: Padding(
          padding: EdgeInsets.all((5 / Dimensions.designWidth).w),
          child: SvgPicture.asset(
            ImageConstants.checkedBox,
            width: (14 / Dimensions.designWidth).w,
            height: (14 / Dimensions.designWidth).w,
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          isCheckBox2Selected = true;
          triggerCheckBoxEvent(isCheckBox2Selected);
          triggerAllTrueEvent();
        },
        child: Padding(
          padding: EdgeInsets.all((5 / Dimensions.designWidth).w),
          child: SvgPicture.asset(
            ImageConstants.uncheckedBox,
            width: (14 / Dimensions.designWidth).w,
            height: (14 / Dimensions.designWidth).w,
          ),
        ),
      );
    }
  }

  void triggerAllTrueEvent() {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    showButtonBloc
        .add(ShowButtonEvent(show: isCheckBox1Selected && isCheckBox2Selected));
  }
}
