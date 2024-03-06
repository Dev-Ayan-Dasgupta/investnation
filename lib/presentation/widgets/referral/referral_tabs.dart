// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:investnation/presentation/widgets/referral/index.dart';
import 'package:investnation/utils/constants/index.dart';

class ReferralTabs extends StatelessWidget {
  const ReferralTabs({
    Key? key,
    required this.onTap,
    // required this.inviteCount,
    required this.registeredCount,
    required this.completedCount,
  }) : super(key: key);

  final VoidCallback onTap;
  // final int inviteCount;
  final int registeredCount;
  final int completedCount;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal:
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
          vertical: (24 / Dimensions.designHeight).h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular((10 / Dimensions.designWidth).w),
          ),
          color: Colors.white,
          boxShadow: [BoxShadows.primary, BoxShadows.primaryInverted],
        ),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ReferralColumns(
              //   title: "Invite Sent",
              //   count: inviteCount,
              //   isSelected: false,
              // ),
              // const VerticalDivider(
              //   thickness: 0.5,
              //   width: 0.5,
              //   color: AppColors.dark50,
              // ),
              ReferralColumns(
                title: "Registered",
                count: registeredCount,
                isSelected: false,
              ),
              const SizeBox(width: 30),
              const VerticalDivider(
                thickness: 0.5,
                width: 0.5,
                color: AppColors.dark50,
              ),
              const SizeBox(width: 30),
              ReferralColumns(
                title: "Completed",
                count: completedCount,
                isSelected: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
