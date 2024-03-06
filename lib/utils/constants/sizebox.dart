import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:investnation/utils/constants/dimensions.dart';

class SizeBox extends StatelessWidget {
  const SizeBox({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width != null ? (width! / Dimensions.designWidth).w : 0,
      height: height != null ? (height! / Dimensions.designHeight).h : 0,
    );
  }
}
