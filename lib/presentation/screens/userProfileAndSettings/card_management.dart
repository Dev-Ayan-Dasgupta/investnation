import 'dart:developer';

import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:investnation/bloc/showButton/index.dart';
import 'package:investnation/data/repository/accounts/index.dart';
import 'package:investnation/presentation/screens/common/index.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';

class CardManagementScreen extends StatefulWidget {
  const CardManagementScreen({super.key});

  @override
  State<CardManagementScreen> createState() => _CardManagementScreenState();
}

class _CardManagementScreenState extends State<CardManagementScreen> {
  // bool isCardFrozen = false;
  bool isClickable = true;

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
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Card Management",
                  style: TextStyles.primaryBold.copyWith(
                    color: AppColors.dark100,
                    fontSize: (28 / Dimensions.designWidth).w,
                  ),
                ),
                const SizeBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: (PaddingConstants.horizontalPadding /
                            Dimensions.designWidth)
                        .w,
                    vertical: (13 / Dimensions.designHeight).h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular((10 / Dimensions.designWidth).w),
                    ),
                    color: AppColors.dark5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Temporarily freeze card",
                        style: TextStyles.primary.copyWith(
                          color: const Color(0XFF979797),
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      BlocBuilder<ShowButtonBloc, ShowButtonState>(
                        builder: buildCardSwitch,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            !isClickable
                ? Center(
                    child: SpinKitFadingCircle(
                      color: AppColors.primary100,
                      size: (50 / Dimensions.designWidth).w,
                    ),
                  )
                : SizeBox(
                    width: 100.w,
                    height: 100.h,
                  ),
          ],
        ),
      ),
    );
  }

  Widget buildCardSwitch(BuildContext context, ShowButtonState state) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    return FlutterSwitch(
      width: (45 / Dimensions.designWidth).w,
      height: (25 / Dimensions.designHeight).h,
      activeColor: AppColors.green100,
      inactiveColor: AppColors.dark30,
      toggleSize: (15 / Dimensions.designWidth).w,
      value: cardFreezeApp,
      onToggle: (val) async {
        if (isClickable) {
          if (cardFreezeApp) {
            setState(() {
              isClickable = false;
            });

            log("Card freeze API Req -> ${{
              "isFreeze": false,
              "cardNumber": cardNumber,
            }}");
            try {
              var cardFreezeApiRes = await MapCardFreeze.mapCardFreeze(
                {
                  "isFreeze": false,
                  "cardNumber": cardNumber,
                },
              );
              log("cardFreezeApiRes -> $cardFreezeApiRes");
              setState(() {
                isClickable = true;
              });

              if (cardFreezeApiRes["success"]) {
                cardFreezeApp = !cardFreezeApp;
                if (cardFreezeApp) {
                  // ! Clevertap Event

                  Map<String, dynamic> cardBlockedUnblockedEventData = {
                    'email': profilePrimaryEmailId,
                    'lockDateTime':
                        DateFormat('yyyy-MM-dd').format(DateTime.now()),
                    'deviceId': deviceId,
                  };
                  CleverTapPlugin.recordEvent(
                    "Card Blocked/Unblocked",
                    cardBlockedUnblockedEventData,
                  );
                }
                if (context.mounted) {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return CustomDialog(
                        svgAssetPath: ImageConstants.checkCircleOutlined,
                        title: "Card is active",
                        message: "Start using your card now.",
                        actionWidget: GradientButton(
                          onTap: () {
                            Navigator.pop(context);
                            showButtonBloc
                                .add(ShowButtonEvent(show: cardFreezeApp));
                          },
                          text: "Close",
                        ),
                      );
                    },
                  );
                }
              } else {
                if (context.mounted) {
                  showAdaptiveDialog(
                    context: context,
                    builder: (context) {
                      return CustomDialog(
                        svgAssetPath: ImageConstants.warning,
                        title: "Sorry",
                        message: cardFreezeApiRes["message"] ??
                            "There was an error in unfreezing your card, please try again later.",
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
          } else {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return CustomDialog(
                  svgAssetPath: ImageConstants.warning,
                  title: "Are you sure?",
                  message: "You will be unable to use your card.",
                  auxWidget: BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                      return GradientButton(
                        onTap: () async {
                          showButtonBloc
                              .add(ShowButtonEvent(show: isClickable));
                          setState(() {
                            isClickable = false;
                          });

                          log("Card freeze API Req -> ${{
                            "isFreeze": true,
                            "cardNumber": cardNumber,
                          }}");
                          try {
                            var cardFreezeApiRes =
                                await MapCardFreeze.mapCardFreeze(
                              {
                                "isFreeze": true,
                                "cardNumber": cardNumber,
                              },
                            );
                            log("cardFreezeApiRes -> $cardFreezeApiRes");
                            setState(() {
                              isClickable = true;
                            });

                            if (cardFreezeApiRes["success"]) {
                              setState(() {
                                tabController.index = 0;
                              });
                              cardFreezeApp = !cardFreezeApp;
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            } else {
                              if (context.mounted) {
                                showAdaptiveDialog(
                                  context: context,
                                  builder: (context) {
                                    return CustomDialog(
                                      svgAssetPath: ImageConstants.warning,
                                      title: "Sorry",
                                      message: cardFreezeApiRes["message"] ??
                                          "There was an error in freezing your card, please try again later.",
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

                          showButtonBloc
                              .add(ShowButtonEvent(show: cardFreezeApp));
                        },
                        text: "Yes, I am sure",
                        auxWidget:
                            isClickable ? const SizeBox() : const LoaderRow(),
                      );
                    },
                  ),
                  actionWidget: SolidButton(
                    color: Colors.white,
                    fontColor: AppColors.dark100,
                    boxShadow: [BoxShadows.primary],
                    onTap: () {
                      Navigator.pop(context);
                    },
                    text: "No, go back",
                  ),
                );
              },
            );
          }
        }
      },
    );
  }
}
