import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';

class PendingStatusScreen extends StatefulWidget {
  const PendingStatusScreen({super.key});

  @override
  State<PendingStatusScreen> createState() => _PendingStatusScreenState();
}

class _PendingStatusScreenState extends State<PendingStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: (16 / Dimensions.designWidth).w),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    ImageConstants.checkCircleOutlined,
                    width: (111 / Dimensions.designWidth).w,
                    height: (111 / Dimensions.designWidth).w,
                  ),
                  const SizeBox(height: 30),
                  Text(
                    "Thank you for choosing Investnation!",
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
                      "We are dilligently reviewing your\napplication and will notify you of the\nstatus shortly.",
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
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.onboarding,
                      (route) => false,
                    );
                  },
                  text: labels[347]["labelText"],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
