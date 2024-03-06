// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:investnation/utils/constants/index.dart';

class CapsuleIconButton extends StatelessWidget {
  const CapsuleIconButton({
    Key? key,
    required this.onTap,
    required this.text,
    required this.icon,
  }) : super(key: key);

  final VoidCallback onTap;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular((80 / Dimensions.designWidth).w),
          ),
          border: Border.all(width: 0.5, color: AppColors.dark50),
        ),
        padding: EdgeInsets.symmetric(
          horizontal:
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
          vertical: (8 / Dimensions.designHeight).h,
        ),
        child: Row(
          children: [
            Text(
              text,
              style: TextStyles.primaryBold.copyWith(
                fontSize: (14 / Dimensions.designWidth).w,
                color: AppColors.dark100,
              ),
            ),
            const SizeBox(width: 5),
            Icon(
              icon,
              color: AppColors.dark80,
              size: (20 / Dimensions.designWidth).w,
            ),
          ],
        ),
      ),
    );
  }
}
