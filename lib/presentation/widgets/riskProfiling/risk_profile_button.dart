// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:investnation/utils/constants/index.dart';

class RiskProfileButton extends StatelessWidget {
  const RiskProfileButton({
    Key? key,
    required this.onTap,
    required this.isSelected,
    required this.widget,
  }) : super(key: key);

  final VoidCallback onTap;
  final bool isSelected;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: (8 / Dimensions.designWidth).w,
          vertical: (5 / Dimensions.designHeight).h,
        ),
        padding: EdgeInsets.all((16 / Dimensions.designWidth).w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular((10 / Dimensions.designWidth).w),
          ),
          border: Border.all(
            width: 1,
            color: isSelected ? AppColors.primary100 : Colors.transparent,
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadows.primary,
            // BoxShadows.primaryInverted,
          ],
        ),
        child: Center(
          child: widget,
        ),
      ),
    );
  }
}
