import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/main.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:local_auth/local_auth.dart';

class BiometricScreens extends StatefulWidget {
  const BiometricScreens({super.key});

  @override
  State<BiometricScreens> createState() => _BiometricScreensState();
}

class _BiometricScreensState extends State<BiometricScreens> {
  @override
  void initState() {
    super.initState();
    promptBiometric();
  }

  Future<void> promptBiometric() async {
    if (isBioCapable) {
      List availableBiometrics =
          await LocalAuthentication().getAvailableBiometrics();
      bool isBioAvailable = availableBiometrics.isNotEmpty;
      log("isBioAvailable -> $isBioAvailable");
      if (isBioAvailable) {
        if (context.mounted) {
          showAdaptiveDialog(
            context: context,
            builder: (context) {
              return CustomDialog(
                svgAssetPath: ImageConstants.warning,
                title: "Enable Biometric",
                message: "Enhance Security with Biometric Authentication",
                auxWidget: GradientButton(
                  onTap: () async {
                    await storage.write(key: "persistBiometric", value: "true");
                    persistBiometric =
                        await storage.read(key: "persistBiometric") == "true";
                    log("persistBiometric -> $persistBiometric");
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  text: "Enable Now",
                ),
                actionWidget: SolidButton(
                  boxShadow: [BoxShadows.primary],
                  fontColor: AppColors.dark100,
                  color: Colors.white,
                  onTap: () async {
                    await storage.write(
                        key: "persistBiometric", value: "false");
                    persistBiometric =
                        await storage.read(key: "persistBiometric") == "true";
                    log("persistBiometric -> $persistBiometric");
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  text: "Skip for Now",
                ),
              );
            },
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    ImageConstants.checkCircleOutlined,
                    width: (147 / Dimensions.designWidth).w,
                    height: (147 / Dimensions.designWidth).w,
                  ),
                  const SizeBox(height: 30),
                  Text(
                    "Your profile has been created",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark80,
                      fontSize: (24 / Dimensions.designWidth).w,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizeBox(height: 20),
                  SizedBox(
                    width: 60.w,
                    child: Text(
                      "Your profile has been created",
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.dark50,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                GradientButton(
                  onTap: () {
                    log("on tapped");
                    Navigator.pushReplacementNamed(
                      context,
                      Routes.verifyMobile,
                      arguments: VerifyMobileArgumentModel(
                              isBusiness: false,
                              isUpdate: false,
                              isReKyc: false)
                          .toMap(),
                    );
                  },
                  text: "Proceed with Verification",
                  auxWidget: const SizeBox(),
                ),
                Ternary(
                  condition: true,
                  truthy: Column(
                    children: [
                      const SizeBox(height: 15),
                      SolidButton(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            Routes.dashboard,
                            arguments: DashboardArgumentModel(
                              onboardingState: 0,
                            ).toMap(),
                          );
                        },
                        text: "Skip for Now",
                        boxShadow: [BoxShadows.primary],
                        color: Colors.white,
                        fontColor: AppColors.dark100,
                      ),
                    ],
                  ),
                  falsy: const SizeBox(),
                ),
                SizeBox(
                  height: PaddingConstants.bottomPadding +
                      MediaQuery.of(context).padding.bottom,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
