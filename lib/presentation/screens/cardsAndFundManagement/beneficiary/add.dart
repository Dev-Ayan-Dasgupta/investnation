import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:investnation/bloc/showButton/index.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/data/repository/onboarding/index.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/screens/common/index.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:iban/iban.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class AddBeneficiaryScreen extends StatefulWidget {
  const AddBeneficiaryScreen({super.key});

  @override
  State<AddBeneficiaryScreen> createState() => _AddBeneficiaryScreenState();
}

class _AddBeneficiaryScreenState extends State<AddBeneficiaryScreen> {
  bool isProceed = false;
  bool isAccNumValid = true;

  bool showBankName = false;

  bool isFetchingCustDets = false;
  bool isSendingOtp = false;

  bool hasFoundBank = false;

  bool isShowTCCHelp = false;

  final TextEditingController _ibanController = TextEditingController();
  final TextEditingController _recipientNameController =
      TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();

  final JustTheController tooltipController = JustTheController();
  @override
  Widget build(BuildContext context) {
    final ShowButtonBloc proceedBloc = context.read<ShowButtonBloc>();
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
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
                    "Add Beneficiary",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.dark100,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  SizeBox(height: (44 / Dimensions.designHeight).h),
                  Row(
                    children: [
                      Text(
                        "Name",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark80,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                      ),
                      const Asterisk(),
                    ],
                  ),
                  SizeBox(height: (24 / Dimensions.designHeight).h),
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            hintText: "Enter Name",

                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[a-zA-Z ]"))
                            ],
                            // borderColor:
                            //     isAccNumValid || _ibanController.text.isEmpty
                            //         ? const Color(0xFFEEEEEE)
                            //         : AppColors.red100,
                            enabled: !hasFoundBank,
                            color: hasFoundBank
                                ? AppColors.dark5
                                : Colors.transparent,
                            controller: _recipientNameController,
                            onChanged: (p0) {
                              if (p0.isNotEmpty) {
                                isProceed = true;
                              } else {
                                isProceed = false;
                              }
                              benCustomerName = _recipientNameController.text;
                              proceedBloc.add(ShowButtonEvent(show: isProceed));
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  const SizeBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "IBAN",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark80,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                      ),
                      const Asterisk(),
                      const SizeBox(width: 5),
                      BlocBuilder<ShowButtonBloc, ShowButtonState>(
                        builder: buildTitleTooltip,
                      ),
                    ],
                  ),
                  const SizeBox(height: 10),
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            hintText: "Enter IBAN",
                            // keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[a-zA-Z0-9]"))
                            ],
                            borderColor: _ibanController.text.isEmpty
                                ? const Color(0xFFEEEEEE)
                                : (!isAccNumValid ||
                                        _ibanController.text == iban)
                                    ? AppColors.red100
                                    : const Color(0xFFEEEEEE),
                            enabled: !hasFoundBank,
                            color: hasFoundBank
                                ? AppColors.dark5
                                : Colors.transparent,
                            controller: _ibanController,
                            onChanged: (p0) {
                              // if (p0.length == 23) {
                              //   isAccNumValid = true;
                              // } else {
                              //   isAccNumValid = false;
                              // }
                              if (_ibanController.text.length >= 13) {
                                setState(() {
                                  isAccNumValid = isValid(_ibanController.text);
                                  log("isAccNumValid -> $isAccNumValid");
                                });
                              } else {
                                isAccNumValid = true;
                              }

                              receiverAccountNumber = _ibanController.text;
                              proceedBloc.add(ShowButtonEvent(show: isProceed));
                            },
                          ),
                          const SizeBox(height: 7),
                          Ternary(
                            condition:
                                isAccNumValid || _ibanController.text.isEmpty,
                            truthy: Ternary(
                                condition: _ibanController.text == iban,
                                truthy: Text(
                                  "You cannot enter your own IBAN",
                                  style: TextStyles.primaryMedium.copyWith(
                                    color: AppColors.red100,
                                    fontSize: (12 / Dimensions.designWidth).w,
                                  ),
                                ),
                                falsy: const SizeBox()),
                            falsy: Text(
                              "The IBAN entered is invalid. Please enter a valid IBAN",
                              style: TextStyles.primaryMedium.copyWith(
                                color: AppColors.red100,
                                fontSize: (12 / Dimensions.designWidth).w,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizeBox(height: 20),
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: buildBankName,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                  if (_ibanController.text.length >= 13 &&
                      _ibanController.text != iban &&
                      isAccNumValid &&
                      _recipientNameController.text.isNotEmpty) {
                    return GradientButton(
                      onTap: () async {
                        // ! validate iban

                        if (isValid(_ibanController.text)) {
                          setState(() {
                            isAccNumValid = true;
                            log("isAccNumValid -> $isAccNumValid");
                          });

                          final ShowButtonBloc showButtonBloc =
                              context.read<ShowButtonBloc>();
                          if (!isFetchingCustDets) {
                            if (!hasFoundBank) {
                              isFetchingCustDets = true;
                              showButtonBloc.add(
                                  ShowButtonEvent(show: isFetchingCustDets));

                              for (var bank in banks) {
                                if (_ibanController.text.substring(4, 7) ==
                                    bank["bankCode"]) {
                                  _bankNameController.text =
                                      "${bank["bankName"]} - ${bank["branchCode"]}";
                                  benBankCode = bank["branchCode"];
                                  benSwiftCode = bank["swiftCode"];
                                  benSwiftCodeRef = bank["swiftReference"];
                                  benBankName = bank["bankName"];
                                  hasFoundBank = true;
                                  break;
                                }
                              }

                              if (!hasFoundBank) {
                                showAdaptiveDialog(
                                  context: context,
                                  builder: (context) {
                                    return CustomDialog(
                                      svgAssetPath: ImageConstants.warning,
                                      title: "Sorry",
                                      message:
                                          "Could not find a bank related to this IBAN. Please check again.",
                                      actionWidget: GradientButton(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        text: "Okay",
                                      ),
                                    );
                                  },
                                );
                              } else {}

                              isFetchingCustDets = false;
                              showButtonBloc.add(
                                  ShowButtonEvent(show: isFetchingCustDets));
                            } else {
                              if (!isSendingOtp) {
                                isSendingOtp = true;
                                showButtonBloc
                                    .add(ShowButtonEvent(show: isSendingOtp));
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
                                          isAddBeneficiary: true,
                                          isMakeTransfer: false,
                                          isMakeInvestment: false,
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
                                                "There was an error sending OTP to your mobile, please try again later",
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

                                isSendingOtp = false;
                                showButtonBloc
                                    .add(ShowButtonEvent(show: isSendingOtp));
                              }
                            }
                          }
                        } else {
                          setState(() {
                            isAccNumValid = false;
                            log("isAccNumValid -> $isAccNumValid");
                          });
                        }
                      },
                      text: "Proceed",
                      auxWidget: isSendingOtp || isFetchingCustDets
                          ? const LoaderRow()
                          : const SizeBox(),
                    );
                  } else {
                    return SolidButton(
                      onTap: () {},
                      text: "Proceed",
                    );
                  }
                }),
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

  Widget buildBankName(BuildContext context, ShowButtonState state) {
    if (hasFoundBank) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bank Name",
            style: TextStyles.primaryMedium.copyWith(
              color: AppColors.dark80,
              fontSize: (14 / Dimensions.designWidth).w,
            ),
          ),
          const SizeBox(height: 10),
          CustomTextField(
            enabled: false,
            color: AppColors.dark5,
            controller: _bankNameController,
            onChanged: (p0) {},
          ),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  Widget buildTitleTooltip(BuildContext context, ShowButtonState state) {
    // final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    return const CustomTooltip(
      description: "International Bank\nAccount Number",
    );
  }

  @override
  void dispose() {
    _ibanController.dispose();
    _recipientNameController.dispose();
    _bankNameController.dispose();
    super.dispose();
  }
}
