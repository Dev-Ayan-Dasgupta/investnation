// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:investnation/utils/constants/index.dart';

class SolidButton extends StatelessWidget {
  const SolidButton({
    Key? key,
    required this.onTap,
    this.width,
    this.height,
    this.borderColor,
    this.borderRadius,
    this.boxShadow,
    this.color,
    this.auxWidget,
    required this.text,
    this.fontColor,
    this.borderWidth,
    this.fontSize,
  }) : super(key: key);

  final VoidCallback onTap;
  final double? width;
  final double? height;
  final Color? borderColor;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Color? color;
  final Widget? auxWidget;
  final String text;
  final Color? fontColor;
  final double? borderWidth;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? 100.w,
        height: height ?? (50 / Dimensions.designHeight).h,
        decoration: BoxDecoration(
          border: Border.all(
              color: borderColor ?? Colors.transparent,
              width: borderWidth ?? 2),
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius ?? (36 / Dimensions.designWidth).w),
          ),
          boxShadow: boxShadow ?? [],
          color: color ?? AppColors.darkX,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                auxWidget ?? const SizeBox(),
                Text(
                  text,
                  style: TextStyles.primaryBold.copyWith(
                    color: fontColor ?? AppColors.black50,
                    fontSize: fontSize ?? (16 / Dimensions.designWidth).w,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
