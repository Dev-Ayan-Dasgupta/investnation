// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:investnation/bloc/index.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/data/models/widgets/index.dart';
import 'package:investnation/data/repository/referral/index.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/screens/common/index.dart';
import 'package:investnation/presentation/screens/investmentCreation/index.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:investnation/utils/helpers/index.dart';

class InvestScreen extends StatefulWidget {
  const InvestScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<InvestScreen> createState() => _InvestScreenState();
}

bool isTopUp = false;

class _InvestScreenState extends State<InvestScreen> {
  List<DetailsTileModel> criteriaDetails = [
    // DetailsTileModel(key: "Criteria", value: ""),
    DetailsTileModel(
      key: "Minimum limit",
      value: "AED ${NumberFormatter.numberFormat(forecastMinLimit)}",
    ),
    DetailsTileModel(
      key: "Maximum limit",
      value: "AED ${NumberFormatter.numberFormat(forecastMaxLimit)}",
    ),
  ];

  late TextEditingController _amountController;

  bool isValid = true;

  bool isFetchingBonus = false;

  late int initLength;
  double investmentAmount = 0;

  late InvestScreenArgumentModel investScreenArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
  }

  void argumentInitialization() {
    investScreenArgument =
        InvestScreenArgumentModel.fromMap(widget.argument as dynamic ?? {});
    isTopUp = investScreenArgument.isTopUp;
    _amountController = TextEditingController(
      text: investScreenArgument.fromForecast.isEmpty
          ? "0.00"
          : NumberFormatter.numberFormat(
              double.parse(investScreenArgument.fromForecast)),
    );
    investmentAmount = double.parse(_amountController.text.replaceAll(',', ''));

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
        actions: [
          InkWell(
            onTap: () {
              ShowFaqSmile.showFaqSmile(context);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (5 / Dimensions.designWidth).w,
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
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    investScreenArgument.isTopUp ? "Top Up" : "Invest",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.dark100,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 10),
                  Text(
                    "${portfolioBeingInvested.toTitleCase()} Portfolio",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark80,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 10),
                  Text(
                    "Enter the amount you wish to invest",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark80,
                      fontSize: (14 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 10),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DetailsTile(
                          length: criteriaDetails.length,
                          details: criteriaDetails,
                          boldIndices: const [],
                        ),
                        const SizeBox(height: 15),

                        Text(
                          "${investScreenArgument.isTopUp ? "Top up amount" : "Investment amount"} (AED)",
                          style: TextStyles.primaryMedium.copyWith(
                            color: AppColors.dark80,
                            fontSize: (14 / Dimensions.designWidth).w,
                          ),
                        ),
                        const SizeBox(height: 8),
                        BlocBuilder<ShowButtonBloc, ShowButtonState>(
                          builder: (context, state) {
                            return CustomTextField(
                              hintText: "Eg. Multiples of AED 100",
                              keyboardType: TextInputType.number,
                              controller: _amountController,
                              borderColor:
                                  isValid || _amountController.text == "0.00"
                                      ? const Color(0XFFEEEEEE)
                                      : AppColors.red100,
                              onChanged: onSendChanged,
                            );
                          },
                        ),
                        const SizeBox(height: 8),
                        BlocBuilder<ShowButtonBloc, ShowButtonState>(
                          builder: (context, state) {
                            if (!isValid && _amountController.text != "0.00") {
                              return Row(
                                children: [
                                  Icon(
                                    Icons.error_rounded,
                                    color: AppColors.red100,
                                    size: (12 / Dimensions.designWidth).w,
                                  ),
                                  const SizeBox(width: 5),
                                  Text(
                                    investmentAmount < forecastMinLimit
                                        ? "The amount is below minimum limit"
                                        : investmentAmount > forecastMaxLimit
                                            ? "The amount is above maximum limit"
                                            : "Amount needs to be a multiple of 100",
                                    style: TextStyles.primaryMedium.copyWith(
                                      color: AppColors.red100,
                                      fontSize: (12 / Dimensions.designWidth).w,
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return const SizeBox(height: 12);
                            }
                          },
                        ),
                        // SizeBox(
                        //   height:
                        //       MediaQuery.of(context).viewInsets.bottom > 0
                        //           ? 388
                        //           : 356,
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    if (!isValid || _amountController.text == "0.00") {
                      return SolidButton(
                        onTap: () {},
                        text: "Proceed",
                      );
                    } else {
                      return GradientButton(
                        onTap: () async {
                          setState(() {
                            isFetchingBonus = true;
                          });
                          await getReferralDetails();
                          setState(() {
                            isFetchingBonus = false;
                          });
                          if (!mounted) return;
                          if (referralBonusBalance > 0) {
                            showAdaptiveDialog(
                              context: context,
                              builder: (context) {
                                return CustomDialog(
                                  svgAssetPath: ImageConstants.warning,
                                  title: "Use Referral Bonus?",
                                  message:
                                      "You are eligible to use referral bonus of AED $referralBonusBalance",
                                  auxWidget: GradientButton(
                                    onTap: () {
                                      referralBonusInvested =
                                          referralBonusBalance;
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                        context,
                                        Routes.investmentConfirmation,
                                        arguments: MakeInvestmentArgument(
                                          portfolio: portfolioBeingInvested,
                                          amount: investmentAmount,
                                          referralBonus: referralBonusBalance,
                                          isTopUp: investScreenArgument.isTopUp,
                                        ).toMap(),
                                      );
                                    },
                                    text:
                                        "Use for ${portfolioBeingInvested.toTitleCase()}",
                                  ),
                                  actionWidget: SolidButton(
                                    color: Colors.white,
                                    boxShadow: [BoxShadows.primary],
                                    fontColor: AppColors.dark100,
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                        context,
                                        Routes.investmentConfirmation,
                                        arguments: MakeInvestmentArgument(
                                          portfolio: portfolioBeingInvested,
                                          amount: investmentAmount,
                                          referralBonus: 0,
                                          isTopUp: investScreenArgument.isTopUp,
                                        ).toMap(),
                                      );
                                    },
                                    text: "Don't use",
                                  ),
                                );
                              },
                            );
                          } else {
                            Navigator.pushNamed(
                              context,
                              Routes.investmentConfirmation,
                              arguments: MakeInvestmentArgument(
                                portfolio: portfolioBeingInvested,
                                amount: investmentAmount,
                                referralBonus: 0,
                                isTopUp: investScreenArgument.isTopUp,
                              ).toMap(),
                            );
                          }
                        },
                        text: "Proceed",
                        auxWidget: isFetchingBonus
                            ? const LoaderRow()
                            : const SizeBox(),
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

  Future<void> getReferralDetails() async {
    var getRefDets = await MapReferralDetails.mapReferralDetails();
    log("getRefDets -> $getRefDets");
    if (getRefDets["success"]) {
      registeredUsers = getRefDets["registeredUsers"];
      completedUsers = getRefDets["completedUsers"];
      referralBonusBalance = getRefDets["referralBonusBalance"].toDouble();
    } else {
      if (context.mounted) {
        ApiException.apiException(context);
      }
    }
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

    if (double.parse(
                _amountController.text.replaceAll(',', '')) <
            forecastMinLimit ||
        double.parse(_amountController.text.replaceAll(',', '')) >
            forecastMaxLimit ||
        double.parse(_amountController.text.replaceAll(',', '')) % 10 != 0 ||
        double.parse(_amountController.text.replaceAll(',', '')) == 0.00) {
      // ! abs()
      isValid = false;

      showProceedButtonBloc.add(ShowButtonEvent(show: isValid));
    } else {
      showProceedButtonBloc.add(ShowButtonEvent(show: isValid));
      isValid = true;
    }

    investmentAmount = double.parse(_amountController.text.replaceAll(',', ''));
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
