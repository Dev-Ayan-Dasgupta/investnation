import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/presentation/widgets/core/risk_profile_progress.dart';
import 'package:investnation/utils/constants/index.dart';

class RiskToleranceQuestionnaireScreen extends StatefulWidget {
  const RiskToleranceQuestionnaireScreen({super.key});

  @override
  State<RiskToleranceQuestionnaireScreen> createState() =>
      _RiskToleranceQuestionnaireScreenState();
}

class _RiskToleranceQuestionnaireScreenState
    extends State<RiskToleranceQuestionnaireScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Risk Profiling",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.dark100,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 20),
            const RiskProfileProgress(progress: 3),
            const SizeBox(height: 20),
          ],
        ),
      ),
    );
  }
}
