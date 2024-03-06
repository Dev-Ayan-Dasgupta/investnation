import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:investnation/utils/constants/index.dart';

class AppBarAction extends StatelessWidget {
  const AppBarAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal:
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w),
      child: InkWell(
        onTap: () {
          // Navigator.pushNamed(context, Routes.notifications);
        },
        child: const SizeBox(),
        // SvgPicture.asset(
        //   ImageConstants.notifications,
        //   width: (22 / Dimensions.designWidth).w,
        //   height: (27.5 / Dimensions.designWidth).w,
        // ),
      ),
    );
  }
}
