import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';

class ShimmerDashboardLocked extends StatefulWidget {
  const ShimmerDashboardLocked({super.key});

  @override
  State<ShimmerDashboardLocked> createState() => _ShimmerDashboardLockedState();
}

class _ShimmerDashboardLockedState extends State<ShimmerDashboardLocked> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal:
            (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizeBox(height: 10),
          CustomShimmer(
            child: ShimmerContainer(
              width: 100.w,
              height: (253 / Dimensions.designHeight).h,
              borderRadius: BorderRadius.all(
                Radius.circular((20 / Dimensions.designWidth).w),
              ),
            ),
          ),
          const SizeBox(height: 20),
          CustomShimmer(
            child: ShimmerContainer(
              width: (80 / Dimensions.designWidth).w,
              height: (10 / Dimensions.designWidth).w,
              borderRadius: BorderRadius.all(
                Radius.circular((10 / Dimensions.designWidth).w),
              ),
            ),
          ),
          const SizeBox(height: 10),
          CustomShimmer(
            child: ShimmerContainer(
              width: 100.w,
              height: (140 / Dimensions.designHeight).h,
              borderRadius: BorderRadius.all(
                Radius.circular((10 / Dimensions.designWidth).w),
              ),
            ),
          ),
          const SizeBox(height: 20),
          CustomShimmer(
            child: ShimmerContainer(
              width: (80 / Dimensions.designWidth).w,
              height: (10 / Dimensions.designWidth).w,
              borderRadius: BorderRadius.all(
                Radius.circular((10 / Dimensions.designWidth).w),
              ),
            ),
          ),
          const SizeBox(height: 10),
          CustomShimmer(
            child: ShimmerContainer(
              width: 100.w,
              height: (10 / Dimensions.designWidth).w,
              borderRadius: BorderRadius.all(
                Radius.circular((10 / Dimensions.designWidth).w),
              ),
            ),
          ),
          const SizeBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomShimmer(
                child: ShimmerContainer(
                  width: 30.w,
                  height: (300 / Dimensions.designHeight).w,
                  borderRadius: BorderRadius.all(
                    Radius.circular((10 / Dimensions.designWidth).w),
                  ),
                ),
              ),
              const SizeBox(width: 5),
              CustomShimmer(
                child: ShimmerContainer(
                  width: 30.w,
                  height: (300 / Dimensions.designHeight).w,
                  borderRadius: BorderRadius.all(
                    Radius.circular((10 / Dimensions.designWidth).w),
                  ),
                ),
              ),
              const SizeBox(width: 5),
              CustomShimmer(
                child: ShimmerContainer(
                  width: 30.w,
                  height: (300 / Dimensions.designHeight).w,
                  borderRadius: BorderRadius.all(
                    Radius.circular((10 / Dimensions.designWidth).w),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
