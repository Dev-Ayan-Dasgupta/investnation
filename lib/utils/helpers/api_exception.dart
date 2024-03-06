import 'package:flutter/material.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';

class ApiException {
  static void apiException(BuildContext context) {
    if (context.mounted) {
      showAdaptiveDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            svgAssetPath: ImageConstants.warning,
            title: "Sorry",
            message: "System Failure, Please try again later.",
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
}
