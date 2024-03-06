import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:investnation/bloc/index.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/data/models/widgets/index.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/screens/investmentCreation/index.dart';
import 'package:investnation/presentation/screens/redeemAndTopUp/index.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:investnation/utils/helpers/index.dart';

import '../../../../data/repository/onboarding/index.dart';

class RedemptionConfirmationScreen extends StatefulWidget {
  const RedemptionConfirmationScreen({super.key});

  @override
  State<RedemptionConfirmationScreen> createState() =>
      _RedemptionConfirmationScreenState();
}

class _RedemptionConfirmationScreenState
    extends State<RedemptionConfirmationScreen> {
  List<DetailsTileModel> redeemConfDets = [
    DetailsTileModel(
      key: "Details",
      value: "",
    ),
    DetailsTileModel(
      key: "Redemption Value",
      value: "AED ${NumberFormatter.numberFormat(redeemAmount)}",
    ),
    DetailsTileModel(
      key: "Redemption Fee",
      value: "AED ${redemptionFeePct * redeemAmount / 100}",
    ),
    DetailsTileModel(
      key: "Processing Time",
      value: "1 Business Day",
    ),
    DetailsTileModel(
      key: "Total",
      value:
          "AED ${(redeemAmount - (redemptionFeePct * redeemAmount / 100)) >= 1000 ? NumberFormat('#,000.00').format((redeemAmount - (redemptionFeePct * redeemAmount / 100))) : ((redeemAmount - (redemptionFeePct * redeemAmount / 100))).toStringAsFixed(2)}",
    ),
  ];

  bool isCheckBox1Selected = false;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
              child: SvgPicture.asset(
                ImageConstants.support,
                width: (50 / Dimensions.designWidth).w,
                height: (50 / Dimensions.designWidth).w,
              ),
            ),
          )
        ],
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
                    "Confirmation",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.dark100,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    portfolioBeingInvested.toTitleCase(),
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark80,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 10),
                  Expanded(
                    child: DetailsTile(
                      length: redeemConfDets.length,
                      details: redeemConfDets,
                      boldIndices: const [0, 4],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    BlocBuilder<CheckBoxBloc, CheckBoxState>(
                      builder: buildCheckBox1,
                    ),
                    const SizeBox(width: 5),
                    Row(
                      children: [
                        Text(
                          'I agree to the ',
                          style: TextStyles.primary.copyWith(
                            color: const Color.fromRGBO(0, 0, 0, 0.5),
                            fontSize: (14 / Dimensions.designWidth).w,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, Routes.termsAndConditions);
                          },
                          child: Text(
                            'Terms & Conditions',
                            style: TextStyles.primary.copyWith(
                              color: AppColors.primary80,
                              fontSize: (14 / Dimensions.designWidth).w,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizeBox(height: 15),
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    if (isCheckBox1Selected) {
                      return GradientButton(
                        onTap: () async {
                          if (!isLoading) {
                            ShowButtonBloc showButtonBloc =
                                context.read<ShowButtonBloc>();
                            isLoading = true;
                            showButtonBloc
                                .add(ShowButtonEvent(show: isLoading));

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
                                      emailOrPhone: storageMobileNumber ?? "",
                                      isEmail: false,
                                      isBusiness: false,
                                      isInitial: false,
                                      isLogin: false,
                                      isEmailIdUpdate: false,
                                      isMobileUpdate: false,
                                      isReKyc: false,
                                      isAddBeneficiary: false,
                                      isMakeTransfer: false,
                                      isMakeInvestment: false,
                                      isRedeem: true,
                                    ).toMap(),
                                  );
                                }
                              } else {
                                if (context.mounted) {
                                  showAdaptiveDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomDialog(
                                        svgAssetPath: ImageConstants.warning,
                                        title: "Sorry",
                                        message: sendMobOtpResult["message"] ??
                                            "There was an error sending OTP to your mobile. Please try again later.",
                                        actionWidget: GradientButton(
                                          onTap: () {
                                            Navigator.pop(context);
                                            // Navigator.pop(context);
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
                        text: "Redeem",
                        auxWidget:
                            isLoading ? const LoaderRow() : const SizeBox(),
                      );
                    } else {
                      return SolidButton(
                        onTap: () {},
                        text: "Redeem",
                      );
                    }
                  },
                ),
                SizeBox(
                  height: PaddingConstants.bottomPadding +
                      MediaQuery.paddingOf(context).bottom,
                ),
              ],
            ),
          ],
        ),
      ),
    );
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

  void triggerCheckBoxEvent(bool isChecked) {
    final CheckBoxBloc checkBoxBloc = context.read<CheckBoxBloc>();
    checkBoxBloc.add(CheckBoxEvent(isChecked: isChecked));
  }

  void triggerAllTrueEvent() {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    showButtonBloc.add(ShowButtonEvent(show: isCheckBox1Selected));
  }
}
