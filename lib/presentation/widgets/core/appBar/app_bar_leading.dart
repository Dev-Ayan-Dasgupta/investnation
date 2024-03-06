import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';

class AppBarLeading extends StatelessWidget {
  const AppBarLeading({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ??
          () {
            bool canPop = Navigator.canPop(context);
            log("canPop -> $canPop");
            if (canPop) {
              Navigator.pop(context);
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return CustomDialog(
                    svgAssetPath: ImageConstants.warning,
                    title: "Exit App?",
                    message: "Do you really want to close the app?",
                    auxWidget: SolidButton(
                      boxShadow: [BoxShadows.primary],
                      color: Colors.white,
                      fontColor: AppColors.dark100,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      text: "No",
                    ),
                    actionWidget: GradientButton(
                      onTap: () {
                        if (Platform.isAndroid) {
                          Navigator.pop(context);
                          SystemNavigator.pop();
                        } else {
                          Navigator.pop(context);
                          exit(0);
                        }
                      },
                      text: "Yes",
                    ),
                  );
                },
              );
            }
          },
      child: Container(
        width: (30 / Dimensions.designWidth).w,
        height: (30 / Dimensions.designWidth).w,
        padding: EdgeInsets.all((20 / Dimensions.designWidth).w),
        child: SvgPicture.asset(
          ImageConstants.arrowBack,
        ),
      ),
    );
  }
}
