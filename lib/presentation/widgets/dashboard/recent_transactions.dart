import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:investnation/utils/helpers/index.dart';

class DashboardTransactionListTile extends StatelessWidget {
  const DashboardTransactionListTile({
    Key? key,
    required this.isCredit,
    required this.title,
    required this.name,
    required this.amount,
    required this.currency,
    required this.date,
    this.padding,
    required this.onTap,
  }) : super(key: key);

  final bool isCredit;
  final String title;
  final String name;
  final double amount;
  final String currency;
  final String date;
  final double? padding;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: (1 / Dimensions.designHeight).h),
        padding: EdgeInsets.symmetric(
          horizontal: (padding ?? 0 / Dimensions.designWidth).w,
          vertical: (5 / Dimensions.designHeight).h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: (40 / Dimensions.designWidth).w,
                  height: (40 / Dimensions.designWidth).w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        (7 / Dimensions.designWidth).w,
                      ),
                    ),
                    color: isCredit ? AppColors.primary30 : AppColors.dark10,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      ImageConstants.transaction,
                      width: (25.73 / Dimensions.designWidth).w,
                      height: (12.7 / Dimensions.designHeight).h,
                      colorFilter: isCredit
                          ? const ColorFilter.mode(
                              AppColors.primary100,
                              BlendMode.srcIn,
                            )
                          : const ColorFilter.mode(
                              AppColors.dark100,
                              BlendMode.srcIn,
                            ),
                    ),
                  ),
                ),
                const SizeBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 45.w,
                      child: Text(
                        title,
                        style: TextStyles.primary.copyWith(
                          color: AppColors.dark100,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizeBox(height: 7),
                    SizedBox(
                      width: 45.w,
                      child: Text(
                        name,
                        style: TextStyles.primary.copyWith(
                          color: AppColors.dark50,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  isCredit
                      ? NumberFormatter.numberFormat(amount)
                      : NumberFormatter.numberFormat(amount),
                  style: TextStyles.primaryBold.copyWith(
                    color: isCredit ? AppColors.green100 : AppColors.dark100,
                    fontSize: (14 / Dimensions.designWidth).w,
                  ),
                ),
                const SizeBox(height: 7),
                Text(
                  date,
                  style: TextStyles.primary.copyWith(
                    color: AppColors.dark50,
                    fontSize: (14 / Dimensions.designWidth).w,
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
