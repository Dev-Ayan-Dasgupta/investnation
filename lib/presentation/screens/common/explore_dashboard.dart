import 'dart:convert';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/screens/common/index.dart';
import 'package:investnation/presentation/widgets/core/dashboard_button.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/presentation/widgets/dashboard/index.dart';
import 'package:investnation/utils/constants/index.dart';

class ExploreDashboardScreen extends StatefulWidget {
  const ExploreDashboardScreen({super.key});

  @override
  State<ExploreDashboardScreen> createState() => _ExploreDashboardScreenState();
}

class _ExploreDashboardScreenState extends State<ExploreDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  final DraggableScrollableController _dsController =
      DraggableScrollableController();

  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: promptUser,
          child: Padding(
            padding: EdgeInsets.all((20 / Dimensions.designWidth).w),
            child: SvgPicture.asset(ImageConstants.menu),
          ),
        ),
        title: InkWell(
          onTap: promptUser,
          child: SvgPicture.asset(ImageConstants.appBarLogo),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                onTap: (value) {
                  promptUser();
                },
                tabAlignment: TabAlignment.start,
                dividerHeight: 0,
                controller: tabController,
                indicatorColor: Colors.transparent,
                tabs: const [
                  Tab(
                    child: CustomTab(
                      title: "Cards",
                      isSelected: true,
                    ),
                  ),
                  Tab(
                    child: CustomTab(
                      title: "Investment",
                      isSelected: false,
                    ),
                  ),
                  Tab(
                    child: CustomTab(
                      title: "Referral",
                      isSelected: false,
                    ),
                  ),
                ],
                isScrollable: true,
                labelColor: Colors.black,
                labelStyle: TextStyles.primaryMedium.copyWith(
                  color: const Color(0xFF000000),
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
                unselectedLabelColor: Colors.black,
                unselectedLabelStyle: TextStyles.primaryMedium.copyWith(
                  color: const Color(0xFF000000),
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              const SizeBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: (PaddingConstants.horizontalPadding /
                          Dimensions.designWidth)
                      .w,
                ),
                child: InkWell(
                  onTap: promptUser,
                  child: CustomFlipCard(
                      cardKey: cardKey,
                      cardNumber: "87271313****8574",
                      iban: "AE7410249724141001",
                      expiryDate: "2027-10-15",
                      cardHolderName: "Mohamed Rashid",
                      cvv: "931",
                      currentBalance: 0.00),
                ),
              ),
              const SizeBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Powered by Finance House",
                  style: TextStyles.primaryMedium.copyWith(
                    fontSize: (14 / Dimensions.designWidth).w,
                    color: AppColors.dark50,
                  ),
                ),
              ),
              const SizeBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: (PaddingConstants.horizontalPadding /
                          Dimensions.designWidth)
                      .w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DashboardActionButton(
                      onTap: promptUser,
                      svgName: ImageConstants.add,
                      text: "Add Funds",
                    ),
                    const SizeBox(width: 10),
                    DashboardActionButton(
                      onTap: promptUser,
                      svgName: ImageConstants.moveUp,
                      text: "Transfer Out",
                    ),
                    const SizeBox(width: 10),
                    DashboardActionButton(
                      onTap: promptUser,
                      svgName: ImageConstants.group,
                      text: "Beneficiary",
                    ),
                  ],
                ),
              ),
              const SizeBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: (PaddingConstants.horizontalPadding /
                          Dimensions.designWidth)
                      .w,
                ),
                child: InkWell(
                  onTap: promptUser,
                  child: Text(
                    "Save. Earn. Prosper",
                    style: TextStyles.primaryBold.copyWith(
                      fontSize: (16 / Dimensions.designWidth).w,
                      color: AppColors.dark100,
                    ),
                  ),
                ),
              ),
              const SizeBox(height: 15),
              Expanded(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) {
                    return const SizeBox(width: 10);
                  },
                  itemCount: banners.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: index == 0
                            ? (PaddingConstants.horizontalPadding /
                                    Dimensions.designWidth)
                                .w
                            : 0,
                        right: index == 1
                            ? (PaddingConstants.horizontalPadding /
                                    Dimensions.designWidth)
                                .w
                            : 0,
                      ),
                      child: SizedBox(
                        width: (370 / Dimensions.designWidth).w,
                        child: InkWell(
                          onTap: () async {
                            Navigator.pushNamed(
                              context,
                              Routes.investmentZone,
                              arguments: PlanArgumentModel(
                                planType: portfolios[index]["id"],
                                isExplore: true,
                                onboardingState: 0,
                              ).toMap(),
                            );
                            // portfolioBeingInvested =
                            //     portfolios[index]["portfolioName"].toUpperCase();
                            // log("portfolioBeingInvested -> $portfolioBeingInvested");
                            // forecastMaxLimit =
                            //     portfolios[index]["forecastMaxLimit"].toDouble();
                            // forecastMinLimit =
                            //     portfolios[index]["forecastMinLimit"].toDouble();

                            // log("getPortDets req -> ${{
                            //   "portfolioId": portfolios[index]["id"]
                            // }}");
                            // try {
                            //   var getPortDets =
                            //       await MapPortfolioDetails.mapPortfolioDetails(
                            //           {"portfolioId": portfolios[index]["id"]});
                            //   log("getPortDets -> $getPortDets");
                            //   if (getPortDets["success"]) {
                            //     benefitDetails =
                            //         getPortDets["data"][0]["benefits"];
                            //     htmlContent =
                            //         getPortDets["data"][0]["portfolioDesc"];
                            //   }

                            //   if (context.mounted) {
                            //     Navigator.pushNamed(
                            //       context,
                            //       Routes.plan,
                            //       arguments: PlanArgumentModel(
                            //         planType: portfolios[index]["id"],
                            //         isExplore: true,
                            //       ).toMap(),
                            //     );
                            //   }
                            // } catch (e) {
                            //   log(e.toString());
                            // }
                          },
                          child: Image.memory(
                            base64Decode(
                              banners[index]["image"],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizeBox(height: 25),
              const SizeBox(height: 250),
            ],
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.31,
            minChildSize: 0.31,
            maxChildSize: 1,
            controller: _dsController,
            builder: (context, scrollController) {
              return InkWell(
                onTap: promptUser,
                child: ListView(
                  controller: scrollController,
                  children: [
                    // ! Outer Container
                    Container(
                      height: 90.h,
                      width: 100.w,
                      padding: EdgeInsets.symmetric(
                        horizontal: (PaddingConstants.horizontalPadding /
                                Dimensions.designWidth)
                            .w,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: const Color(0XFFEEEEEE)),
                        borderRadius: BorderRadius.only(
                          topLeft:
                              Radius.circular((20 / Dimensions.designWidth).w),
                          topRight:
                              Radius.circular((20 / Dimensions.designWidth).w),
                        ),
                        color: const Color(0xFFFFFFFF),
                      ),
                      child: Column(
                        children: [
                          const SizeBox(height: 15),
                          // ! Clip widget for drag
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: (10 / Dimensions.designWidth).w,
                            ),
                            height: (7 / Dimensions.designWidth).w,
                            width: (50 / Dimensions.designWidth).w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                    (10 / Dimensions.designWidth).w),
                              ),
                              color: const Color(0xFFD9D9D9),
                            ),
                          ),
                          const SizeBox(height: 15),
                          Row(
                            children: [
                              Text(
                                "Recent Transactions",
                                style: TextStyles.primaryMedium.copyWith(
                                  fontSize: (16 / Dimensions.designWidth).w,
                                  color: AppColors.dark80,
                                ),
                              ),
                            ],
                          ),
                          const SizeBox(height: 15),
                          SizedBox(
                            height: 82.5.h,
                            child: Column(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // const SizeBox(height: 20),
                                    Text(
                                      "No transactions",
                                      style: TextStyles.primaryBold.copyWith(
                                        color: AppColors.dark30,
                                        fontSize:
                                            (24 / Dimensions.designWidth).w,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizeBox(height: 15),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            child: CustomBottomNavBar(
              onNotificationTap: promptUser,
              onExploreInvestTap: promptUser,
              onReferralTap: promptUser,
              centerText: "Invest",
            ),
          ),
          // InkWell(
          //   onTap: promptUser,
          //   child: SizeBox(
          //     width: 100.w,
          //     height: 100.h,
          //   ),
          // ),
        ],
      ),
    );
  }

  void promptUser() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Done exploring?",
          message: "Register now and enjoy the world of investment!",
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
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
