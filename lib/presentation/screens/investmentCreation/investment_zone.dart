// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:investnation/data/models/index.dart';
import 'package:investnation/data/repository/investment/index.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/screens/common/index.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/presentation/widgets/investmentCreation/investment_zone_tile.dart';
import 'package:investnation/utils/constants/index.dart';

class InvestmentZoneScreen extends StatefulWidget {
  const InvestmentZoneScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<InvestmentZoneScreen> createState() => _InvestmentZoneScreenState();
}

String portfolioBeingInvested = "";
double forecastMaxLimit = 0;
double forecastMinLimit = 0;

List benefitDetails = [];
String htmlContent = "";

void getAvailablePortfolios() async {
  try {
    var availablePortfolios =
        await MapAvailablePortfolios.mapAvailablePortfolios();
    if (availablePortfolios["success"]) {
      portfolios = availablePortfolios["data"];
    }
    log("portfolios -> $portfolios");
  } catch (e) {
    log(e.toString());
  }
}

class _InvestmentZoneScreenState extends State<InvestmentZoneScreen> {
  bool isClickable = true;

  late PlanArgumentModel planArgument;

  @override
  void initState() {
    super.initState();
    initializeArgument();
  }

  void initializeArgument() {
    planArgument = PlanArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  (PaddingConstants.horizontalPadding / Dimensions.designWidth)
                      .w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Investment Zone",
                  style: TextStyles.primaryBold.copyWith(
                    color: AppColors.dark100,
                    fontSize: (28 / Dimensions.designWidth).w,
                  ),
                ),
                const SizeBox(height: 20),
                Text(
                  "Available Portfolios",
                  style: TextStyles.primaryMedium.copyWith(
                    color: AppColors.dark80,
                    fontSize: (14 / Dimensions.designWidth).w,
                  ),
                ),
                const SizeBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return InvestmentZoneTile(
                        onTap: () async {
                          setState(() {
                            isClickable = false;
                          });

                          portfolioBeingInvested =
                              portfolios[index]["portfolioName"].toUpperCase();
                          log("portfolioBeingInvested -> $portfolioBeingInvested");
                          forecastMaxLimit =
                              portfolios[index]["forecastMaxLimit"].toDouble();
                          forecastMinLimit =
                              portfolios[index]["forecastMinLimit"].toDouble();

                          log("getPortDets req -> ${{
                            "portfolioId": portfolios[index]["id"]
                          }}");
                          try {
                            var getPortDets =
                                await MapPortfolioDetails.mapPortfolioDetails(
                                    {"portfolioId": portfolios[index]["id"]});
                            log("getPortDets -> $getPortDets");
                            if (getPortDets["success"]) {
                              benefitDetails =
                                  getPortDets["data"][0]["benefits"];
                              htmlContent =
                                  getPortDets["data"][0]["portfolioDesc"];
                            }

                            if (context.mounted) {
                              Navigator.pushNamed(
                                context,
                                Routes.plan,
                                arguments: PlanArgumentModel(
                                  planType: portfolios[index]["id"],
                                  isExplore: planArgument.isExplore,
                                  onboardingState: planArgument.onboardingState,
                                ).toMap(),
                              );
                            }

                            setState(() {
                              isClickable = true;
                            });
                          } catch (e) {
                            log(e.toString());
                          }
                        },
                        planName: portfolios[index]["portfolioName"],
                        returnRate: portfolios[index]["returnPa"],
                        riskLevel: portfolios[index]["riskLevel"],
                        description: portfolios[index]["shortDesc"],
                      );
                    },
                    separatorBuilder: (context, _) {
                      return const SizeBox(height: 10);
                    },
                    itemCount: portfolios.length,
                  ),
                ),
              ],
            ),
          ),
          isClickable
              ? const SizeBox()
              : SizedBox(
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
        ],
      ),
    );
  }
}
