import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:investnation/utils/constants/index.dart';

class CustomCircleAvatarAsset extends StatelessWidget {
  const CustomCircleAvatarAsset({
    Key? key,
    this.width,
    this.height,
    required this.imgUrl,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? (35 / Dimensions.designWidth).w,
      height: height ?? (35 / Dimensions.designWidth).w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage(imgUrl),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
