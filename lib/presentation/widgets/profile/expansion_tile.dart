import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';

class CustomExpansionTile extends StatelessWidget {
  const CustomExpansionTile({
    Key? key,
    required this.index,
    required this.isExpanded,
    required this.titleText,
    required this.childrenText,
    this.onExpansionChanged,
  }) : super(key: key);

  final int index;
  final bool isExpanded;
  final String titleText;
  final String childrenText;
  final void Function(bool)? onExpansionChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Theme(
          data: ThemeData(
            dividerColor: Colors.transparent,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: (PaddingConstants.horizontalPadding /
                        Dimensions.designWidth)
                    .w,
                vertical: (0 / Dimensions.designHeight).h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular((10 / Dimensions.designWidth).w),
              ),
              color: AppColors.dark5,
            ),
            child: ExpansionTile(
              onExpansionChanged: onExpansionChanged,
              childrenPadding: EdgeInsets.zero,
              tilePadding: EdgeInsets.zero,
              trailing: Ternary(
                condition: isExpanded,
                truthy: Icon(
                  Icons.remove,
                  color: AppColors.dark100,
                  size: (25 / Dimensions.designWidth).w,
                ),
                falsy: Icon(
                  Icons.add_outlined,
                  color: AppColors.dark100,
                  size: (25 / Dimensions.designWidth).w,
                ),
              ),
              title: Text(
                titleText,
                style: TextStyles.primaryMedium.copyWith(
                  color: AppColors.dark100,
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      childrenText,
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.dark100,
                        fontSize: (14 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 20),
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
