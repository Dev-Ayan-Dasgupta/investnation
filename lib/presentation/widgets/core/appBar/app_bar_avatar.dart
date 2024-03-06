import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:investnation/utils/constants/index.dart';

class AppBarAvatar extends StatelessWidget {
  const AppBarAvatar({
    Key? key,
    required this.imgUrl,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  final String imgUrl;
  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
        top: (12 / Dimensions.designHeight).h,
        bottom: (12 / Dimensions.designHeight).h,
      ),
      child: InkWell(
        onTap: onTap,
        child: CircleAvatar(
          backgroundColor: AppColors.primary100,
          backgroundImage: storageProfilePhotoBase64 != null
              ? MemoryImage(base64Decode(storageProfilePhotoBase64 ?? ""))
              : null,
          child: storageProfilePhotoBase64 != null
              ? const SizeBox()
              : Center(
                  child: Text(
                    name.isNotEmpty
                        ? "${name[0]}${name.split(' ').last[0]}"
                        : "",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.dark10,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
