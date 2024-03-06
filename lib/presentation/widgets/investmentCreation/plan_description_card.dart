// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:investnation/utils/constants/index.dart';

class PlanDescriptionCard extends StatelessWidget {
  const PlanDescriptionCard({
    Key? key,
    required this.hmtlContent,
  }) : super(key: key);

  final String hmtlContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (326 / Dimensions.designWidth).w,
      height: (447 / Dimensions.designHeight).h,
      margin: EdgeInsets.symmetric(
        vertical: (10 / Dimensions.designHeight).h,
      ),
      padding: EdgeInsets.all(
        (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular((16 / Dimensions.designWidth).w),
        ),
        boxShadow: [BoxShadows.primary],
        color: Colors.white,
      ),
      child: HtmlWidget(
        hmtlContent,
      ),
    );
  }
}
