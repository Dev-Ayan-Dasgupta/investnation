// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:investnation/utils/constants/index.dart';

class AddFundsExplainer extends StatelessWidget {
  const AddFundsExplainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all((16 / Dimensions.designWidth).w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular((10 / Dimensions.designWidth).w),
        ),
        color: AppColors.dark5,
      ),
      child: Column(
        children: [
          const AddFundsExplainerTile(
            svgName: ImageConstants.addHome,
            text:
                "Make sure your deposit comes from a bank account in your name",
          ),
          SizeBox(height: (12 / Dimensions.designWidth).h),
          const AddFundsExplainerTile(
            svgName: ImageConstants.undo,
            text:
                "We will reverse any deposits that comes from a bank account that is not in your name",
          ),
          SizeBox(height: (12 / Dimensions.designWidth).h),
          const AddFundsExplainerTile(
            svgName: ImageConstants.joinRight,
            text:
                "Joint account transfers are fine, as long as you can prove your joint account ownership",
          ),
          SizeBox(height: (12 / Dimensions.designWidth).h),
          const AddFundsExplainerTile(
            svgName: ImageConstants.payments,
            text:
                "There may be fees charged by your bank. Check with your bank for applicable charges",
          ),
        ],
      ),
    );
  }
}

class AddFundsExplainerTile extends StatelessWidget {
  const AddFundsExplainerTile({
    Key? key,
    required this.svgName,
    required this.text,
  }) : super(key: key);

  final String svgName;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: (35 / Dimensions.designWidth).w,
          height: (35 / Dimensions.designWidth).w,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary10,
          ),
          child: Center(
            child: SvgPicture.asset(
              svgName,
              width: (15 / Dimensions.designWidth).w,
              height: (15 / Dimensions.designWidth).w,
            ),
          ),
        ),
        const SizeBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyles.primaryMedium.copyWith(
              color: AppColors.dark80,
              fontSize: (14 / Dimensions.designWidth).w,
            ),
          ),
        ),
      ],
    );
  }
}

class PlanBenefitsExplainerTile extends StatelessWidget {
  const PlanBenefitsExplainerTile({
    Key? key,
    required this.svgName,
    required this.text,
  }) : super(key: key);

  final String? svgName;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: (12.5 / Dimensions.designWidth).w,
          backgroundImage: MemoryImage(
            base64Decode(
              svgName ?? "",
            ),
          ),
        ),
        const SizeBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyles.primaryMedium.copyWith(
              color: AppColors.dark80,
              fontSize: (14 / Dimensions.designWidth).w,
            ),
          ),
        ),
      ],
    );
  }
}
