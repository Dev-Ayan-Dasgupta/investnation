import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:investnation/bloc/showButton/index.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/main.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:local_auth/local_auth.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool isEnabled = persistBiometric == true;
  bool isBioAvailable = true;

  @override
  void initState() {
    super.initState();
    checkBioAvailability();
  }

  Future<void> checkBioAvailability() async {
    List availableBiometrics =
        await LocalAuthentication().getAvailableBiometrics();
    isBioAvailable = availableBiometrics.isNotEmpty;
    log("isBioAvailable -> $isBioAvailable");
  }

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Security",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.dark100,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 20),
            Text(
              "Device preference",
              style: TextStyles.primaryMedium.copyWith(
                color: AppColors.dark80,
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 10),
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
                    "Biometric",
                    style: TextStyles.primary.copyWith(
                      color: const Color(0XFF979797),
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: buildBiometricSwitch,
                  ),
                ],
              ),
            ),
            const SizeBox(height: 20),
            InkWell(
              onTap: () {
                if (passwordChangesToday > 2) {
                  Navigator.pushNamed(
                    context,
                    Routes.errorSuccess,
                    arguments: ErrorArgumentModel(
                      hasSecondaryButton: false,
                      iconPath: ImageConstants.errorOutlined,
                      title: "Limit exceeded!",
                      message:
                          "Password cannot be changed more than thrice a day",
                      buttonText: labels[347]["labelText"],
                      onTap: () {
                        Navigator.pop(context);
                      },
                      buttonTextSecondary: "",
                      onTapSecondary: () {},
                    ).toMap(),
                  );
                } else {
                  Navigator.pushNamed(context, Routes.changePassword);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: (PaddingConstants.horizontalPadding /
                          Dimensions.designWidth)
                      .w,
                  vertical: (PaddingConstants.horizontalPadding /
                          Dimensions.designHeight)
                      .h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular((10 / Dimensions.designWidth).w),
                  ),
                  color: Colors.white,
                  boxShadow: [BoxShadows.primary],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Change Password",
                        style: TextStyles.primary.copyWith(
                          color: AppColors.dark100,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      ImageConstants.arrowForwardIos,
                      width: (12 / Dimensions.designWidth).w,
                      height: (16 / Dimensions.designHeight).h,
                      colorFilter: const ColorFilter.mode(
                        AppColors.dark80,
                        BlendMode.srcIn,
                      ),
                    ),
                    // const SizeBox(width: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBiometricSwitch(BuildContext context, ShowButtonState state) {
    final ShowButtonBloc isEnabledBloc = context.read<ShowButtonBloc>();
    return FlutterSwitch(
      width: (45 / Dimensions.designWidth).w,
      height: (25 / Dimensions.designHeight).h,
      activeColor: AppColors.green100,
      inactiveColor: AppColors.dark30,
      toggleSize: (15 / Dimensions.designWidth).w,
      value: isEnabled,
      onToggle: (val) async {
        if (isBioCapable) {
          if (isBioAvailable) {
            isEnabled = val;
            showDialog(
              context: context,
              builder: (context) {
                return CustomDialog(
                  svgAssetPath: ImageConstants.checkCircleOutlined,
                  title: isEnabled ? "Biometric enabled" : "Biometric Disabled",
                  message: isEnabled
                      ? "Enjoy the added convenience and security in using the app with biometric authentication."
                      : "You can turn on biometric authentication anytime from the profile menu.",
                  actionWidget: GradientButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    text: "Close",
                  ),
                );
              },
            );

            await storage.write(
                key: "persistBiometric", value: isEnabled.toString());
            persistBiometric =
                await storage.read(key: "persistBiometric") == "true";
            log("persistBiometric -> $persistBiometric");
            isEnabledBloc.add(ShowButtonEvent(show: isEnabled));
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return CustomDialog(
                  svgAssetPath: ImageConstants.warning,
                  title: "Biometric Not Setup",
                  message:
                      "Biometric has not been set up on this device. Please go to your phone's settings to set it up.",
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
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return CustomDialog(
                svgAssetPath: ImageConstants.warning,
                title: "Biometric Not Available",
                message:
                    "Your phone does not support biometric authentication.",
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
      },
    );
  }
}
