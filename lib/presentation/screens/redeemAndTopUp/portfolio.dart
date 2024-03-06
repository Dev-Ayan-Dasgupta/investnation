import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:investnation/bloc/index.dart';
import 'package:investnation/data/models/index.dart';
import 'package:investnation/data/repository/investment/index.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/screens/common/index.dart';
import 'package:investnation/presentation/screens/investmentCreation/index.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:investnation/utils/helpers/index.dart';
import 'package:pie_chart/pie_chart.dart';

class RTPortfolioScreen extends StatefulWidget {
  const RTPortfolioScreen({super.key});

  @override
  State<RTPortfolioScreen> createState() => _RTPortfolioScreenState();
}

double marketValue = 0;
double redemptionFeePct = 0;

class _RTPortfolioScreenState extends State<RTPortfolioScreen> {
  List<DetailsTileModel> portfolioDetails = [];

  Map<String, double> dataMap = {};

  bool isLoading = false;

  List securityDetails = [];
  List categoryDetails = [];
  double amountInvested = 0;

  double returns = 0;
  String accountNumber = "";
  String accountName = "";

  List<Color> colorList = [];

  @override
  void initState() {
    super.initState();
    getPortfolioAllocationDetails();
  }

  Future<void> getPortfolioAllocationDetails() async {
    try {
      setState(() {
        isLoading = true;
      });

      log("portAllocDets Req -> ${{"portfolioCode": portfolioBeingInvested}}");
      var portAllocDetsRes =
          await MapPortfolioAllocationDetails.mapPortfolioAllocationDetails(
              {"portfolioCode": portfolioBeingInvested});
      log("portAllocDetsRes -> $portAllocDetsRes");

      categoryDetails = portAllocDetsRes["data"][0]["categoryDetails"];

      colorList.clear();
      for (var element in categoryDetails) {
        colorList.add(Color(
            int.parse("ff${element["colorCode"].split('#').last}", radix: 16)));
      }

      securityDetails = portAllocDetsRes["data"][0]["securityDetails"];
      amountInvested = portAllocDetsRes["data"][0]["amountInvested"].toDouble();
      marketValue = portAllocDetsRes["data"][0]["marketValue"].toDouble();
      returns = portAllocDetsRes["data"][0]["returns"].toDouble();
      accountNumber = portAllocDetsRes["data"][0]["accountNumber"];
      accountName = portAllocDetsRes["data"][0]["accountName"];
      redemptionFeePct = portAllocDetsRes["data"][0]["redemptionFeePct"] * 1.00;
      log('redemptionFeePct -> $redemptionFeePct');

      populatePortfolioDetails();
      populateDataMap();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void populatePortfolioDetails() {
    portfolioDetails
        .add(DetailsTileModel(key: "Portfolio Position", value: ""));
    portfolioDetails
        .add(DetailsTileModel(key: "Account Number", value: accountNumber));
    portfolioDetails
        .add(DetailsTileModel(key: "Account Name", value: accountName));
    portfolioDetails.add(DetailsTileModel(
      key: "Amount Invested",
      value: "AED ${NumberFormatter.numberFormat(amountInvested)}",
    ));

    portfolioDetails.add(DetailsTileModel(
      key: "Market Value (As of date)",
      value: "AED ${NumberFormatter.numberFormat(marketValue)}",
    ));

    portfolioDetails.add(DetailsTileModel(
      key: "Returns",
      value: "AED ${NumberFormatter.numberFormat(returns)}",
    ));
  }

  void populateDataMap() {
    for (var element in categoryDetails) {
      dataMap[element["category"]] = (element["allocation"]).toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (16 / Dimensions.designWidth).w,
                vertical: (5 / Dimensions.designWidth).w,
              ),
              child: SvgPicture.asset(
                ImageConstants.download2,
                width: (50 / Dimensions.designWidth).w,
                height: (50 / Dimensions.designWidth).w,
              ),
            ),
          )
        ],
      ),
      body: Ternary(
        condition: isLoading,
        truthy: SizedBox(
          width: 100.w,
          height: 100.h,
          child: InkWell(
            onTap: () {},
            child: Center(
              child: SpinKitFadingCircle(
                color: AppColors.primary100,
                size: (50 / Dimensions.designWidth).w,
              ),
            ),
          ),
        ),
        falsy: Padding(
          padding: EdgeInsets.symmetric(
            horizontal:
                (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      portfolioBeingInvested.toTitleCase(),
                      style: TextStyles.primaryBold.copyWith(
                        color: AppColors.dark100,
                        fontSize: (28 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 20),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          BlocBuilder<ShowButtonBloc, ShowButtonState>(
                            builder: (context, state) {
                              return DetailsTile(
                                length: portfolioDetails.length,
                                details: portfolioDetails,
                                boldIndices: const [0],
                              );
                            },
                          ),
                          // const Spacer(),
                          const SizeBox(height: 20),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.securityAlloc,
                                arguments: SecurityAllocationArgumentModel(
                                  securityDetails: securityDetails,
                                ).toMap(),
                              );
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                PieChart(
                                  ringStrokeWidth: 30,
                                  dataMap: dataMap,
                                  chartType: ChartType.ring,
                                  chartRadius: 40.w,
                                  legendOptions: const LegendOptions(
                                    showLegends: false,
                                  ),
                                  chartValuesOptions: const ChartValuesOptions(
                                    showChartValues: false,
                                  ),
                                  colorList: colorList,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "Market Value (AED)",
                                      style: TextStyles.primaryMedium.copyWith(
                                        fontSize:
                                            (14 / Dimensions.designWidth).w,
                                        color: AppColors.dark100,
                                      ),
                                    ),
                                    const SizeBox(height: 5),
                                    Text(
                                      NumberFormatter.numberFormat(marketValue),
                                      style: TextStyles.primaryBold.copyWith(
                                        fontSize:
                                            (14 / Dimensions.designWidth).w,
                                        color: AppColors.dark100,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizeBox(height: 20),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.securityAlloc,
                                arguments: SecurityAllocationArgumentModel(
                                  securityDetails: securityDetails,
                                ).toMap(),
                              );
                            },
                            child: Container(
                              height: 14.h,
                              decoration: const BoxDecoration(
                                color: AppColors.dark10,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    (PaddingConstants.horizontalPadding /
                                            Dimensions.designWidth)
                                        .w,
                                vertical: (PaddingConstants.horizontalPadding /
                                        Dimensions.designWidth)
                                    .w,
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      separatorBuilder: (context, index) {
                                        return const SizeBox(height: 10);
                                      },
                                      itemCount: categoryDetails.length,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          children: [
                                            Container(
                                              width:
                                                  (10 / Dimensions.designWidth)
                                                      .w,
                                              height:
                                                  (10 / Dimensions.designWidth)
                                                      .w,
                                              decoration: BoxDecoration(
                                                color: Color(int.parse(
                                                    "ff${categoryDetails[index]["colorCode"].split('#').last}",
                                                    radix: 16)),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizeBox(width: 10),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    categoryDetails[index]
                                                        ["category"],
                                                    style: TextStyles
                                                        .primaryMedium
                                                        .copyWith(
                                                      fontSize: (14 /
                                                              Dimensions
                                                                  .designWidth)
                                                          .w,
                                                      color: AppColors.dark100,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "${(categoryDetails[index]["percentage"] * 100).toStringAsFixed(2)}%",
                                                        style: TextStyles
                                                            .primaryMedium
                                                            .copyWith(
                                                          fontSize: (14 /
                                                                  Dimensions
                                                                      .designWidth)
                                                              .w,
                                                          color:
                                                              AppColors.dark100,
                                                        ),
                                                      ),
                                                      // const SizeBox(width: 5),
                                                      // Icon(
                                                      //   Icons
                                                      //       .arrow_forward_ios_rounded,
                                                      //   color:
                                                      //       AppColors.dark100,
                                                      //   size: (10 /
                                                      //           Dimensions
                                                      //               .designWidth)
                                                      //       .w,
                                                      // ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // const SizeBox(height: 50),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GradientButton(
                        width: 44.w,
                        onTap: () {
                          if (cardFreezeApp) {
                            promptCardBlocked();
                          } else {
                            if (storageRiskProfile == "Conservative Investor") {
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
                        },
                        text: "Top Up",
                      ),
                      const SizeBox(width: 15),
                      SolidButton(
                        width: 44.w,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.redeem,
                          );
                        },
                        color: Colors.white,
                        fontColor: AppColors.dark100,
                        boxShadow: [BoxShadows.primary],
                        text: "Redeem",
                      ),
                    ],
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
      ),
    );
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
          isTopUp: true,
          fromForecast: "0.00",
        ).toMap(),
      );
    }
  }
}
