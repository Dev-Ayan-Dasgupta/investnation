// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:investnation/utils/constants/index.dart';

class ReferralListTile extends StatelessWidget {
  const ReferralListTile({
    Key? key,
    required this.svgName,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.date,
    required this.onRemind,
  }) : super(key: key);

  final String svgName;
  final String title;
  final String subtitle;
  final String trailing;
  final String date;
  final VoidCallback onRemind;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: (0 / Dimensions.designWidth).w,
        vertical: (5 / Dimensions.designHeight).h,
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              color: AppColors.primary30,
            ),
            child: Center(
              child: SvgPicture.asset(
                svgName,
                width: (27.5 / Dimensions.designWidth).w,
                height: (12 / Dimensions.designHeight).h,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary100,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),

          const SizeBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyles.primary.copyWith(
                          color: AppColors.dark100,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // const Spacer(),
                    const SizeBox(width: 5),
                    Text(
                      trailing,
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.primary100,
                        // trailing == "Reminder Sent"
                        //     ? AppColors.green100
                        //     : trailing == "Remind"
                        //         ? AppColors.primary100
                        //         : AppColors.dark80,
                        fontSize: (14 / Dimensions.designWidth).w,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        subtitle,
                        style: TextStyles.primary.copyWith(
                          color: AppColors.dark50,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // const Spacer(),
                    const SizeBox(width: 5),
                    Text(
                      date,
                      style: TextStyles.primary.copyWith(
                        color: AppColors.dark50,
                        fontSize: (14 / Dimensions.designWidth).w,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          // Row(
          //   children: [

          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         SizedBox(
          //           width: 45.w,
          //           child: Text(
          //             title,
          //             style: TextStyles.primary.copyWith(
          //               color: AppColors.dark100,
          //               fontSize: (16 / Dimensions.designWidth).w,
          //             ),
          //             overflow: TextOverflow.ellipsis,
          //           ),
          //         ),
          //         const SizeBox(height: 7),
          //         SizedBox(
          //           width: 45.w,
          //           child: Text(
          //             subtitle,
          //             style: TextStyles.primary.copyWith(
          //               color: AppColors.dark50,
          //               fontSize: (14 / Dimensions.designWidth).w,
          //             ),
          //             overflow: TextOverflow.ellipsis,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
          // Expanded(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.end,
          //     children: [
          //       InkWell(
          //         onTap: onRemind,
          //         child: Text(
          //           trailing,
          //           style: TextStyles.primaryMedium.copyWith(
          //             color: AppColors.primary100,
          //             // trailing == "Reminder Sent"
          //             //     ? AppColors.green100
          //             //     : trailing == "Remind"
          //             //         ? AppColors.primary100
          //             //         : AppColors.dark80,
          //             fontSize: (16 / Dimensions.designWidth).w,
          //           ),
          //         ),
          //       ),
          //       const SizeBox(height: 7),
          //       Text(
          //         date,
          //         style: TextStyles.primary.copyWith(
          //           color: AppColors.dark50,
          //           fontSize: (14 / Dimensions.designWidth).w,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
