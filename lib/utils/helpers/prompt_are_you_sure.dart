import 'package:flutter/material.dart';

import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';

class PromptAreYouSure {
  static void promptUser(BuildContext context, bool isInitial) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Are you sure?",
          message:
              "Going to the previous screen will make you repeat this step.",
          auxWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
              if (isInitial) {
                Navigator.pushReplacementNamed(
                  context,
                  Routes.onboarding,
                );
              } else {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            text: "Go Back",
          ),
          actionWidget: SolidButton(
            onTap: () {
              Navigator.pop(context);
            },
            text: "Cancel",
            color: AppColors.dark5,
            fontColor: AppColors.dark100,
          ),
        );
      },
    );
  }
}
