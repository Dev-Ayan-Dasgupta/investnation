// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:investnation/utils/helpers/index.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'package:investnation/bloc/index.dart';
import 'package:investnation/data/models/index.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/screens/common/index.dart';
import 'package:investnation/presentation/screens/investmentCreation/index.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
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

  final TextEditingController _amountController =
      TextEditingController(text: "0.00");

  List<ChartSampleData>? chartData;

  double years = 10;
  bool showForecast = false;
  bool isValid = false;
  double principal = 0;
  double rate = portfolioBeingInvested == "SAVER"
      ? 2.37
      : portfolioBeingInvested == "FLEX"
          ? 2.7
          : 3.1;

  late int initLength;
  double forecastAmount = 0;

  late PlanArgumentModel planArgument;

  @override
  void initState() {
    super.initState();

    // Initially the length of _amountController.text will be held in a variable
    // if length of _amountController.text becomes more than this value, we will multiply the parsed _amountController.text amount by 10, else we will divide by 10
    initLength = _amountController.text.length;

    initializeArgument();
    chartData = <ChartSampleData>[
      ChartSampleData(x: 0, y: 1, y2: 1, y3: 1), // 0-th year
      ChartSampleData(x: 5, y: 1.1, y2: 1.2, y3: 1.3), // 5-th year
      ChartSampleData(x: 10, y: 1.21, y2: 1.44, y3: 1.69), // 10-th year
      ChartSampleData(x: 15, y: 1.33, y2: 1.73, y3: 2.20), // 15-th year
    ];
  }

  void initializeArgument() {
    planArgument = PlanArgumentModel.fromMap(widget.argument as dynamic ?? {});
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Forecast",
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
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          DetailsTile(
                            length: criteriaDetails.length,
                            details: criteriaDetails,
                            boldIndices: const [],
                          ),
                          const SizeBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Investment amount (AED)",
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
                                    controller: _amountController,
                                    keyboardType: TextInputType.number,
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
                                        Text(
                                          forecastAmount < forecastMinLimit
                                              ? "The amount is below minimum limit"
                                              : forecastAmount >
                                                      forecastMaxLimit
                                                  ? "The amount is above maximum limit"
                                                  : "Amount needs to be a multiple of 100",
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
                                    return const SizeBox(height: 12);
                                  }
                                },
                              ),
                              const SizeBox(),
                              MediaQuery.of(context).viewInsets.bottom <= 0
                                  ? Stack(
                                      children: [
                                        Column(
                                          children: [
                                            showForecast
                                                ? Center(
                                                    child: Text(
                                                      "Assumes a growth rate of $rate% per year",
                                                      style: TextStyles
                                                          .primaryMedium
                                                          .copyWith(
                                                        color: AppColors.dark50,
                                                        fontSize: (14 /
                                                                Dimensions
                                                                    .designWidth)
                                                            .w,
                                                      ),
                                                    ),
                                                  )
                                                : const SizeBox(),
                                            SizeBox(
                                              height: (years == 15
                                                  ? 20
                                                  : years == 10
                                                      ? 65
                                                      : years == 5
                                                          ? 110
                                                          : 155),
                                            ),
                                            showForecast
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 12,
                                                                right: 12),
                                                        child: SizedBox(
                                                          // checking for each type of selection e.g. 5, 10 and 15 years and accordingly keeping the height of the chart
                                                          height: ((years == 15
                                                                      ? 160
                                                                      : years ==
                                                                              10
                                                                          ? 115
                                                                          : years ==
                                                                                  5
                                                                              ? 70
                                                                              : 25) /
                                                                  Dimensions
                                                                      .designHeight)
                                                              .h,
                                                          // checking for each type of selection e.g. 5, 10 and 15 years and accordingly keeping the width of the chart
                                                          width: ((years == 15
                                                                      ? 370
                                                                      : years ==
                                                                              10
                                                                          ? 255
                                                                          : years ==
                                                                                  5
                                                                              ? 140
                                                                              : 25) /
                                                                  Dimensions
                                                                      .designWidth)
                                                              .w,
                                                          child:
                                                              SfCartesianChart(
                                                            plotAreaBorderWidth:
                                                                0,
                                                            primaryYAxis:
                                                                NumericAxis(
                                                                    minimum: 1,
                                                                    maximum:
                                                                        chartData!
                                                                            .last
                                                                            .y3,
                                                                    isVisible:
                                                                        false),
                                                            primaryXAxis:
                                                                NumericAxis(
                                                                    isVisible:
                                                                        false),
                                                            // palette: const [
                                                            //   AppColors.primary30,
                                                            //   AppColors.primary50,
                                                            //   AppColors.primary100,
                                                            // ],
                                                            series: <ChartSeries<
                                                                ChartSampleData,
                                                                int>>[
                                                              AreaSeries(
                                                                dataSource:
                                                                    chartData!,
                                                                xValueMapper:
                                                                    (ChartSampleData
                                                                                data,
                                                                            _) =>
                                                                        data.x,
                                                                yValueMapper:
                                                                    (ChartSampleData
                                                                                data,
                                                                            _) =>
                                                                        data.y3,
                                                                color: const Color(
                                                                    0XFFD69F2F),
                                                              ),
                                                              AreaSeries(
                                                                dataSource:
                                                                    chartData!,
                                                                xValueMapper:
                                                                    (ChartSampleData
                                                                                data,
                                                                            _) =>
                                                                        data.x,
                                                                yValueMapper:
                                                                    (ChartSampleData
                                                                                data,
                                                                            _) =>
                                                                        data.y2,
                                                                color: const Color(
                                                                    0XFFFFCC62),
                                                              ),
                                                              AreaSeries(
                                                                dataSource:
                                                                    chartData!,
                                                                xValueMapper:
                                                                    (ChartSampleData
                                                                                data,
                                                                            _) =>
                                                                        data.x,
                                                                yValueMapper:
                                                                    (ChartSampleData
                                                                                data,
                                                                            _) =>
                                                                        data.y,
                                                                color: const Color(
                                                                    0XFFFFEBC2),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : SizeBox(
                                                    height: (248 /
                                                            Dimensions
                                                                .designHeight)
                                                        .h),
                                            showForecast
                                                ? SfSlider(
                                                    value: years,
                                                    activeColor:
                                                        AppColors.primary100,
                                                    inactiveColor:
                                                        AppColors.dark10,
                                                    thumbIcon: Container(
                                                      height: (12 /
                                                              Dimensions
                                                                  .designWidth)
                                                          .w,
                                                      width: (12 /
                                                              Dimensions
                                                                  .designWidth)
                                                          .w,
                                                      decoration:
                                                          const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    min: 0,
                                                    max: 15,
                                                    stepSize: 5,
                                                    interval: 5,
                                                    showLabels: true,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        years = val;
                                                      });
                                                    },
                                                  )
                                                : const SizeBox(),
                                            const SizeBox(height: 10),
                                            showForecast
                                                ? Center(
                                                    child: Text(
                                                      "Projected gains over ${years.toStringAsFixed(0)} years",
                                                      style: TextStyles
                                                          .primaryMedium
                                                          .copyWith(
                                                        color: AppColors.dark80,
                                                        fontSize: (14 /
                                                                Dimensions
                                                                    .designWidth)
                                                            .w,
                                                      ),
                                                    ),
                                                  )
                                                : const SizeBox(),
                                          ],
                                        ),
                                      ],
                                    )
                                  : const SizeBox()
                              // const SizeBox(height: 5),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: [
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    return SolidButton(
                      color: _amountController.text.isNotEmpty && isValid
                          ? Colors.white
                          : AppColors.dark30,
                      fontColor: _amountController.text.isNotEmpty && isValid
                          ? AppColors.dark100
                          : AppColors.dark5,
                      boxShadow: _amountController.text.isNotEmpty && isValid
                          ? [BoxShadows.primary]
                          : null,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        if (_amountController.text.isNotEmpty && isValid) {
                          setState(() {
                            showForecast = true;
                            principal = forecastAmount;
                          });
                        }
                      },
                      text: showForecast ? "Modify Forecast" : "Show Forecast",
                    );
                  },
                ),
                const SizeBox(height: 15),
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    if (showForecast && isValid) {
                      return GradientButton(
                        onTap: () {
                          if (planArgument.isExplore) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return CustomDialog(
                                  svgAssetPath:
                                      ImageConstants.checkCircleOutlined,
                                  title: "Done exploring?",
                                  message:
                                      "Register now and enjoy the world of investment!",
                                  auxWidget: GradientButton(
                                    onTap: () {
                                      // Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                        context,
                                        Routes.registration,
                                        // (route) => false,
                                        arguments: RegistrationArgumentModel(
                                          isInitial: true,
                                          isUpdateCorpEmail: false,
                                        ).toMap(),
                                      );
                                    },
                                    text: "Register",
                                  ),
                                  actionWidget: SolidButton(
                                    fontColor: AppColors.dark100,
                                    color: Colors.white,
                                    boxShadow: [BoxShadows.primary],
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    text: "Cancel",
                                  ),
                                );
                              },
                            );
                          } else {
                            if (isExpiredRiskProfiling) {
                              showAdaptiveDialog(
                                context: context,
                                builder: (context) {
                                  return CustomDialog(
                                    svgAssetPath: ImageConstants.warning,
                                    title: "Risk Profile Expired",
                                    message:
                                        "Please update your risk profile to continue",
                                    auxWidget: GradientButton(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          Routes.riskProfiling,
                                          arguments:
                                              PreRiskProfileArgumentModel(
                                            isInitial: false,
                                          ).toMap(),
                                        );
                                      },
                                      text: "Update Risk Profile",
                                    ),
                                    actionWidget: SolidButton(
                                      color: Colors.white,
                                      boxShadow: [BoxShadows.primary],
                                      fontColor: AppColors.dark100,
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      text: "Skip for Now",
                                    ),
                                  );
                                },
                              );
                            } else if (storageCif == "UNREGISTERED") {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return CustomDialog(
                                    svgAssetPath:
                                        ImageConstants.checkCircleOutlined,
                                    title: "Oh no!",
                                    message:
                                        "Please continue with the onboarding process",
                                    auxWidget: GradientButton(
                                      onTap: () {
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          Routes.dashboard,
                                          (routes) => false,
                                          arguments: DashboardArgumentModel(
                                            onboardingState:
                                                planArgument.onboardingState,
                                          ).toMap(),
                                        );
                                      },
                                      text: "Continue Onboarding",
                                    ),
                                    actionWidget: SolidButton(
                                      fontColor: AppColors.dark100,
                                      color: Colors.white,
                                      boxShadow: [BoxShadows.primary],
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      text: "Skip for Now",
                                    ),
                                  );
                                },
                              );
                            } else {
                              if (cardFreezeApp) {
                                promptCardBlocked();
                              } else {
                                if (storageRiskProfile ==
                                    "Conservative Investor") {
                                  if (portfolioBeingInvested != "SAVER") {
                                    promptUpdateRiskProfile();
                                  } else {
                                    navigateToInvestment();
                                  }
                                } else if (storageRiskProfile ==
                                    "Moderate Investor") {
                                  if (portfolioBeingInvested != "SAVER" &&
                                      portfolioBeingInvested != "FLEX") {
                                    promptUpdateRiskProfile();
                                  } else {
                                    navigateToInvestment();
                                  }
                                } else {
                                  navigateToInvestment();
                                }
                              }
                            }
                          }
                        },
                        text: "Invest",
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

  void promptUpdateRiskProfile() {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Update Risk Profile",
          message: "Please update your risk profile to continue",
          auxWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                Routes.riskProfiling,
                arguments: PreRiskProfileArgumentModel(
                  isInitial: false,
                ).toMap(),
              );
            },
            text: "Update Risk Profile",
          ),
          actionWidget: SolidButton(
            color: Colors.white,
            boxShadow: [BoxShadows.primary],
            fontColor: AppColors.dark100,
            onTap: () {
              Navigator.pop(context);
            },
            text: "Skip for Now",
          ),
        );
      },
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

    forecastAmount = double.parse(_amountController.text.replaceAll(',', ''));
  }

  void navigateToInvestment() {
    if (currentBalance < 500) {
      showAdaptiveDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            svgAssetPath: ImageConstants.warning,
            title: "Insufficient Balance",
            message: "Please fund your wallet to continue",
            auxWidget: GradientButton(
              onTap: () {
                // Navigator.pop(context);
                Navigator.pushReplacementNamed(
                  context,
                  Routes.addFunds,
                );
              },
              text: "Add Funds",
            ),
            actionWidget: SolidButton(
              color: Colors.white,
              boxShadow: [BoxShadows.primary],
              fontColor: AppColors.dark100,
              onTap: () {
                Navigator.pop(context);
              },
              text: "Skip for Now",
            ),
          );
        },
      );
    } else {
      Navigator.pushNamed(
        context,
        Routes.invest,
        arguments: InvestScreenArgumentModel(
          isTopUp: false,
          fromForecast: forecastAmount.toStringAsFixed(2),
        ).toMap(),
      );
    }
  }

  void promptCardBlocked() {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Card is freezed",
          message: "Please unfreeze your card to proceed",
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

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}

class ChartSampleData {
  int x;
  double y;
  double y2;
  double y3;
  ChartSampleData({
    required this.x,
    required this.y,
    required this.y2,
    required this.y3,
  });
}
