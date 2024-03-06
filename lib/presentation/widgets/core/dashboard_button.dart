// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:investnation/utils/constants/index.dart';

class DashboardActionButton extends StatelessWidget {
  const DashboardActionButton({
    Key? key,
    required this.onTap,
    required this.svgName,
    required this.text,
  }) : super(key: key);

  final VoidCallback onTap;
  final String svgName;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: (14 / Dimensions.designWidth).w,
          vertical: (10 / Dimensions.designHeight).h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular((5 / Dimensions.designWidth).w),
          ),
          color: Colors.white,
          boxShadow: [BoxShadows.primary],
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              svgName,
              width: (15 / Dimensions.designWidth).w,
              height: (15 / Dimensions.designWidth).w,
            ),
            const SizeBox(width: 5),
            Text(
              text,
              style: TextStyles.primaryBold.copyWith(
                fontSize: (14 / Dimensions.designWidth).w,
                color: AppColors.dark100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
