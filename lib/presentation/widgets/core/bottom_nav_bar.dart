// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:investnation/utils/constants/index.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key? key,
    required this.onNotificationTap,
    required this.onExploreInvestTap,
    required this.onReferralTap,
    required this.centerText,
  }) : super(key: key);

  final VoidCallback onNotificationTap;
  final VoidCallback onExploreInvestTap;
  final VoidCallback onReferralTap;
  final String centerText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizeBox(height: 55),
            Container(
              height: (93 / Dimensions.designHeight).h,
              width: 100.w,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(0, 0, 0, 0.05),
                    offset: Offset(0, (-4 / Dimensions.designWidth).w),
                    blurRadius: 5,
                  )
                ],
              ),
              padding: EdgeInsets.symmetric(
                horizontal: (PaddingConstants.horizontalPadding /
                        Dimensions.designWidth)
                    .w,
                vertical: (10 / Dimensions.designHeight).h,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: (PaddingConstants.horizontalPadding /
                          Dimensions.designWidth)
                      .w,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: onNotificationTap,
                          child: Column(
                            children: [
                              SvgPicture.asset(ImageConstants.bell),
                              const SizeBox(height: 4),
                              Text(
                                "Notification",
                                style: TextStyles.primaryBold.copyWith(
                                  fontSize: (12 / Dimensions.designWidth).w,
                                  color: AppColors.dark80,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizeBox(width: 150),
                        InkWell(
                          onTap: onReferralTap,
                          child: Column(
                            children: [
                              SvgPicture.asset(ImageConstants.people),
                              const SizeBox(height: 4),
                              Text(
                                "Referral",
                                style: TextStyles.primaryBold.copyWith(
                                  fontSize: (12 / Dimensions.designWidth).w,
                                  color: AppColors.dark80,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizeBox(
                      height:
                          // PaddingConstants.bottomPadding +
                          MediaQuery.paddingOf(context).bottom,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: (50 / Dimensions.designHeight).h,
          child: InkWell(
            onTap: onExploreInvestTap,
            child: Container(
              width: (90 / Dimensions.designWidth).w,
              height: (90 / Dimensions.designWidth).w,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [BoxShadows.primary, BoxShadows.primaryInverted]),
              child: Center(
                child: Container(
                  width: (75 / Dimensions.designWidth).w,
                  height: (75 / Dimensions.designWidth).w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary100,
                  ),
                  child: Center(
                    child: Text(
                      centerText,
                      style: TextStyles.primaryBold.copyWith(
                        fontSize: (16 / Dimensions.designWidth).w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
