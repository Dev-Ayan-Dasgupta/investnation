// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:blur/blur.dart';
import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:investnation/bloc/index.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/data/repository/accounts/index.dart';
import 'package:investnation/data/repository/investment/index.dart';
import 'package:investnation/data/repository/referral/index.dart';
import 'package:investnation/data/repository/riskProfiling/index.dart';
import 'package:investnation/environment/index.dart';
import 'package:investnation/main.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/screens/common/index.dart';
import 'package:investnation/presentation/screens/investmentCreation/index.dart';
import 'package:investnation/presentation/widgets/core/dashboard_button.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/presentation/widgets/dashboard/index.dart';
import 'package:investnation/presentation/widgets/dashboard/recent_transactions.dart';
import 'package:investnation/presentation/widgets/referral/index.dart';
import 'package:investnation/presentation/widgets/shimmers/dashboard_locked.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:investnation/utils/helpers/index.dart';
import 'package:share_plus/share_plus.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

double accountBalance = 0;

String cardNumber = "";
String iban = "";
String cardExpiryDate = "";
String cardHolderName = "";
String cvv = "";
bool isCardFreeze = false;
bool cardFreezeApp = false;
double currentBalance = 0;
bool canSendInv = false;
List registeredUsers = [];
List completedUsers = [];
double referralBonusBalance = 0;
double amountInvestedPortfolio = 0;
double clientPortfolioValue = 0;

bool isClickable = true;
bool isUpdatingInv = false;
List accountInvestments = [];

Map<String, dynamic> globalPortfolioDetails = {};

List transactionDetails = [];

