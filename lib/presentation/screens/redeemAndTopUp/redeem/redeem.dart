import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:investnation/bloc/index.dart';
import 'package:investnation/data/models/widgets/index.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/screens/investmentCreation/index.dart';
import 'package:investnation/presentation/screens/redeemAndTopUp/index.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:investnation/utils/helpers/index.dart';

class RedeemScreen extends StatefulWidget {
  const RedeemScreen({super.key});

  @override
  State<RedeemScreen> createState() => _RedeemScreenState();
}

double redeemAmount = 0.0;
double redemptionFee = 0;

class _RedeemScreenState extends State<RedeemScreen> {
  List<DetailsTileModel> redeemDetails = [
    DetailsTileModel(
      key: "Details",
      value: "",
    ),
    DetailsTileModel(
      key: "Portfolio Value",
      value: "AED ${NumberFormatter.numberFormat(marketValue)}",
    ),
    DetailsTileModel(
      key: "Processing Time",
      value: "1 Business Day",
    ),
  ];

  final TextEditingController _amountController =
      TextEditingController(text: "0.00");

  bool isValid = true;

  bool isEnabled = false;

  bool isCheckBox1Selected = false;

  bool isLoading = false;

  late int initLength;
  double redemptionAmount = 0;

  @override
  void initState() {
    super.initState();

    // Initially the length of _amountController.text will be held in a variable
    // if length of _amountController.text becomes more than this value, we will multiply the parsed _amountController.text amount by 10, else we will divide by 10
    initLength = _amountController.text.length;
    log("initLength -> $initLength");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
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
                    "Redeem",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.dark100,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 15),
                  Text(
                    portfolioBeingInvested.toTitleCase(),
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark80,
                      fontSize: (20 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 15),
                  Text(
                    "Your redemption amount will be debited from your portfolio.",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark80,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  SizeBox(height: (24 / Dimensions.designHeight).h),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          DetailsTile(
                            length: redeemDetails.length,
                            details: redeemDetails,
                            boldIndices: const [0],
                          ),
                          const SizeBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Redemption amount (AED)",
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.dark80,
                                  fontSize: (14 / Dimensions.designWidth).w,
                                ),
                              ),
                              SizeBox(height: (24 / Dimensions.designHeight).h),
                              BlocBuilder<ShowButtonBloc, ShowButtonState>(
                                builder: (context, state) {
                                  return CustomTextField(
                                    // hintText: "Eg. Multiples of AED 10",
                                    keyboardType: TextInputType.number,

                                    controller: _amountController,
                                    enabled: !isEnabled,
                                    borderColor: isValid ||
                                            _amountController.text == "0.00"
                                        ? const Color(0XFFEEEEEE)
                                        : AppColors.red100,
                                    onChanged: onSendChanged,
                                  );
                                },
                              ),
                              const SizeBox(height: 8),
                              BlocBuilder<ShowButtonBloc, ShowButtonState>(
                                builder: (context, state) {
                                  if (!isValid &&
                                      _amountController.text != "0.00") {
                                    return Row(
                                      children: [
                                        Icon(
                                          Icons.error_rounded,
                                          color: AppColors.red100,
                                          size: (12 / Dimensions.designWidth).w,
                                        ),
                                        const SizeBox(width: 5),
                                        Text(
                                          redemptionAmount > marketValue
                                              ? "The amount is greater than portfolio value"
                                              : "",
                                          style:
                                              TextStyles.primaryMedium.copyWith(
                                            color: AppColors.red100,
                                            fontSize:
                                                (12 / Dimensions.designWidth).w,
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return const SizeBox(height: 0);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
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
                              color: AppColors.yellow100,
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
                    if (isCheckBox1Selected &&
                        isValid &&
                        _amountController.text.isNotEmpty &&
                        redemptionAmount != 0) {
                      return GradientButton(
                        onTap: () async {
                          if (!isLoading) {
                            ShowButtonBloc showButtonBloc =
                                context.read<ShowButtonBloc>();
                            isLoading = true;
                            showButtonBloc
                                .add(ShowButtonEvent(show: isLoading));

                            if (redemptionFeePct > 0) {
                              showAdaptiveDialog(
                                context: context,
                                builder: (context) {
                                  return CustomDialog(
                                    svgAssetPath: ImageConstants.warning,
                                    title: "Are you sure?",
                                    message:
                                        "We need you to know that we have to charge you an Early redemption fee of ${redemptionFeePct.toStringAsFixed(0)}% on your redemption amount",
                                    auxWidget: GradientButton(
                                      onTap: () async {
                                        redeemAmount = double.parse(
                                            _amountController.text);
                                        redemptionFee = redeemAmount *
                                            redemptionFeePct /
                                            100;
                                        if (context.mounted) {
                                          Navigator.pushReplacementNamed(
                                            context,
                                            Routes.redemptionConfirmation,
                                          );
                                        }
                                      },
                                      text: "Redeem",
                                    ),
                                    actionWidget: SolidButton(
                                      color: Colors.white,
                                      fontColor: AppColors.dark100,
                                      boxShadow: [BoxShadows.primary],
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      text: "No, Go back",
                                    ),
                                  );
                                },
                              );
                            } else {
                              redeemAmount = redemptionAmount;
                              redemptionFee =
                                  redeemAmount * redemptionFeePct / 100;
                              if (context.mounted) {
                                Navigator.pushReplacementNamed(
                                  context,
                                  Routes.redemptionConfirmation,
                                );
                              }
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

  void onSendChanged(String p0) async {
    final ShowButtonBloc showProceedButtonBloc = context.read<ShowButtonBloc>();

    if (_amountController.text.length < initLength) {
      _amountController.text =
          (double.parse(_amountController.text.replaceAll(',', '')) / 10)
              .toStringAsFixed(2);
    } else {
      _amountController.text =
          (double.parse(_amountController.text.replaceAll(',', '')) * 10)
              .toStringAsFixed(2);
    }

    if (double.parse(_amountController.text.replaceAll(',', '')) >= 1000) {
      _amountController.text = NumberFormat('#,000.00')
          .format(double.parse(_amountController.text.replaceAll(',', '')));
    }
    _amountController.selection = TextSelection.fromPosition(
        TextPosition(offset: _amountController.text.length));

    initLength = _amountController.text.length;

    if (double.parse(_amountController.text.replaceAll(',', '')) >
            marketValue ||
        double.parse(_amountController.text.replaceAll(',', '')) == 0.00) {
      // ! abs()
      isValid = false;

      showProceedButtonBloc.add(ShowButtonEvent(show: isValid));
    } else {
      showProceedButtonBloc.add(ShowButtonEvent(show: isValid));
      isValid = true;
    }

    redemptionAmount = double.parse(_amountController.text.replaceAll(',', ''));
  }

  Widget buildTotalPortfolioSwitch(
      BuildContext context, ShowButtonState state) {
    final ShowButtonBloc isEnabledBloc = context.read<ShowButtonBloc>();
    return FlutterSwitch(
      width: (45 / Dimensions.designWidth).w,
      height: (25 / Dimensions.designHeight).h,
      activeColor: AppColors.green100,
      inactiveColor: AppColors.dark30,
      toggleSize: (15 / Dimensions.designWidth).w,
      value: isEnabled,
      onToggle: (val) {
        isEnabled = val;
        _amountController.text = marketValue.toString();
        isValid = true;
        isEnabledBloc.add(ShowButtonEvent(show: isEnabled));
      },
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

  Future<void> promptAreYouSure() async {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Are you sure?",
          message:
              "We need you to know that we have to charge you an Early redemption fee of ${redemptionFeePct.toStringAsFixed(0)}% on your redemption amount",
          auxWidget: GradientButton(
            onTap: () {
              redeemAmount = double.parse(_amountController.text);
              Navigator.pushReplacementNamed(
                context,
                Routes.redemptionConfirmation,
              );
            },
            text: "Redeem",
          ),
          actionWidget: SolidButton(
            color: Colors.white,
            fontColor: AppColors.dark100,
            boxShadow: [BoxShadows.primary],
            onTap: () {
              Navigator.pop(context);
            },
            text: "No, Go back",
          ),
        );
      },
    );
  }
}
