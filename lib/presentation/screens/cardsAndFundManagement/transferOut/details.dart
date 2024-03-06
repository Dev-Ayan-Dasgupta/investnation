// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:investnation/bloc/index.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/data/repository/onboarding/index.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/screens/common/index.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:investnation/utils/helpers/index.dart';

class TransferOutDetailsScreen extends StatefulWidget {
  const TransferOutDetailsScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<TransferOutDetailsScreen> createState() =>
      _TransferOutDetailsScreenState();
}

class _TransferOutDetailsScreenState extends State<TransferOutDetailsScreen> {
  final TextEditingController _transferController = TextEditingController();

  bool isValid = false;

  bool isSendingOtp = false;

  late TransferOutArgumentModel transferOutArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
  }

  void argumentInitialization() {
    transferOutArgument =
        TransferOutArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  @override
  Widget build(BuildContext context) {
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
                    "Transfer Out",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.dark100,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    "Transfer to",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark80,
                      fontSize: (14 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: (16 / Dimensions.designHeight).h,
                      horizontal: (16 / Dimensions.designWidth).w,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular((16 / Dimensions.designWidth).w)),
                      color: AppColors.dark5,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: (40 / Dimensions.designWidth).w,
                          height: (40 / Dimensions.designWidth).w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary100,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              ImageConstants.person,
                              width: (16 / Dimensions.designWidth).w,
                              height: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                        ),
                        const SizeBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                transferOutArgument.recipientname,
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.dark100,
                                  fontSize: (14 / Dimensions.designWidth).w,
                                ),
                              ),
                              const SizeBox(height: 5),
                              Text(
                                transferOutArgument.iban,
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.dark80,
                                  fontSize: (12 / Dimensions.designWidth).w,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    "Available Balance",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark80,
                      fontSize: (14 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: (16 / Dimensions.designHeight).h,
                      horizontal: (16 / Dimensions.designWidth).w,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular((16 / Dimensions.designWidth).w)),
                      color: AppColors.dark5,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "AED",
                          style: TextStyles.primaryMedium.copyWith(
                            color: AppColors.dark80,
                            fontSize: (24 / Dimensions.designWidth).w,
                          ),
                        ),
                        const SizeBox(width: 10),
                        Text(
                          NumberFormatter.numberFormat(currentBalance),
                          style: TextStyles.primaryBold.copyWith(
                            color: AppColors.dark100,
                            fontSize: (24 / Dimensions.designWidth).w,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    "Amount to transfer (AED)",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark80,
                      fontSize: (14 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 10),
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                      return CustomTextField(
                        keyboardType: TextInputType.number,
                        controller: _transferController,
                        borderColor: isValid || _transferController.text.isEmpty
                            ? const Color(0XFFEEEEEE)
                            : AppColors.red100,
                        onChanged: (p0) {
                          ShowButtonBloc showButtonBloc =
                              context.read<ShowButtonBloc>();
                          if (p0.isNotEmpty) {
                            if (double.parse(p0) > currentBalance ||
                                double.parse(p0) < 0 ||
                                p0.startsWith("-") ||
                                (p0.contains('.') &&
                                    p0.split('.').last.length > 2)) {
                              isValid = false;
                            } else {
                              isValid = true;
                            }
                          } else {
                            isValid = false;
                          }
                          showButtonBloc.add(ShowButtonEvent(show: isValid));
                        },
                      );
                    },
                  ),
                  const SizeBox(height: 10),
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                      if (!isValid && _transferController.text.isNotEmpty) {
                        return Row(
                          children: [
                            Text(
                              double.parse(_transferController.text) >
                                      currentBalance
                                  ? "Insufficient balance"
                                  : _transferController.text.startsWith("-")
                                      ? "Negative amount not allowed"
                                      : (_transferController.text
                                                  .contains('.') &&
                                              _transferController.text
                                                      .split('.')
                                                      .last
                                                      .length >
                                                  2)
                                          ? "Max 2 digits of decimal allowed"
                                          : "",
                              style: TextStyles.primaryMedium.copyWith(
                                color: AppColors.red100,
                                fontSize: (12 / Dimensions.designWidth).w,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const SizeBox();
                      }
                    },
                  ),
                ],
              ),
            ),
            Column(
              children: [
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    if (!isValid ||
                        _transferController.text.isEmpty ||
                        double.parse(_transferController.text) == 0) {
                      return SolidButton(
                        onTap: () {},
                        text: "Transfer Now",
                      );
                    } else {
                      return GradientButton(
                        onTap: () async {
                          if (!isSendingOtp) {
                            receiverAccountNumber = transferOutArgument.iban;
                            senderAmount =
                                double.parse(_transferController.text);
                            final ShowButtonBloc showButtonBloc =
                                context.read<ShowButtonBloc>();
                            isSendingOtp = true;
                            showButtonBloc
                                .add(ShowButtonEvent(show: isSendingOtp));
                            log("Send Mobile Otp Req -> ${{
                              "mobileNo": storageMobileNumber,
                            }}");
                            var sendMobOtpResult =
                                await MapSendMobileOtp.mapSendMobileOtp(
                              {
                                "mobileNo": storageMobileNumber,
                              },
                            );
                            log("sendMobOtpResult -> $sendMobOtpResult");
                            if (sendMobOtpResult["success"]) {
                              if (context.mounted) {
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
                                      isMakeTransfer: true,
                                      isMakeInvestment: false,
                                      isRedeem: false,
                                    ).toMap(),
                                  );
                                }
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
                            isSendingOtp = false;
                            showButtonBloc
                                .add(ShowButtonEvent(show: isSendingOtp));
                          }
                        },
                        text: "Transfer Now",
                        auxWidget:
                            isSendingOtp ? const LoaderRow() : const SizeBox(),
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

  @override
  void dispose() {
    _transferController.dispose();
    super.dispose();
  }
}