late TabController tabController;

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  // bool isLocked = true;
  int stepsCompleted = 3;

  int tabIndex = 0;

  bool isLoading = false;
  bool isReferring = false;

  final ScrollController _scrollController = ScrollController();
  final ScrollController myScrollController = ScrollController();
  double _scrollOffset = 0;
  int _scrollIndex = 0;

  Map<String, dynamic> investmentDetails = {};

  final DraggableScrollableController _dsController =
      DraggableScrollableController();

  late DashboardArgumentModel dashboardArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    tabbarInitialization();
    // mockLoading();
    callApis();
  }

  void argumentInitialization() {
    dashboardArgument =
        DashboardArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  void tabbarInitialization() {
    final TabbarBloc tabbarBloc = context.read<TabbarBloc>();
    tabController = TabController(length: 3, vsync: this);
    tabController.animation!.addListener(() {
      final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();

      if (tabController.indexIsChanging ||
          tabController.index != tabController.previousIndex) {
        tabIndex = tabController.index;
        tabbarBloc.add(TabbarEvent(index: tabIndex));
        _scrollOffset = 0;
        _scrollIndex = 0;
      }
      log("tabIndex -> $tabIndex");
      log("tabController.index -> ${tabController.index}");

      showButtonBloc.add(const ShowButtonEvent(show: true));
    });
    _scrollController.addListener(() {
      _scrollOffset = _scrollController.offset + 120;
      _scrollIndex = _scrollOffset ~/ 188;
    });
  }

  Future<void> callApis() async {
    setState(() {
      isLoading = true;
    });

    if (dashboardArgument.onboardingState >= 7) {
      await getRiskProfile();
    }

    if (dashboardArgument.onboardingState == 8 &&
        storageCif != "UNREGISTERED") {
      await Future.wait([
        getCardDetails(),
        getInvestmentDetails(),
        getInvitationAuthorization(),
        getReferralDetails(),
      ]);
      await getTransactionHistory();

      // ! Clevertap Event

      Map<String, dynamic> cardDashboardViewedUnblockedEventData = {
        'email': profilePrimaryEmailId,
        'balanceAvailable': currentBalance,
        'deviceId': deviceId,
      };
      CleverTapPlugin.recordEvent(
        "Card Dashboard Viewed",
        cardDashboardViewedUnblockedEventData,
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> getCardDetails() async {
    if (dashboardArgument.onboardingState == 8) {
      try {
        var getCardDetailsResult = await MapCardDetails.mapCardDetails();
        log("getCardDetailsResult -> $getCardDetailsResult");
        if (getCardDetailsResult["success"]) {
          cardNumber =
              // getCardDetailsResult["data"][0]["encrCardNo"];
              AesHelper.decrypt(toUtf8(Environment.passPhrase),
                  toUtf8(getCardDetailsResult["data"][0]["encrCardNo"] ?? ""));
          // await EncryptDecrypt.decrypt(
          //     getCardDetailsResult["data"][0]["encrCardNo"]);
          log("cardNumber -> $cardNumber");
          iban = getCardDetailsResult["data"][0]["iban"] ?? "iban";
          log("iban -> $iban");
          cardExpiryDate =
              getCardDetailsResult["data"][0]["cardExpiryDate"] ?? "1970-01-01";
          log("cardExpiryDate -> $cardExpiryDate");
          cardHolderName = getCardDetailsResult["data"][0]["cardHolderName"] ??
              "cardHolderName";
          log("cardHolderName -> $cardHolderName");
          isCardFreeze =
              getCardDetailsResult["data"][0]["isCardFreeze"] ?? false;
          log("isCardFreeze -> $isCardFreeze");
          cardFreezeApp =
              getCardDetailsResult["data"][0]["cardFreezeApp"] ?? false;
          log("cardFreezeApp -> $cardFreezeApp");
          if (getCardDetailsResult["data"][0]["cardCVV"] == null) {
            cvv = "";
          } else {
            cvv =
                // getCardDetailsResult["data"][0]["cardCVV"] ?? "cvv";
                AesHelper.decrypt(toUtf8(Environment.passPhrase),
                    toUtf8(getCardDetailsResult["data"][0]["cardCVV"] ?? ""));
            // await EncryptDecrypt.decrypt(
            //     getCardDetailsResult["data"][0]["cardCVV"] ?? "cvv");
            log("cvv -> $cvv");
          }

          currentBalance =
              (getCardDetailsResult["data"][0]["currentBalance"]).toDouble() ??
                  0.00;
          log("currentBalance -> $currentBalance");
        } else {
          if (context.mounted) {
            showAdaptiveDialog(
              context: context,
              builder: (context) {
                return CustomDialog(
                  svgAssetPath: ImageConstants.warning,
                  title: "Sorry",
                  message: getCardDetailsResult["message"] ??
                      "There was an error in fecthing the card details, please try again later.",
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
    }
  }

  Future<void> getAccountBalance() async {
    log("Accnt Bal APi Req -> ${{
      "accountNumber": iban,
    }}");
    try {
      var acntBalApiResult = await MapAccountBalance.mapAccountBalance(
        {
          "accountNumber": iban,
        },
      );
      log("acntBalApiResult -> $acntBalApiResult");
      if (acntBalApiResult["success"]) {
        accountBalance = acntBalApiResult[""];
      } else {
        if (context.mounted) {
          showAdaptiveDialog(
            context: context,
            builder: (context) {
              return CustomDialog(
                svgAssetPath: ImageConstants.warning,
                title: "Sorry",
                message: acntBalApiResult["message"] ??
                    "There was an error in fetching your account balance, please try agaon later.",
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
  }

  Future<void> getRiskProfile() async {
    if (dashboardArgument.onboardingState == 8) {
      try {
        var getRpResult = await MapRiskProfile.mapRiskProfile();
        log("getRpResult -> $getRpResult");
        if (getRpResult["success"]) {
          await storage.write(
              key: "riskProfile", value: getRpResult["riskProfile"]);
          storageRiskProfile = await storage.read(key: "riskProfile") ?? "";
          log("storageRiskProfile -> $storageRiskProfile");
        } else {
          if (context.mounted) {
            showAdaptiveDialog(
              context: context,
              builder: (context) {
                return CustomDialog(
                  svgAssetPath: ImageConstants.warning,
                  title: "Sorry",
                  message: getRpResult["message"] ??
                      "There was an error in fetching your risk profile, please try again later.",
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
    }
  }

  Future<void> getInvestmentDetails() async {
    try {
      var getInvDets = await MapInvestmentDetails.mapInvestmentDetails();
      log("getInvDets -> $getInvDets");
      if (getInvDets["success"]) {
        investmentDetails = getInvDets["data"][0];
        log("investmentDetails -> $investmentDetails");
        accountInvestments = investmentDetails["investmentDetails"];
        log("accountInvestments -> $accountInvestments");
      } else {
        if (context.mounted) {
          showAdaptiveDialog(
            context: context,
            builder: (context) {
              return CustomDialog(
                svgAssetPath: ImageConstants.warning,
                title: "Sorry",
                message: getInvDets["message"] ??
                    "There was an error in fetching your investment details, please try again later.",
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
  }

  Future<void> getInvitationAuthorization() async {
    try {
      var getInvAuth =
          await MapAuthorizedToSendInvitations.mapAuthorizedToSendInvitations();
      log("getInvAuth -> $getInvAuth");
      if (getInvAuth["success"]) {
        canSendInv = true;
      } else {
        canSendInv = false;
      }
    } catch (e) {
      log(e.toString());
    }
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

  Future<void> getTransactionHistory() async {
    log("getTxnHistory Req -> ${{
      "accountNumber": cardNumber,
      "startDate": DateFormat('yyyy-MM-dd')
          .format(DateTime.now().subtract(const Duration(days: 90))),
      "endDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
    }}");
    var getTxnHistory = await MapTransactionHistory.mapTransactionHistory(
      {
        "accountNumber": cardNumber,
        "startDate": DateFormat('yyyy-MM-dd')
            .format(DateTime.now().subtract(const Duration(days: 90))),
        "endDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
      },
    );
    log("getTxnHistory -> $getTxnHistory");
    transactionDetails.clear();
    if (getTxnHistory["success"]) {
      log('transactionDetails after clear -> $transactionDetails');
      transactionDetails.addAll(getTxnHistory["data"][0]["transactionDetails"]);
      log("transactionDetails length -> ${transactionDetails.length}");
      log("transactionDetails after addAll -> $transactionDetails");
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
    final TabbarBloc tabbarBloc = context.read<TabbarBloc>();
    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        PromptExit.promptUser(context, true);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: AppBarAvatar(
            imgUrl: profilePhotoBase64 ?? "",
            name: profileName ?? "",
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.profileHome,
                arguments: DashboardArgumentModel(
                  onboardingState: dashboardArgument.onboardingState,
                ).toMap(),
              );
            },
          ),
          title: SvgPicture.asset(
            ImageConstants.appBarLogo,
          ),
          actions: const [AppBarAction()],
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0,
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Ternary(
              condition: isLoading,
              truthy: const ShimmerDashboardLocked(),
              falsy: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Ternary(
                    condition: dashboardArgument.onboardingState < 8,
                    truthy: const SizeBox(),
                    falsy: DefaultTabController(
                      length: 3,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: (PaddingConstants.horizontalPadding /
                                  Dimensions.designWidth)
                              .w,
                        ),
                        child: Row(
                          children: [
                            BlocBuilder<TabbarBloc, TabbarState>(
                              builder: (context, state) {
                                return TabBar(
                                  padding: EdgeInsets.zero,
                                  labelPadding: EdgeInsets.zero,
                                  splashFactory: NoSplash.splashFactory,
                                  overlayColor:
                                      MaterialStateProperty.all<Color>(
                                    Colors.transparent,
                                  ),
                                  controller: tabController,
                                  onTap: (index) async {
                                    final ShowButtonBloc showButtonBloc =
                                        context.read<ShowButtonBloc>();
                                    _scrollOffset = 0;
                                    _scrollIndex = 0;
                                    if (index == 1) {
                                      if (cardFreezeApp) {
                                        tabController.index = 0;
                                        promptCardBlocked();
                                      } else {
                                        setState(() {
                                          isUpdatingInv = true;
                                        });
                                        await getInvestmentDetails();
                                        setState(() {
                                          isUpdatingInv = false;
                                        });
                                      }
                                    }
                                    if (index == 2) {
                                      if (cardFreezeApp) {
                                        tabController.index = 0;
                                        promptCardBlocked();
                                      } else {
                                        setState(() {
                                          isUpdatingInv = true;
                                        });
                                        await getReferralDetails();
                                        setState(() {
                                          isUpdatingInv = false;
                                        });
                                      }
                                    }

                                    tabbarBloc.add(TabbarEvent(index: index));
                                    showButtonBloc
                                        .add(const ShowButtonEvent(show: true));
                                  },
                                  indicatorColor: Colors.transparent,
                                  tabs: [
                                    Tab(
                                      child: CustomTab(
                                        title: "Home",
                                        isSelected: tabController.index == 0,
                                      ),
                                    ),
                                    Tab(
                                      child: CustomTab(
                                          title: "Investment",
                                          isSelected: tabController.index == 1),
                                    ),
                                    Tab(
                                      child: CustomTab(
                                          title: "Referral",
                                          isSelected: tabController.index == 2),
                                    ),
                                  ],
                                  tabAlignment: TabAlignment.start,
                                  dividerHeight: 0,
                                  isScrollable: true,
                                  labelColor: Colors.black,
                                  labelStyle: TextStyles.primaryMedium.copyWith(
                                    color: const Color(0xFF000000),
                                    fontSize:
                                        (PaddingConstants.horizontalPadding /
                                                Dimensions.designWidth)
                                            .w,
                                  ),
                                  unselectedLabelColor: Colors.black,
                                  unselectedLabelStyle:
                                      TextStyles.primaryMedium.copyWith(
                                    color: const Color(0xFF000000),
                                    fontSize:
                                        (PaddingConstants.horizontalPadding /
                                                Dimensions.designWidth)
                                            .w,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Ternary(
                    condition: dashboardArgument.onboardingState < 8,
                    truthy: const SizeBox(),
                    falsy: BlocBuilder<ShowButtonBloc, ShowButtonState>(
                      builder: (context, state) {
                        return SizedBox(
                          height: 100.h -
                              ((tabController.index == 2 ? 180 : 280) /
                                      Dimensions.designHeight)
                                  .h,
                          child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: tabController,
                            children: [
                              // ! Cards Tab View
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizeBox(height: 10),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          (PaddingConstants.horizontalPadding /
                                                  Dimensions.designWidth)
                                              .w,
                                    ),
                                    child: Ternary(
                                      condition:
                                          stepsCompleted < 3 || cardFreezeApp,
                                      truthy: Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          Blur(
                                            blur: 2.5,
                                            // blurColor: AppColors.dark10,
                                            child: Container(
                                              width:
                                                  (393 / Dimensions.designWidth)
                                                      .w,
                                              height: (232 /
                                                      Dimensions.designHeight)
                                                  .h,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular((20 /
                                                          Dimensions
                                                              .designWidth)
                                                      .w),
                                                ),
                                                // boxShadow: [BoxShadows.primary],
                                              ),
                                              child: CustomFlipCard(
                                                cardKey: cardKey,
                                                cardNumber: cardNumber,
                                                iban: iban,
                                                expiryDate: cardExpiryDate,
                                                cardHolderName:
                                                    "${cardHolderName.split(' ').first} ${cardHolderName.split(' ').last}",
                                                cvv: cvv,
                                                currentBalance: currentBalance,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            child: Column(
                                              children: [
                                                SvgPicture.asset(
                                                  ImageConstants.lock,
                                                  width: (25 /
                                                          Dimensions
                                                              .designWidth)
                                                      .w,
                                                  height: (28 /
                                                          Dimensions
                                                              .designHeight)
                                                      .h,
                                                ),
                                                const SizeBox(height: 50),
                                                Container(
                                                  width: (160 /
                                                          Dimensions
                                                              .designWidth)
                                                      .w,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular((5 /
                                                              Dimensions
                                                                  .designWidth)
                                                          .w),
                                                    ),
                                                    color:
                                                        const Color(0XFFF4E0AC),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: (6 /
                                                              Dimensions
                                                                  .designHeight)
                                                          .h),
                                                  child: Center(
                                                    child: Text(
                                                      "Card Frozen",
                                                      style: TextStyles
                                                          .primaryBold
                                                          .copyWith(
                                                        fontSize: (16 /
                                                                Dimensions
                                                                    .designWidth)
                                                            .w,
                                                        color:
                                                            AppColors.dark100,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizeBox(height: 20),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      falsy: CustomFlipCard(
                                        cardKey: cardKey,
                                        cardNumber: cardNumber,
                                        iban: iban,
                                        expiryDate: cardExpiryDate,
                                        cardHolderName:
                                            "${cardHolderName.split(' ').first} ${cardHolderName.split(' ').last}",
                                        cvv: cvv,
                                        currentBalance: currentBalance,
                                      ),
                                    ),
                                  ),
                                  const SizeBox(height: 10),
                                  Ternary(
                                    condition: stepsCompleted < 3,
                                    truthy: const SizeBox(),
                                    falsy: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: (PaddingConstants
                                                    .horizontalPadding /
                                                Dimensions.designWidth)
                                            .w,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Opacity(
                                            opacity: cardFreezeApp ? 0.5 : 1,
                                            child: DashboardActionButton(
                                              onTap: () {
                                                if (!cardFreezeApp) {
                                                  Navigator.pushNamed(
                                                      context, Routes.addFunds);
                                                }
                                              },
                                              svgName: ImageConstants.add,
                                              text: "Add Funds",
                                            ),
                                          ),
                                          const SizeBox(width: 10),
                                          Opacity(
                                            opacity: cardFreezeApp ? 0.5 : 1,
                                            child: DashboardActionButton(
                                              onTap: () {
                                                if (!cardFreezeApp) {
                                                  Navigator.pushNamed(
                                                    context,
                                                    Routes.transferOutList,
                                                    arguments:
                                                        BeneficiaryListArgumentModel(
                                                      isBeneficiary: false,
                                                    ).toMap(),
                                                  );
                                                }
                                              },
                                              svgName: ImageConstants.moveUp,
                                              text: "Transfer Out",
                                            ),
                                          ),
                                          const SizeBox(width: 10),
                                          Opacity(
                                            opacity: cardFreezeApp ? 0.5 : 1,
                                            child: DashboardActionButton(
                                              onTap: () {
                                                if (!cardFreezeApp) {
                                                  Navigator.pushNamed(
                                                    context,
                                                    Routes.transferOutList,
                                                    arguments:
                                                        BeneficiaryListArgumentModel(
                                                      isBeneficiary: true,
                                                    ).toMap(),
                                                  );
                                                }
                                              },
                                              svgName: ImageConstants.group,
                                              text: "Beneficiary",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizeBox(height: 15),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          (PaddingConstants.horizontalPadding /
                                                  Dimensions.designWidth)
                                              .w,
                                    ),
                                    child: Text(
                                      // ! Frozen
                                      "Save. Earn. Prosper",
                                      style: TextStyles.primaryBold.copyWith(
                                        fontSize:
                                            (16 / Dimensions.designWidth).w,
                                        color: AppColors.dark100,
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
                                                ? (PaddingConstants
                                                            .horizontalPadding /
                                                        Dimensions.designWidth)
                                                    .w
                                                : 0,
                                            right: index == banners.length - 1
                                                ? (PaddingConstants
                                                            .horizontalPadding /
                                                        Dimensions.designWidth)
                                                    .w
                                                : 0,
                                          ),
                                          child: SizedBox(
                                            width:
                                                (340 / Dimensions.designWidth)
                                                    .w,
                                            child: InkWell(
                                              onTap: () async {
                                                if (isClickable) {
                                                  isClickable = false;
                                                  portfolioBeingInvested =
                                                      portfolios[index]
                                                              ["portfolioName"]
                                                          .toUpperCase();
                                                  log("portfolioBeingInvested -> $portfolioBeingInvested");
                                                  forecastMaxLimit = portfolios[
                                                              index]
                                                          ["forecastMaxLimit"]
                                                      .toDouble();
                                                  forecastMinLimit = portfolios[
                                                              index]
                                                          ["forecastMinLimit"]
                                                      .toDouble();

                                                  log("getPortDets req -> ${{
                                                    "portfolioId":
                                                        portfolios[index]["id"]
                                                  }}");
                                                  try {
                                                    var getPortDets =
                                                        await MapPortfolioDetails
                                                            .mapPortfolioDetails({
                                                      "portfolioId":
                                                          portfolios[index]
                                                              ["id"]
                                                    });
                                                    log("getPortDets -> $getPortDets");
                                                    if (getPortDets[
                                                        "success"]) {
                                                      benefitDetails =
                                                          getPortDets["data"][0]
                                                              ["benefits"];
                                                      htmlContent =
                                                          getPortDets["data"][0]
                                                              ["portfolioDesc"];
                                                    }
                                                    if (context.mounted) {
                                                      log("Plan Type Id -> ${portfolios[index]["id"]}");
                                                      Navigator.pushNamed(
                                                        context,
                                                        Routes.plan,
                                                        arguments:
                                                            PlanArgumentModel(
                                                          planType:
                                                              portfolios[index]
                                                                  ["id"],
                                                          isExplore: false,
                                                          onboardingState:
                                                              dashboardArgument
                                                                  .onboardingState,
                                                        ).toMap(),
                                                      );
                                                    }
                                                  } catch (e) {
                                                    log(e.toString());
                                                  }
                                                  isClickable = true;
                                                }
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
                                  SizeBox(
                                      height:
                                          dashboardArgument.onboardingState < 8
                                              ? 60
                                              : 60),
                                  Ternary(
                                    condition: stepsCompleted < 3,
                                    truthy: OnboardingProgress(
                                      stepsCompleted: 2,
                                      onTap1: () {},
                                      onTap2: () {},
                                      onTap3: () {},
                                    ),
                                    falsy: const SizeBox(height: 140),
                                  ),
                                ],
                              ),
                              // ! Investments Tab View
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        (PaddingConstants.horizontalPadding /
                                                Dimensions.designWidth)
                                            .w),
                                child: Column(
                                  children: [
                                    const SizeBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Total Investments",
                                              style: TextStyles.primaryBold
                                                  .copyWith(
                                                fontSize: (14 /
                                                        Dimensions.designWidth)
                                                    .w,
                                                color: AppColors.dark100,
                                              ),
                                            ),
                                            const SizeBox(height: 10),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  NumberFormatter.numberFormat(
                                                      investmentDetails[
                                                              "totalInvestments"]
                                                          .toDouble()),
                                                  // investmentDetails[
                                                  //             "totalInvestments"] >=
                                                  //         1000
                                                  //     ? NumberFormat('#,000.00')
                                                  //         .format(investmentDetails[
                                                  //             "totalInvestments"])
                                                  //     : investmentDetails[
                                                  //             "totalInvestments"]
                                                  //         .toStringAsFixed(2),
                                                  style: TextStyles.primaryBold
                                                      .copyWith(
                                                    fontSize: (30 /
                                                            Dimensions
                                                                .designWidth)
                                                        .w,
                                                    color: AppColors.dark100,
                                                  ),
                                                ),
                                                const SizeBox(width: 4),
                                                Text(
                                                  "AED",
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
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "Total Returns",
                                              style: TextStyles.primaryMedium
                                                  .copyWith(
                                                fontSize: (14 /
                                                        Dimensions.designWidth)
                                                    .w,
                                                color: AppColors.dark80,
                                              ),
                                            ),
                                            const SizeBox(height: 10),
                                            Text(
                                              NumberFormatter.numberFormat(
                                                  investmentDetails["netReturn"]
                                                      .toDouble()),
                                              style: TextStyles.primaryMedium
                                                  .copyWith(
                                                fontSize: (20 /
                                                        Dimensions.designWidth)
                                                    .w,
                                                color: AppColors.green100,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizeBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Portfolios",
                                          style:
                                              TextStyles.primaryBold.copyWith(
                                            fontSize:
                                                (16 / Dimensions.designWidth).w,
                                            color: AppColors.dark100,
                                          ),
                                        ),
                                        CapsuleIconButton(
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              Routes.investmentZone,
                                              arguments: PlanArgumentModel(
                                                planType: 1,
                                                isExplore: false,
                                                onboardingState:
                                                    dashboardArgument
                                                        .onboardingState,
                                              ).toMap(),
                                            );
                                          },
                                          text: "Add",
                                          icon: Icons.add,
                                        ),
                                      ],
                                    ),
                                    const SizeBox(height: 10),
                                    SizedBox(
                                      height: (155 / Dimensions.designHeight).h,
                                      child: Ternary(
                                        condition: investmentDetails[
                                                "investmentDetails"]
                                            .isEmpty,
                                        truthy: const SizeBox(),
                                        falsy: Row(
                                          children: [
                                            Expanded(
                                              child: ListView.separated(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                separatorBuilder:
                                                    (context, index) {
                                                  return const SizeBox(
                                                      width: 10);
                                                },
                                                itemCount: investmentDetails[
                                                        "investmentDetails"]
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  return PortfolioTile(
                                                    onTap: () {
                                                      globalPortfolioDetails =
                                                          investmentDetails[
                                                                  "investmentDetails"]
                                                              [index];
                                                      portfolioBeingInvested =
                                                          investmentDetails[
                                                                          "investmentDetails"]
                                                                      [index][
                                                                  "portfolioCode"]
                                                              .toUpperCase();
                                                      log("portfolioBeingInvested -> $portfolioBeingInvested");
                                                      forecastMaxLimit =
                                                          portfolios[index][
                                                                  "forecastMaxLimit"]
                                                              .toDouble();
                                                      forecastMinLimit =
                                                          portfolios[index][
                                                                  "forecastMinLimit"]
                                                              .toDouble();
                                                      amountInvestedPortfolio =
                                                          investmentDetails[
                                                                          "investmentDetails"]
                                                                      [index][
                                                                  "amountInvestedPortfolio"]
                                                              .toDouble();
                                                      clientPortfolioValue =
                                                          investmentDetails[
                                                                          "investmentDetails"]
                                                                      [index][
                                                                  "clientPortfolioValue"]
                                                              .toDouble();
                                                      // marketValuePortfolio =
                                                      //     investmentDetails[
                                                      //                     "investmentDetails"]
                                                      //                 [index][
                                                      //             "marketValue"]
                                                      //         .toDouble();
                                                      Navigator.pushNamed(
                                                        context,
                                                        Routes.rtPortfolio,
                                                      );
                                                    },
                                                    type: investmentDetails[
                                                            "investmentDetails"]
                                                        [
                                                        index]["portfolioCode"],
                                                    minAmount: NumberFormatter
                                                        .numberFormat(investmentDetails[
                                                                        "investmentDetails"]
                                                                    [index][
                                                                "clientPortfolioValue"]
                                                            .toDouble()),
                                                    maxAmount: NumberFormatter
                                                        .numberFormat(
                                                            investmentDetails[
                                                                    "totalInvestments"]
                                                                .toDouble()),
                                                    progress: investmentDetails[
                                                                "totalInvestments"] ==
                                                            0
                                                        ? "0"
                                                        : ((investmentDetails["investmentDetails"]
                                                                            [
                                                                            index]
                                                                        [
                                                                        "clientPortfolioValue"] /
                                                                    investmentDetails[
                                                                        "totalInvestments"]) *
                                                                100)
                                                            .toStringAsFixed(0),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // const SizeBox(height: 200),
                                  ],
                                ),
                              ),
                              // ! Referral Tab View
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        (PaddingConstants.horizontalPadding /
                                                Dimensions.designWidth)
                                            .w),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          const SizeBox(height: 85),
                                          Text(
                                            "Invite your friends",
                                            style:
                                                TextStyles.primaryBold.copyWith(
                                              fontSize:
                                                  (20 / Dimensions.designWidth)
                                                      .w,
                                              color: AppColors.dark100,
                                            ),
                                          ),
                                          const SizeBox(height: 10),
                                          Text(
                                            "Get Rewarded",
                                            style: TextStyles.primaryMedium
                                                .copyWith(
                                              fontSize:
                                                  (16 / Dimensions.designWidth)
                                                      .w,
                                              color: AppColors.dark80,
                                            ),
                                          ),
                                          const SizeBox(height: 20),
                                          SvgPicture.asset(
                                              ImageConstants.database),
                                          // const SizeBox(height: 10),
                                          SizedBox(
                                            width: 65.w,
                                            child: Text(
                                              "Refer 5 friends and you will receive AED ${(refVal * 5).toStringAsFixed(0)} bonus in your wallet to invest into a portfolio of your choice.",
                                              style: TextStyles.primaryMedium
                                                  .copyWith(
                                                fontSize: (14 /
                                                        Dimensions.designWidth)
                                                    .w,
                                                color: AppColors.dark80,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          const SizeBox(height: 10),
                                          InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                backgroundColor:
                                                    Colors.transparent,
                                                builder: (context) {
                                                  return SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.35,
                                                    child:
                                                        const ExplainerBottomSheet(
                                                      title: "How it works",
                                                      description:
                                                          "If you are an existing Investnation client, share your referral code or link with a friend to use during the sign-up process.\n\nThe code/link can be found on your Investnation account.\n\nYour 5 friends must meet the minimum investment requirement of AED 1,000 invested into portfolios.\n\nThe referral bonus will be credited to your wallet with a 90 day validity period.\n\nThis referral bonus must be invested into a portfolio of your choice and cannot be withdrawn/transferred or cashed out.",
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Text(
                                              "How it works",
                                              style: TextStyles.primaryMedium
                                                  .copyWith(
                                                fontSize: (14 /
                                                        Dimensions.designWidth)
                                                    .w,
                                                color: AppColors.primary80,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          const SizeBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Total earned",
                                                style: TextStyles.primaryBold
                                                    .copyWith(
                                                  fontSize: (14 /
                                                          Dimensions
                                                              .designWidth)
                                                      .w,
                                                  color: AppColors.dark100,
                                                ),
                                              ),
                                              Text(
                                                "AED ${NumberFormatter.numberFormat(referralBonusBalance)}",
                                                // ${referralBonusBalance >= 1000 ? NumberFormat('#,000.00').format(referralBonusBalance) : referralBonusBalance.toStringAsFixed(2)}",
                                                style: TextStyles.primaryMedium
                                                    .copyWith(
                                                  fontSize: (14 /
                                                          Dimensions
                                                              .designWidth)
                                                      .w,
                                                  color: AppColors.dark100,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizeBox(height: 15),
                                          ReferralTabs(
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  Routes.referralDetails);
                                            },
                                            // inviteCount: 2,
                                            registeredCount:
                                                registeredUsers.length,
                                            completedCount:
                                                completedUsers.length,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Ternary(
                                          condition: canSendInv,
                                          truthy: BlocBuilder<ShowButtonBloc,
                                              ShowButtonState>(
                                            builder: (context, state) {
                                              return GradientButton(
                                                onTap: () async {
                                                  if (!isReferring) {
                                                    ShowButtonBloc
                                                        showButtonBloc =
                                                        context.read<
                                                            ShowButtonBloc>();
                                                    isReferring = true;
                                                    showButtonBloc
                                                        .add(ShowButtonEvent(
                                                      show: isReferring,
                                                    ));

                                                    try {
                                                      var createRefCodeRes =
                                                          await MapCreateReferralCode
                                                              .mapCreateReferralCode();
                                                      log("createRefCodeRes -> $createRefCodeRes");
                                                      if (createRefCodeRes[
                                                          "success"]) {
                                                        Share.share(
                                                            "This is my referral code: ${createRefCodeRes["referralCode"]} \n Hey, I use InvestNation to manage my savings across multiple portfolios depending on your choice and your risk profile. \nInvestNation is a simple and easy to use platform that provides rewardfull investing \nhttps://investnation.com");
                                                      } else {
                                                        if (context.mounted) {
                                                          showAdaptiveDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return CustomDialog(
                                                                svgAssetPath:
                                                                    ImageConstants
                                                                        .warning,
                                                                title: "Sorry",
                                                                message: createRefCodeRes[
                                                                        "message"] ??
                                                                    "There was an error in generating your referral code, please try again later.",
                                                                actionWidget:
                                                                    GradientButton(
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
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

                                                    isReferring = false;
                                                    showButtonBloc
                                                        .add(ShowButtonEvent(
                                                      show: isReferring,
                                                    ));
                                                  }
                                                },
                                                text: "Invite Friends",
                                                auxWidget: isReferring
                                                    ? const LoaderRow()
                                                    : const SizeBox(),
                                              );
                                            },
                                          ),
                                          falsy: SolidButton(
                                            onTap: () {},
                                            text: "Invite Friends",
                                          ),
                                        ),
                                        // const SizeBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.pushNamed(context,
                                                    Routes.termsAndConditions);
                                              },
                                              child: Text(
                                                "Terms & Conditions",
                                                style: TextStyles.primaryMedium
                                                    .copyWith(
                                                  fontSize: (14 /
                                                          Dimensions
                                                              .designWidth)
                                                      .w,
                                                  color: AppColors.primary80,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Text(
                                              " applied",
                                              style: TextStyles.primaryMedium
                                                  .copyWith(
                                                fontSize: (14 /
                                                        Dimensions.designWidth)
                                                    .w,
                                                color: AppColors.dark100,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizeBox(
                                              height: (PaddingConstants
                                                              .bottomPadding /
                                                          Dimensions
                                                              .designHeight)
                                                      .h +
                                                  MediaQuery.paddingOf(context)
                                                      .bottom,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Ternary(
                    condition: !(dashboardArgument.onboardingState < 8),
                    truthy: const SizeBox(),
                    falsy: SizedBox(
                      height: 100.h - (221 / Dimensions.designHeight).h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: (PaddingConstants.horizontalPadding /
                                      Dimensions.designWidth)
                                  .w,
                            ),
                            child: Ternary(
                              condition: dashboardArgument.onboardingState < 8,
                              truthy: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Blur(
                                    blur: 2.5,
                                    // blurColor: AppColors.dark10,
                                    child: Container(
                                      width: (393 / Dimensions.designWidth).w,
                                      height: (232 / Dimensions.designHeight).h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              (20 / Dimensions.designWidth).w),
                                        ),
                                        // boxShadow: [BoxShadows.primary],
                                      ),
                                      child: CustomFlipCard(
                                        cardKey: cardKey,
                                        cardNumber: cardNumber,
                                        iban: iban,
                                        expiryDate: cardExpiryDate,
                                        cardHolderName:
                                            "${cardHolderName.split(' ').first} ${cardHolderName.split(' ').last}",
                                        cvv: cvv,
                                        currentBalance: currentBalance,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                          ImageConstants.lock,
                                          width:
                                              (25 / Dimensions.designWidth).w,
                                          height:
                                              (28 / Dimensions.designHeight).h,
                                        ),
                                        const SizeBox(height: 50),
                                        Container(
                                          width:
                                              (160 / Dimensions.designWidth).w,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  (5 / Dimensions.designWidth)
                                                      .w),
                                            ),
                                            color: const Color(0XF8EFDBCC),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical:
                                                  (6 / Dimensions.designHeight)
                                                      .h),
                                          child: Center(
                                            child: Text(
                                              "Card Frozen",
                                              style: TextStyles.primaryBold
                                                  .copyWith(
                                                fontSize: (16 /
                                                        Dimensions.designWidth)
                                                    .w,
                                                color: AppColors.dark100,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizeBox(height: 20),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              falsy: CustomFlipCard(
                                cardKey: cardKey,
                                cardNumber: cardNumber,
                                iban: iban,
                                expiryDate: cardExpiryDate,
                                cardHolderName:
                                    "${cardHolderName.split(' ').first} ${cardHolderName.split(' ').last}",
                                cvv: cvv,
                                currentBalance: currentBalance,
                              ),
                            ),
                          ),
                          const SizeBox(height: 10),
                          // Align(
                          //   alignment: Alignment.center,
                          //   child: Text(
                          //     "Powered by Finance House",
                          //     style: TextStyles.primaryMedium.copyWith(
                          //       fontSize: (14 / Dimensions.designWidth).w,
                          //       color: AppColors.dark50,
                          //     ),
                          //   ),
                          // ),
                          // const SizeBox(height: 15),
                          Ternary(
                            condition: dashboardArgument.onboardingState < 8,
                            truthy: const SizeBox(),
                            falsy: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    (PaddingConstants.horizontalPadding /
                                            Dimensions.designWidth)
                                        .w,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  DashboardActionButton(
                                    onTap: () {},
                                    svgName: ImageConstants.add,
                                    text: "Add Funds",
                                  ),
                                  const SizeBox(width: 10),
                                  DashboardActionButton(
                                    onTap: () {},
                                    svgName: ImageConstants.moveUp,
                                    text: "Transfer Out",
                                  ),
                                  const SizeBox(width: 10),
                                  DashboardActionButton(
                                    onTap: () {},
                                    svgName: ImageConstants.group,
                                    text: "Beneficiary",
                                  ),
                                ],
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
                            child: Text(
                              "Save. Earn. Prosper",
                              style: TextStyles.primaryBold.copyWith(
                                fontSize: (16 / Dimensions.designWidth).w,
                                color: AppColors.dark100,
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
                                    right: index == banners.length - 1
                                        ? (PaddingConstants.horizontalPadding /
                                                Dimensions.designWidth)
                                            .w
                                        : 0,
                                  ),
                                  child: SizedBox(
                                    width: (370 / Dimensions.designWidth).w,
                                    child: InkWell(
                                      onTap: () async {
                                        if (isClickable) {
                                          isClickable = false;
                                          portfolioBeingInvested =
                                              portfolios[index]["portfolioName"]
                                                  .toUpperCase();
                                          log("portfolioBeingInvested -> $portfolioBeingInvested");
                                          forecastMaxLimit = portfolios[index]
                                                  ["forecastMaxLimit"]
                                              .toDouble();
                                          forecastMinLimit = portfolios[index]
                                                  ["forecastMinLimit"]
                                              .toDouble();

                                          log("getPortDets req -> ${{
                                            "portfolioId": portfolios[index]
                                                ["id"]
                                          }}");
                                          try {
                                            var getPortDets =
                                                await MapPortfolioDetails
                                                    .mapPortfolioDetails({
                                              "portfolioId": portfolios[index]
                                                  ["id"]
                                            });
                                            log("getPortDets -> $getPortDets");
                                            if (getPortDets["success"]) {
                                              benefitDetails =
                                                  getPortDets["data"][0]
                                                      ["benefits"];
                                              htmlContent = getPortDets["data"]
                                                  [0]["portfolioDesc"];
                                            }
                                            if (context.mounted) {
                                              log("Plan Type Id -> ${portfolios[index]["id"]}");
                                              Navigator.pushNamed(
                                                context,
                                                Routes.plan,
                                                arguments: PlanArgumentModel(
                                                  planType: portfolios[index]
                                                      ["id"],
                                                  isExplore: false,
                                                  onboardingState:
                                                      dashboardArgument
                                                          .onboardingState,
                                                ).toMap(),
                                              );
                                            }
                                          } catch (e) {
                                            log(e.toString());
                                          }
                                          isClickable = true;
                                        }
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
                          const SizeBox(height: 20),
                          Ternary(
                            condition: dashboardArgument.onboardingState < 8,
                            truthy: OnboardingProgress(
                              stepsCompleted: dashboardArgument
                                          .onboardingState <
                                      2
                                  ? 0
                                  : dashboardArgument.onboardingState < 3
                                      ? 1
                                      : dashboardArgument.onboardingState < 8
                                          ? 2
                                          : 3,
                              onTap1: () {
                                if (dashboardArgument.onboardingState < 2) {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.verifyMobile,
                                    arguments: VerifyMobileArgumentModel(
                                            isBusiness: false,
                                            isUpdate: false,
                                            isReKyc: false)
                                        .toMap(),
                                  );
                                }
                              },
                              onTap2: () {
                                if (dashboardArgument.onboardingState == 2) {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.verificationInit,
                                    arguments:
                                        VerificationInitializationArgumentModel(
                                      isReKyc: false,
                                    ).toMap(),
                                  );
                                }
                              },
                              onTap3: () {
                                if (dashboardArgument.onboardingState == 3) {
                                  Navigator.pushNamed(
                                      context, Routes.applicationAddress);
                                } else if (dashboardArgument.onboardingState ==
                                    4) {
                                  Navigator.pushNamed(
                                      context, Routes.applicationIncome);
                                } else if (dashboardArgument.onboardingState ==
                                    5) {
                                  Navigator.pushNamed(
                                      context, Routes.applicationTaxFatca);
                                } else if (dashboardArgument.onboardingState ==
                                    6) {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.riskProfiling,
                                    arguments: PreRiskProfileArgumentModel(
                                      isInitial: true,
                                    ).toMap(),
                                  );
                                } else if (dashboardArgument.onboardingState ==
                                    7) {
                                  Navigator.pushNamed(
                                      context, Routes.acceptTermsAndConditions);
                                }
                              },
                            ),
                            falsy: const SizeBox(height: 150),
                          ),
                          SizeBox(
                              height: dashboardArgument.onboardingState < 8
                                  ? 20
                                  : 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            dashboardArgument.onboardingState < 8
                ? const SizeBox()
                : BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                      if (tabController.index == 2) {
                        return const SizeBox();
                      } else {
                        return DraggableScrollableSheet(
                          initialChildSize: 0.31,
                          minChildSize: 0.31,
                          maxChildSize: 1,
                          controller: _dsController,
                          builder: (context, scrollController) {
                            return ListView(
                              controller: scrollController,
                              children: [
                                // ! Outer Container
                                Container(
                                  height: 90.h,
                                  width: 100.w,
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        (PaddingConstants.horizontalPadding /
                                                Dimensions.designWidth)
                                            .w,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color: const Color(0XFFEEEEEE)),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                          (20 / Dimensions.designWidth).w),
                                      topRight: Radius.circular(
                                          (20 / Dimensions.designWidth).w),
                                    ),
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                  child: Column(
                                    children: [
                                      const SizeBox(height: 13),
                                      // ! Clip widget for drag
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical:
                                              (10 / Dimensions.designWidth).w,
                                        ),
                                        height: (7 / Dimensions.designWidth).w,
                                        width: (50 / Dimensions.designWidth).w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                (10 / Dimensions.designWidth)
                                                    .w),
                                          ),
                                          color: const Color(0xFFD9D9D9),
                                        ),
                                      ),
                                      const SizeBox(height: 15),
                                      Row(
                                        children: [
                                          Text(
                                            "Recent Transactions",
                                            style: TextStyles.primaryMedium
                                                .copyWith(
                                              fontSize:
                                                  (16 / Dimensions.designWidth)
                                                      .w,
                                              color: AppColors.dark80,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizeBox(height: 15),
                                      isLoading
                                          ? Center(
                                              child: SpinKitFadingCircle(
                                                color: AppColors.primary100,
                                                size: (50 /
                                                        Dimensions.designWidth)
                                                    .w,
                                              ),
                                            )
                                          : SizedBox(
                                              height: 82.5.h,
                                              child: Column(
                                                children: [
                                                  Ternary(
                                                    condition:
                                                        transactionDetails
                                                            .isEmpty,
                                                    truthy: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        // const SizeBox(height: 20),
                                                        Text(
                                                          "No transactions",
                                                          style: TextStyles
                                                              .primaryBold
                                                              .copyWith(
                                                            color: AppColors
                                                                .dark30,
                                                            fontSize: (24 /
                                                                    Dimensions
                                                                        .designWidth)
                                                                .w,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    falsy: Expanded(
                                                      child: ListView.builder(
                                                        controller:
                                                            scrollController,
                                                        itemCount:
                                                            transactionDetails
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return DashboardTransactionListTile(
                                                            isCredit: transactionDetails[
                                                                        index][
                                                                    "transactionType"] !=
                                                                "D",
                                                            title: transactionDetails[
                                                                    index][
                                                                "transactionDescription"],
                                                            name: transactionDetails[
                                                                    index][
                                                                "merchantName"],
                                                            amount: double.parse(
                                                                transactionDetails[
                                                                        index][
                                                                    "transactionAmount"]),
                                                            currency: "AED",
                                                            date: DateFormat(
                                                                    'EEE, MMM dd yyyy')
                                                                .format(DateTime.parse(
                                                                    transactionDetails[
                                                                            index]
                                                                        [
                                                                        "transactionDateTime"])),
                                                            onTap: () {},
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  const SizeBox(height: 15),
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
            BlocBuilder<ShowButtonBloc, ShowButtonState>(
              builder: (context, state) {
                if (tabController.index == 2) {
                  return const SizeBox();
                } else {
                  return CustomBottomNavBar(
                    onNotificationTap: () {
                      Navigator.pushNamed(context, Routes.notifications);
                    },
                    onExploreInvestTap: () {
                      if (cardFreezeApp) {
                        promptCardBlocked();
                      } else {
                        Navigator.pushNamed(
                          context,
                          Routes.investmentZone,
                          arguments: PlanArgumentModel(
                            planType: 1,
                            isExplore: false,
                            onboardingState: dashboardArgument.onboardingState,
                          ).toMap(),
                        );
                      }
                    },
                    onReferralTap: () async {
                      if (cardFreezeApp) {
                        promptCardBlocked();
                      } else {
                        if (storageCif != "UNREGISTERED") {
                          tabController.animateTo(2);

                          setState(() {
                            isUpdatingInv = true;
                          });
                          await getReferralDetails();
                          setState(() {
                            isUpdatingInv = false;
                          });
                        }
                      }
                    },
                    centerText:
                        storageCif == "UNREGISTERED" ? "Invest" : "Invest",
                  );
                }
              },
            ),
            isUpdatingInv
                ? Center(
                    child: SpinKitFadingCircle(
                      color: AppColors.primary100,
                      size: (50 / Dimensions.designWidth).w,
                    ),
                  )
                : const SizeBox(),
          ],
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
}
