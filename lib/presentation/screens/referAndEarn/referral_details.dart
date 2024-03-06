import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:investnation/bloc/showButton/index.dart';
import 'package:investnation/presentation/screens/common/index.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/presentation/widgets/referral/index.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:investnation/utils/helpers/index.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data/repository/referral/index.dart';

class ReferralDetailsScreen extends StatefulWidget {
  const ReferralDetailsScreen({super.key});

  @override
  State<ReferralDetailsScreen> createState() => _ReferralDetailsScreenState();
}

class _ReferralDetailsScreenState extends State<ReferralDetailsScreen> {
  bool isInviteSelected = false;
  bool isRegisteredSelected = true;
  bool isCompletedSelected = false;

  int invitedCount = 2;
  int registeredCount = registeredUsers.length;
  int completedCount = completedUsers.length;

  bool isReferring = false;

  @override
  Widget build(BuildContext context) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total earned",
                        style: TextStyles.primaryBold.copyWith(
                          fontSize: (14 / Dimensions.designWidth).w,
                          color: AppColors.dark100,
                        ),
                      ),
                      Text(
                        "AED ${NumberFormatter.numberFormat(referralBonusBalance)}",
                        style: TextStyles.primaryMedium.copyWith(
                          fontSize: (14 / Dimensions.designWidth).w,
                          color: AppColors.dark80,
                        ),
                      ),
                    ],
                  ),
                  const SizeBox(height: 15),
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: (PaddingConstants.horizontalPadding /
                                  Dimensions.designWidth)
                              .w,
                          vertical: (24 / Dimensions.designHeight).h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular((10 / Dimensions.designWidth).w),
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadows.primary,
                            BoxShadows.primaryInverted
                          ],
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // // ! Invites Sent
                              // InkWell(
                              //   onTap: () {
                              //     isInviteSelected = true;
                              //     isRegisteredSelected = false;
                              //     isCompletedSelected = false;
                              //     showButtonBloc.add(
                              //       ShowButtonEvent(show: isInviteSelected),
                              //     );
                              //   },
                              //   child: Padding(
                              //     padding: EdgeInsets.symmetric(
                              //       horizontal: (20 / Dimensions.designWidth).w,
                              //     ),
                              //     child: Column(
                              //       children: [
                              //         Text(
                              //           "Invites Sent",
                              //           style: TextStyles.primaryBold.copyWith(
                              //             fontSize:
                              //                 (14 / Dimensions.designWidth).w,
                              //             color: isInviteSelected
                              //                 ? AppColors.primary80
                              //                 : AppColors.dark80,
                              //           ),
                              //         ),
                              //         const SizeBox(height: 10),
                              //         Text(
                              //           "2",
                              //           style: TextStyles.primaryBold.copyWith(
                              //             fontSize:
                              //                 (20 / Dimensions.designWidth).w,
                              //             color: isInviteSelected
                              //                 ? AppColors.primary80
                              //                 : AppColors.dark80,
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // const VerticalDivider(
                              //   thickness: 0.5,
                              //   width: 0.5,
                              //   color: AppColors.dark50,
                              // ),
                              // ! Registered
                              InkWell(
                                onTap: () {
                                  isInviteSelected = false;
                                  isRegisteredSelected = true;
                                  isCompletedSelected = false;
                                  showButtonBloc.add(
                                    ShowButtonEvent(show: isRegisteredSelected),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: (20 / Dimensions.designWidth).w,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Registered",
                                        style: TextStyles.primaryBold.copyWith(
                                          fontSize:
                                              (14 / Dimensions.designWidth).w,
                                          color: isRegisteredSelected
                                              ? AppColors.primary80
                                              : AppColors.dark80,
                                        ),
                                      ),
                                      const SizeBox(height: 10),
                                      Text(
                                        "${registeredUsers.length}",
                                        style: TextStyles.primaryBold.copyWith(
                                          fontSize:
                                              (20 / Dimensions.designWidth).w,
                                          color: isRegisteredSelected
                                              ? AppColors.primary80
                                              : AppColors.dark80,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizeBox(width: 30),
                              const VerticalDivider(
                                thickness: 0.5,
                                width: 0.5,
                                color: AppColors.dark50,
                              ),
                              const SizeBox(width: 30),
                              // ! Completed
                              InkWell(
                                onTap: () {
                                  isInviteSelected = false;
                                  isRegisteredSelected = false;
                                  isCompletedSelected = true;
                                  showButtonBloc.add(
                                    ShowButtonEvent(show: isCompletedSelected),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: (20 / Dimensions.designWidth).w,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Completed",
                                        style: TextStyles.primaryBold.copyWith(
                                          fontSize:
                                              (14 / Dimensions.designWidth).w,
                                          color: isCompletedSelected
                                              ? AppColors.primary80
                                              : AppColors.dark80,
                                        ),
                                      ),
                                      const SizeBox(height: 10),
                                      Text(
                                        "${completedUsers.length}",
                                        style: TextStyles.primaryBold.copyWith(
                                          fontSize:
                                              (20 / Dimensions.designWidth).w,
                                          color: isCompletedSelected
                                              ? AppColors.primary80
                                              : AppColors.dark80,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizeBox(height: 16),
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                      if ((isInviteSelected && invitedCount == 0) ||
                          (isRegisteredSelected && registeredCount == 0) ||
                          (isCompletedSelected && completedCount == 0)) {
                        return Center(
                          child: Column(
                            children: [
                              const SizeBox(height: 143),
                              Text(
                                "Invite your friends",
                                style: TextStyles.primaryBold.copyWith(
                                  fontSize: (20 / Dimensions.designWidth).w,
                                  color: AppColors.dark100,
                                ),
                              ),
                              const SizeBox(height: 10),
                              Text(
                                "Get Rewarded",
                                style: TextStyles.primaryMedium.copyWith(
                                  fontSize: (16 / Dimensions.designWidth).w,
                                  color: AppColors.dark50,
                                ),
                              ),
                              const SizeBox(height: 20),
                              SvgPicture.asset(ImageConstants.database),
                              // const SizeBox(height: 10),
                              SizedBox(
                                width: 65.w,
                                child: Text(
                                  "Refer 5 friends and you will receive AED ${(refVal * 5).toStringAsFixed(0)} bonus in your wallet to invest into a portfolio of your choice.",
                                  style: TextStyles.primaryMedium.copyWith(
                                    fontSize: (14 / Dimensions.designWidth).w,
                                    color: AppColors.dark50,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizeBox(height: 10),
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) {
                                      return const ExplainerBottomSheet(
                                        title: "How it works",
                                        description:
                                            "If you are an existing Investnation client, share your referral code or link with a friend to use during the sign-up process.\n\nThe code/link can be found on your Investnation account.\n\nYour 5 friends must meet the minimum investment requirement of AED 1,000 invested into portfolios.\n\nThe referral bonus will be credited to your wallet with a 90 day validity period.\n\nThis referral bonus must be invested into a portfolio of your choice and cannot be withdrawn/transferred or cashed out.",
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  "How it works",
                                  style: TextStyles.primaryMedium.copyWith(
                                    fontSize: (14 / Dimensions.designWidth).w,
                                    color: AppColors.primary80,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: isInviteSelected
                                ? invitedCount
                                : isRegisteredSelected
                                    ? registeredCount
                                    : completedCount,
                            itemBuilder: (context, index) {
                              return ReferralListTile(
                                svgName: ImageConstants.mail,
                                title: isRegisteredSelected
                                    ? registeredUsers[index]["name"]
                                    : completedUsers[index]["name"],
                                subtitle: isRegisteredSelected
                                    ? registeredUsers[index]["emailId"]
                                    : completedUsers[index]["emailId"],
                                trailing:
                                    "Status: ${isRegisteredSelected ? registeredUsers[index]["onboardingStatus"] < 8 ? "Partial Registration" : "Registered" : "Completed"}",
                                date: isRegisteredSelected
                                    ? DateFormat('EEE, MMM dd yyyy').format(
                                        DateTime.parse(registeredUsers[index]
                                            ["registrationDate"]))
                                    : DateFormat('EEE, MMM dd yyyy').format(
                                        DateTime.parse(completedUsers[index]
                                            ["registrationDate"])),
                                onRemind: () {
                                  // showReminder();
                                },
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Column(
              children: [
                const SizeBox(height: 15),
                Ternary(
                  condition: canSendInv,
                  truthy: GradientButton(
                    onTap: () async {
                      if (!isReferring) {
                        ShowButtonBloc showButtonBloc =
                            context.read<ShowButtonBloc>();
                        isReferring = true;
                        showButtonBloc.add(ShowButtonEvent(
                          show: isReferring,
                        ));

                        try {
                          var createRefCodeRes = await MapCreateReferralCode
                              .mapCreateReferralCode();
                          log("createRefCodeRes -> $createRefCodeRes");
                          if (createRefCodeRes["success"]) {
                            Share.share(
                                "This is my referral code: ${createRefCodeRes["referralCode"]} \n Hey, I use InvestNation to manage my savings across multiple portfolios depending on your choice and your risk profile. \nInvestNation is a simple and easy to use platform that provides rewardfull investing \nhttps://investnation.com");
                          } else {
                            if (context.mounted) {
                              showAdaptiveDialog(
                                context: context,
                                builder: (context) {
                                  return CustomDialog(
                                    svgAssetPath: ImageConstants.warning,
                                    title: "Sorry",
                                    message: createRefCodeRes["message"] ??
                                        "There was an error in generating your referral code, please try again later.",
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

                        isReferring = false;
                        showButtonBloc.add(ShowButtonEvent(
                          show: isReferring,
                        ));
                      }
                    },
                    text: "Invite friend",
                  ),
                  falsy: SolidButton(
                    onTap: () {},
                    text: "Invite Friend",
                  ),
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

  void showReminder() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.checkCircleOutlined,
          title: "Reminder Sent",
          message: "A reminder has been sent.",
          actionWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
            },
            text: "Close",
          ),
        );
      },
    );
  }
}
