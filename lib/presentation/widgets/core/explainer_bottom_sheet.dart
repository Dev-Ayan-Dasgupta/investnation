// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:investnation/utils/constants/index.dart';

class ExplainerBottomSheet extends StatelessWidget {
  const ExplainerBottomSheet({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(
        vertical:
            (PaddingConstants.horizontalPadding / Dimensions.designHeight).h,
        horizontal:
            (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular((10 / Dimensions.designWidth).w),
          topRight: Radius.circular((10 / Dimensions.designWidth).w),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizeBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 10.w,
                height: 3,
                decoration: const BoxDecoration(
                    color: AppColors.dark50,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
            ],
          ),
          const SizeBox(height: 10),
          Text(
            title,
            style: TextStyles.primaryBold.copyWith(
              color: AppColors.dark100,
              fontSize: (14 / Dimensions.designWidth).w,
            ),
          ),
          const SizeBox(height: 10),
          Text(
            description,
            style: TextStyles.primaryMedium.copyWith(
              color: AppColors.dark100,
              fontSize: (14 / Dimensions.designWidth).w,
            ),
          ),
        ],
      ),
    );
  }
}
