// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:investnation/utils/constants/index.dart';

class RiskProfilingGridItem extends StatelessWidget {
  const RiskProfilingGridItem({
    Key? key,
    required this.onTap,
    required this.isSelected,
    // required this.heading,
    required this.description,
  }) : super(key: key);

  final VoidCallback onTap;
  final bool isSelected;
  // final String heading;
  final String description;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all((16 / Dimensions.designWidth).w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular((10 / Dimensions.designWidth).w),
          ),
          color: isSelected ? AppColors.yellow50 : AppColors.dark5,
        ),
        child: Center(
          child: HtmlWidget(description),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text(
          //       heading,
          //       style: TextStyles.primaryBold.copyWith(
          //         color: AppColors.dark100,
          //         fontSize: (14 / Dimensions.designWidth).w,
          //       ),
          //       textAlign: TextAlign.center,
          //     ),
          //     const SizeBox(height: 5),
          //     Text(
          //       description,
          //       style: TextStyles.primaryMedium.copyWith(
          //         color: AppColors.dark100,
          //         fontSize: (14 / Dimensions.designWidth).w,
          //       ),
          //       textAlign: TextAlign.center,
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
