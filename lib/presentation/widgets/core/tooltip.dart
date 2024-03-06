// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:investnation/utils/constants/index.dart';

class CustomTooltip extends StatefulWidget {
  const CustomTooltip({
    Key? key,
    required this.description,
  }) : super(key: key);

  final String description;

  @override
  State<CustomTooltip> createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> {
  final JustTheController tooltipController = JustTheController();

  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      duration: const Duration(milliseconds: 1500),
      alignment: Alignment.center,
      child: JustTheTooltip(
        backgroundColor: AppColors.dark100,
        controller: tooltipController,
        tailLength: 10,
        tailBaseWidth: 16.0,
        isModal: true,
        preferredDirection: AxisDirection.up,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8.0),
        offset: 0,
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.description,
            textAlign: TextAlign.center,
            style: TextStyles.primaryMedium.copyWith(
              color: Colors.white,
              fontSize: (12 / Dimensions.designWidth).w,
            ),
          ),
        ),
        child: Icon(
          Icons.help_outline_rounded,
          color: AppColors.dark50,
          size: (18 / Dimensions.designWidth).w,
        ),
      ),
    );
  }
}
