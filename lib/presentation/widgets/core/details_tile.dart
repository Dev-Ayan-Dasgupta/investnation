// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:investnation/data/models/widgets/index.dart';
import 'package:investnation/utils/constants/index.dart';

class DetailsTile extends StatelessWidget {
  const DetailsTile({
    Key? key,
    required this.length,
    required this.details,
    this.coloredIndex,
    required this.boldIndices,
    this.fontColor,
  }) : super(key: key);

  final int length;
  final List<DetailsTileModel> details;
  final int? coloredIndex;
  final List<int> boldIndices;
  final Color? fontColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: length,
          itemBuilder: (context, index) {
            return Container(
              width: 100.w,
              height: (47 / Dimensions.designHeight).h,
              padding: EdgeInsets.symmetric(
                horizontal: (15 / Dimensions.designWidth).w,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: (index == 0)
                      ? Radius.circular((10 / Dimensions.designWidth).w)
                      : const Radius.circular(0),
                  topRight: (index == 0)
                      ? Radius.circular((10 / Dimensions.designWidth).w)
                      : const Radius.circular(0),
                  bottomLeft: (index == length - 1)
                      ? Radius.circular((10 / Dimensions.designWidth).w)
                      : const Radius.circular(0),
                  bottomRight: (index == length - 1)
                      ? Radius.circular((10 / Dimensions.designWidth).w)
                      : const Radius.circular(0),
                ),
                color: (index % 2 == 0) ? AppColors.dark10V2 : AppColors.white100,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    details[index].key,
                    style: TextStyles.primary.copyWith(
                      color: AppColors.dark100,
                      fontSize: (14 / Dimensions.designWidth).w,
                      fontWeight: (boldIndices.contains(index))
                          ? FontWeight.w600
                          : FontWeight.w300,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      details[index].value,
                      style: TextStyles.primary.copyWith(
                        color: (index == coloredIndex)
                            ? fontColor
                            : AppColors.dark100,
                        fontSize: (14 / Dimensions.designWidth).w,
                        fontWeight: (boldIndices.contains(index))
                            ? FontWeight.w600
                            : FontWeight.w300,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
