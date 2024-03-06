// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:investnation/utils/constants/index.dart';

class TransferListTile extends StatelessWidget {
  const TransferListTile({
    Key? key,
    required this.onTap,
    required this.onDelete,
    required this.onTransfer,
    required this.name,
    required this.ibanNumber,
  }) : super(key: key);

  final VoidCallback onTap;
  final void Function(BuildContext) onDelete;
  final void Function(BuildContext) onTransfer;
  final String name;
  final String ibanNumber;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        child: Slidable(
          endActionPane: ActionPane(
            extentRatio: 0.5,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: onDelete,
                foregroundColor: AppColors.red100,
                // foregroundColor: Colors.white,
                icon: Icons.delete_forever_rounded,
                label: "Delete",
              ),
              SlidableAction(
                onPressed: onTransfer,
                foregroundColor: AppColors.primary80,
                // foregroundColor: Colors.white,
                icon: Icons.payment,
                label: "Transfer",
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: (8 / Dimensions.designHeight).h,
              horizontal: (0 / Dimensions.designWidth).w,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              children: [
                Container(
                  width: (40 / Dimensions.designWidth).w,
                  height: (40 / Dimensions.designWidth).w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary100,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      ImageConstants.person,
                      width: (16 / Dimensions.designWidth).w,
                      height: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                ),
                const SizeBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark100,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                      ),
                      const SizeBox(height: 8),
                      Text(
                        ibanNumber,
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark80,
                          fontSize: (12 / Dimensions.designWidth).w,
                        ),
                      ),
                    ],
                  ),
                ),
                SvgPicture.asset(
                  ImageConstants.gripDotsVertical,
                  width: (8 / Dimensions.designWidth).w,
                  height: (12 / Dimensions.designHeight).h,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
