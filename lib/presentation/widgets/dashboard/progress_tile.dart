// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:investnation/utils/constants/index.dart';

class ProgressTile extends StatelessWidget {
  const ProgressTile({
    Key? key,
    required this.isDone,
    required this.onTap,
    required this.svgName,
    required this.text,
  }) : super(key: key);

  final bool isDone;
  final VoidCallback onTap;
  final String svgName;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 29.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular((10 / Dimensions.designWidth).w),
          ),
          color: Colors.white,
          boxShadow: [BoxShadows.primary],
        ),
        padding: EdgeInsets.symmetric(
          horizontal:
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
          vertical: (10 / Dimensions.designHeight).h,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: SvgPicture.asset(
                isDone ? ImageConstants.checkCircle : ImageConstants.error,
                width: (20 / Dimensions.designWidth).w,
                height: (20 / Dimensions.designHeight).h,
              ),
            ),
            // const SizeBox(),
            Container(
              width: (58 / Dimensions.designWidth).w,
              height: (58 / Dimensions.designWidth).w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? AppColors.primary100 : AppColors.dark10,
              ),
              child: Center(
                child: Container(
                  width: (50 / Dimensions.designWidth).w,
                  height: (50 / Dimensions.designWidth).w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      svgName,
                      width: (20 / Dimensions.designWidth).w,
                      height: (20 / Dimensions.designWidth).w,
                    ),
                  ),
                ),
              ),
            ),
            const SizeBox(height: 8),
            Text(
              text,
              style: TextStyles.primaryMedium.copyWith(
                fontSize: (14 / Dimensions.designWidth).w,
                color: AppColors.dark80,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
