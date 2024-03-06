// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:investnation/utils/constants/index.dart';

class InvestmentZoneTile extends StatelessWidget {
  const InvestmentZoneTile({
    Key? key,
    required this.onTap,
    required this.planName,
    required this.returnRate,
    required this.riskLevel,
    required this.description,
  }) : super(key: key);

  final VoidCallback onTap;
  final String planName;
  final String returnRate;
  final String riskLevel;
  final String description;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all((16 / Dimensions.designWidth).w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular((16 / Dimensions.designWidth).w),
          ),
          color: Colors.white,
          boxShadow: [BoxShadows.primary],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  planName,
                  style: TextStyles.primaryBold.copyWith(
                    color: AppColors.dark100,
                    fontSize: (16 / Dimensions.designWidth).w,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.dark80,
                  size: (16 / Dimensions.designWidth).w,
                ),
              ],
            ),
            const SizeBox(height: 20),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Return p.a.",
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.dark80,
                        fontSize: (14 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 8),
                    Text(
                      returnRate,
                      style: TextStyles.primaryBold.copyWith(
                        color: AppColors.primary100,
                        fontSize: (14 / Dimensions.designWidth).w,
                      ),
                    ),
                  ],
                ),
                const SizeBox(width: 50),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Risk level",
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.dark80,
                        fontSize: (14 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 8),
                    Text(
                      riskLevel,
                      style: TextStyles.primaryBold.copyWith(
                        color: AppColors.primary100,
                        fontSize: (14 / Dimensions.designWidth).w,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizeBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    description,
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark80,
                      fontSize: (14 / Dimensions.designWidth).w,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
