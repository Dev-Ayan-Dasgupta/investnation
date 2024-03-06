// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:investnation/presentation/widgets/core/index.dart';

import 'package:investnation/utils/constants/index.dart';

class CustomSearchBox extends StatefulWidget {
  const CustomSearchBox({
    Key? key,
    this.width,
    this.horizontalPadding,
    this.verticalPadding,
    this.borderColor,
    this.borderRadius,
    this.color,
    required this.controller,
    this.fontColor,
    required this.onChanged,
    this.hintText,
    this.keyboardType,
    required this.onSearchCancelled,
    required this.showCancel,
  }) : super(key: key);

  final double? width;
  final double? horizontalPadding;
  final double? verticalPadding;
  final Color? borderColor;
  final double? borderRadius;
  final Color? color;
  final TextEditingController controller;
  final Color? fontColor;
  final Function(String) onChanged;
  final String? hintText;
  final TextInputType? keyboardType;
  final VoidCallback onSearchCancelled;
  // final Function(String) onSearchCancelled;
  final bool showCancel;

  @override
  State<CustomSearchBox> createState() => _CustomSearchBoxState();
}

class _CustomSearchBoxState extends State<CustomSearchBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 100.w,
      padding: EdgeInsets.symmetric(
        horizontal: (widget.horizontalPadding ?? 16 / Dimensions.designWidth).w,
        vertical: widget.verticalPadding ?? (0 / Dimensions.designWidth).w,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.borderColor ?? const Color(0xFFEEEEEE),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(
            widget.borderRadius ?? (10 / Dimensions.designWidth).w,
          ),
        ),
        color: widget.color ?? Colors.transparent,
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            ImageConstants.search,
            width: (18 / Dimensions.designWidth).w,
            height: (18 / Dimensions.designWidth).w,
          ),
          const SizeBox(width: 15),
          Expanded(
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hintText ?? "",
                hintStyle: TextStyles.primaryMedium.copyWith(
                  color:
                      widget.fontColor ?? const Color.fromRGBO(37, 37, 37, 0.5),
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              style: TextStyles.primaryMedium.copyWith(
                color: widget.fontColor ?? AppColors.dark100,
                fontSize: (16 / Dimensions.designWidth).w,
              ),
              onChanged: widget.onChanged,
              //     (p0) {
              //   widget.onChanged;
              //   setState(() {});
              // },
              keyboardType: widget.keyboardType ?? TextInputType.text,
            ),
          ),
          const SizeBox(width: 15),
          Ternary(
            condition: widget.showCancel,
            // widget.controller.text.isEmpty,
            falsy: const SizeBox(),
            truthy: InkWell(
              onTap: widget.onSearchCancelled,
              child: SvgPicture.asset(
                ImageConstants.timesCircle,
                width: (15 / Dimensions.designWidth).w,
                height: (15 / Dimensions.designWidth).w,
              ),
            ),
          ),
          // widget.controller.text.isEmpty
          //     ? const SizeBox()
          //     : InkWell(
          //         onTap: widget.onSearchCancelled,
          //         child: SvgPicture.asset(
          //           ImageConstants.timesCircle,
          //           width: (15 / Dimensions.designWidth).w,
          //           height: (15 / Dimensions.designWidth).w,
          //         ),
          //       ),
        ],
      ),
    );
  }
}
