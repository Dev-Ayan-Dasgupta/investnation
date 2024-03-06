// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:investnation/utils/constants/index.dart';

class LoaderRow extends StatelessWidget {
  const LoaderRow({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizeBox(width: 10),
        SpinKitFadingCircle(
          color: color ?? Colors.white,
          size: ((width ?? 20) / Dimensions.designWidth).w,
        ),
      ],
    );
  }
}
