// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:investnation/utils/constants/index.dart';

class PortfolioTile extends StatelessWidget {
  const PortfolioTile({
    Key? key,
    required this.onTap,
    required this.type,
    required this.minAmount,
    required this.maxAmount,
    required this.progress,
  }) : super(key: key);

  final VoidCallback onTap;
  final String type;
  final String minAmount;
  final String maxAmount;
  final String progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizeBox(height: 10),
        InkWell(
          onTap: onTap,
          child: Container(
            width: 85.w,
            padding: EdgeInsets.symmetric(
              horizontal: (24 / Dimensions.designWidth).w,
              vertical: (16 / Dimensions.designHeight).h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  (10 / Dimensions.designWidth).w,
                ),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadows.primary,
                // BoxShadows.primaryInverted,
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      type,
                      style: TextStyles.primaryBold.copyWith(
                        fontSize: (14 / Dimensions.designWidth).w,
                        color: AppColors.dark100,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: (20 / Dimensions.designWidth).w,
                      color: AppColors.dark80,
                    ),
                  ],
                ),
                const SizeBox(height: 16),
                Stack(
                  children: [
                    Container(
                      width:
                          // 100.w,
                          (329 / Dimensions.designWidth).w,
                      height: (20 / Dimensions.designHeight).h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            (16 / Dimensions.designWidth).w,
                          ),
                        ),
                        color: AppColors.dark10,
                      ),
                    ),
                    Container(
                      width:
                          // (100 * (double.parse(progress) / 100)).w,
                          ((329 * double.parse(progress) / 100) /
                                  Dimensions.designWidth)
                              .w,
                      height: (20 / Dimensions.designHeight).h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            (16 / Dimensions.designWidth).w,
                          ),
                        ),
                        color: AppColors.primary100,
                      ),
                      child: Center(
                        child: Text(
                          "$progress%",
                          style: TextStyles.primaryBold.copyWith(
                            fontSize: (12 / Dimensions.designWidth).w,
                            color: AppColors.black100,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizeBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$minAmount AED",
                      style: TextStyles.primaryMedium.copyWith(
                        fontSize: (16 / Dimensions.designWidth).w,
                        color: AppColors.dark50,
                      ),
                    ),
                    Text(
                      "$maxAmount AED",
                      style: TextStyles.primaryMedium.copyWith(
                        fontSize: (16 / Dimensions.designWidth).w,
                        color: AppColors.dark50,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizeBox(height: 10),
      ],
    );
  }
}
