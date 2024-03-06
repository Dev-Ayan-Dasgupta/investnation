// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:investnation/utils/constants/index.dart';

class TopicTile extends StatelessWidget {
  const TopicTile({
    Key? key,
    required this.onTap,
    required this.iconPath,
    required this.text,
    this.color,
    this.fontColor,
    this.highlightColor,
    this.iconColor,
    this.trailingIcon,
    this.leading,
    this.fontSize,
  }) : super(key: key);

  final VoidCallback onTap;
  final String iconPath;
  final String text;
  final Color? color;
  final Color? fontColor;
  final Color? highlightColor;
  final Color? iconColor;
  final String? trailingIcon;
  final Widget? leading;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(
            ((leading == null ? 10 : 16) / Dimensions.designWidth).w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular((10 / Dimensions.designWidth).w),
          ),
          // boxShadow: [BoxShadows.primary],
          color: color ?? AppColors.dark5,
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  leading ??
                      Container(
                        width: (30 / Dimensions.designWidth).w,
                        height: (30 / Dimensions.designWidth).w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular((7 / Dimensions.designWidth).w),
                          ),
                          color: highlightColor ?? AppColors.dark10,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            iconPath,
                            width: (20 / Dimensions.designWidth).w,
                            height: (20 / Dimensions.designHeight).h,
                          ),
                        ),
                      ),
                  SizeBox(width: leading == null ? 10 : 0),
                  Text(
                    text,
                    style: TextStyles.primaryMedium.copyWith(
                      fontSize: ((fontSize ?? 18) / Dimensions.designWidth).w,
                      color: fontColor ?? const Color(0XFF1A3C40),
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              trailingIcon ?? ImageConstants.arrowForwardIos,
              colorFilter: ColorFilter.mode(
                iconColor ?? AppColors.dark100,
                BlendMode.srcIn,
              ),
              width: (6.7 / Dimensions.designWidth).w,
              height: (11.3 / Dimensions.designWidth).w,
            ),
          ],
        ),
      ),
    );
  }
}
