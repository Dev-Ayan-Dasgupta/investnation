// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/data/repository/investment/index.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/screens/common/index.dart';
import 'package:investnation/presentation/screens/investmentCreation/index.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/presentation/widgets/investmentCreation/index.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:investnation/utils/constants/legal.dart';
import 'package:investnation/utils/helpers/index.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  bool isClickable = true;

  int portIdx = 0;

  late PlanArgumentModel planArgument;

  @override
  void initState() {
    super.initState();
    initializeArgument();
    getPortfolioIndex();
  }

  void initializeArgument() {
    planArgument = PlanArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  void getPortfolioIndex() {
    for (int i = 0; i < portfolios.length; i++) {
      if (portfolios[i]["id"] == planArgument.planType) {
        portIdx = i;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        actions: [
          InkWell(
            onTap: () async {
              if (isClickable) {
                setState(() {
                  isClickable = false;
                });

                log("factSheetApiRes -> ${{
                  "portfolioId": planArgument.planType,
                }}");
                try {
                  var factSheetApiRes = await MapFactSheet.mapFactSheet({
                    "portfolioId": planArgument.planType,
                  });
                  if (factSheetApiRes["success"]) {
                    factSheet = factSheetApiRes["data"][0]["factSheetContent"];
                    if (context.mounted) {
                      Navigator.pushNamed(context, Routes.factSheet);
                    }
                  }
                } catch (e) {
                  log(e.toString());
                }

                setState(() {
                  isClickable = true;
                });
              }
            },
            child: SvgPicture.asset(ImageConstants.factSheet),
          ),
          const SizeBox(width: PaddingConstants.horizontalPadding),
        ],
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
                      Text(
                        portfolios[portIdx]["shortDesc"],
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark80,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                      ),
                      const SizeBox(height: 10),
                      SizedBox(
                        height: (470 / Dimensions.designHeight).h,
                        child: Row(
                          children: [
                            Expanded(
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  PlanBenefitsCard(
                                    benefitDetails: benefitDetails,
                                  ),
                                  const SizeBox(width: 10),
                                  PlanDescriptionCard(
                                    hmtlContent: htmlContent,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    GradientButton(
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
                          if (cardFreezeApp) {
                            promptCardBlocked();
                          } else {
                            if (storageCif == "UNREGISTERED") {
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
                            } else if (isExpiredRiskProfiling) {
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
                    ),
                    const SizeBox(height: 10),
                    SolidButton(
                      color: Colors.white,
                      boxShadow: [BoxShadows.primary],
                      fontColor: AppColors.dark100,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.forecast,
                          arguments: PlanArgumentModel(
                            planType: planArgument.planType,
                            isExplore: planArgument.isExplore,
                            onboardingState: planArgument.onboardingState,
                          ).toMap(),
                        );
                      },
                      text: "Forecast",
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
          fromForecast: "",
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
}
