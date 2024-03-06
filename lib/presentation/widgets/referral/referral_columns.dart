// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:investnation/utils/constants/index.dart';

class ReferralColumns extends StatelessWidget {
  const ReferralColumns({
    Key? key,
    required this.title,
    required this.count,
    required this.isSelected,
  }) : super(key: key);

  final String title;
  final int count;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: (20 / Dimensions.designWidth).w,
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyles.primaryBold.copyWith(
              fontSize: (14 / Dimensions.designWidth).w,
              color: isSelected ? AppColors.primary80 : AppColors.dark100,
            ),
          ),
          const SizeBox(height: 10),
          Text(
            "$count",
            style: TextStyles.primaryBold.copyWith(
              fontSize: (20 / Dimensions.designWidth).w,
              color: isSelected ? AppColors.primary80 : AppColors.dark100,
            ),
          ),
        ],
      ),
    );
  }
}
