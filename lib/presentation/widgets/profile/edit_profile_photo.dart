import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';

class EditProfilePhoto extends StatelessWidget {
  const EditProfilePhoto({
    Key? key,
    required this.onTap,
    required this.isMemoryImage,
    required this.bytes,
  }) : super(key: key);

  final VoidCallback onTap;
  final bool isMemoryImage;
  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: (114 / Dimensions.designWidth).w,
          height: (114 / Dimensions.designWidth).w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [BoxShadows.primary],
          ),
          child: Center(
            child: Ternary(
              condition: isMemoryImage,
              truthy: CustomCircleAvatarMemory(
                bytes: bytes,
                width: (109 / Dimensions.designWidth).w,
                height: (109 / Dimensions.designWidth).w,
              ),
              falsy: CustomCircleAvatarAsset(
                imgUrl: ImageConstants.profilePictureDummy,
                width: (109 / Dimensions.designWidth).w,
                height: (109 / Dimensions.designWidth).w,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: (36 / Dimensions.designWidth).w,
              height: (36 / Dimensions.designWidth).w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [BoxShadows.primary],
              ),
              child: Center(
                child: SvgPicture.asset(
                  ImageConstants.addAPhoto,
                  width: (17 / Dimensions.designWidth).w,
                  height: (17 / Dimensions.designWidth).w,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
