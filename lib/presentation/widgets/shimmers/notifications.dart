import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';

class ShimmerNotificationTile extends StatelessWidget {
  const ShimmerNotificationTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomShimmer(
          child: ShimmerContainer(
            width: 100.w,
            height: ((100 / Dimensions.designHeight).h),
            borderRadius: BorderRadius.all(
              Radius.circular((10 / Dimensions.designWidth).w),
            ),
          ),
        ),
      ],
    );
  }
}
