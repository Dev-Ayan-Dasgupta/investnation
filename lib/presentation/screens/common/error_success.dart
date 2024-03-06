import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';

class ErrorSuccessScreen extends StatefulWidget {
  const ErrorSuccessScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<ErrorSuccessScreen> createState() => _ErrorSuccessScreenState();
}

class _ErrorSuccessScreenState extends State<ErrorSuccessScreen> {
  late ErrorArgumentModel errorArgumentModel;

  @override
  void initState() {
    super.initState();
    errorArgumentModel =
        ErrorArgumentModel.fromMap(widget.argument as dynamic ?? {});
    errorArgumentModel.auxMethod ?? () {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    errorArgumentModel.iconPath,
                    width: (111 / Dimensions.designWidth).w,
                    height: (111 / Dimensions.designWidth).w,
                  ),
                  const SizeBox(height: 30),
                  Text(
                    errorArgumentModel.title,
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark80,
                      fontSize: (24 / Dimensions.designWidth).w,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizeBox(height: 20),
                  SizedBox(
                    width: 60.w,
                    child: Text(
                      errorArgumentModel.message,
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.dark50,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                GradientButton(
                  onTap: errorArgumentModel.onTap,
                  text: errorArgumentModel.buttonText,
                  auxWidget: errorArgumentModel.auxWidget ?? const SizeBox(),
                ),
                Ternary(
                  condition: errorArgumentModel.hasSecondaryButton,
                  truthy: Column(
                    children: [
                      const SizeBox(height: 15),
                      SolidButton(
                        onTap: errorArgumentModel.onTapSecondary,
                        text: errorArgumentModel.buttonTextSecondary,
                        boxShadow: [BoxShadows.primary],
                        color: Colors.white,
                        fontColor: AppColors.dark100,
                      ),
                    ],
                  ),
                  falsy: const SizeBox(),
                ),
                SizeBox(
                  height: PaddingConstants.bottomPadding +
                      MediaQuery.of(context).padding.bottom,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
