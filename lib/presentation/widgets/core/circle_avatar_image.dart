import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:investnation/utils/constants/index.dart';

class CustomCircleAvatarMemory extends StatelessWidget {
  const CustomCircleAvatarMemory({
    Key? key,
    this.width,
    this.height,
    required this.bytes,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: ((109 / 2) / Dimensions.designWidth).w,
      backgroundImage: MemoryImage(bytes),
      // MemoryImage(bytes),
    );
  }
}
