// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:investnation/presentation/widgets/dashboard/index.dart';
import 'package:investnation/utils/constants/index.dart';

class OnboardingProgress extends StatelessWidget {
  const OnboardingProgress({
    Key? key,
    required this.stepsCompleted,
    required this.onTap1,
    required this.onTap2,
    required this.onTap3,
  }) : super(key: key);

  final int stepsCompleted;
  final VoidCallback onTap1;
  final VoidCallback onTap2;
  final VoidCallback onTap3;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(
        horizontal:
            (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
        vertical: (16 / Dimensions.designHeight).h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(
            (20 / Dimensions.designWidth).w,
          ),
        ),
        boxShadow: [BoxShadows.primary, BoxShadows.primaryInverted],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stepsCompleted == 0
                ? "Let's get you onboarded"
                : "You're one step closer!",
            style: TextStyles.primaryBold.copyWith(
              fontSize: (16 / Dimensions.designWidth).w,
              color: AppColors.dark100,
            ),
          ),
          const SizeBox(height: 10),
          Row(
            children: [
              Container(
                width: ((stepsCompleted == 0
                            ? 10
                            : stepsCompleted == 1
                                ? 100
                                : stepsCompleted == 2
                                    ? 180
                                    : 280) /
                        Dimensions.designWidth)
                    .w,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      (10 / Dimensions.designWidth).w,
                    ),
                  ),
                  color: AppColors.primary100,
                ),
              ),
              const SizeBox(width: 5),
              Text(
                "${(stepsCompleted / 3 * 100).toInt()}% Complete",
                style: TextStyles.primaryMedium.copyWith(
                  fontSize: (14 / Dimensions.designWidth).w,
                  color: AppColors.dark80,
                ),
              ),
              const SizeBox(width: 5),
              Container(
                width: ((stepsCompleted == 0
                            ? 308
                            : stepsCompleted == 1
                                ? 198
                                : stepsCompleted == 2
                                    ? 98
                                    : 10) /
                        Dimensions.designWidth)
                    .w,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      (10 / Dimensions.designWidth).w,
                    ),
                  ),
                  color: AppColors.dark10,
                ),
              ),
            ],
          ),
          const SizeBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProgressTile(
                isDone: stepsCompleted > 0 ? true : false,
                onTap: onTap1,
                svgName: ImageConstants.verifyMobile,
                text: "Verify Mobile Number",
              ),
              const SizeBox(width: 10),
              ProgressTile(
                isDone: stepsCompleted > 1 ? true : false,
                onTap: onTap2,
                svgName: ImageConstants.scanID,
                text: "Scan ID Document",
              ),
              const SizeBox(width: 10),
              ProgressTile(
                isDone: stepsCompleted > 2 ? true : false,
                onTap: onTap3,
                svgName: ImageConstants.accountOpening,
                text: "Account Opening",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
