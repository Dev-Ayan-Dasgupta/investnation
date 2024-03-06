// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:investnation/bloc/index.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';

class RiskProfileResultsScreen extends StatefulWidget {
  const RiskProfileResultsScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<RiskProfileResultsScreen> createState() =>
      _RiskProfileResultsScreenState();
}

class _RiskProfileResultsScreenState extends State<RiskProfileResultsScreen> {
  bool isChecked = false;

  late RiskProfileArgumentModel riskProfileArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
  }

  void argumentInitialization() {
    riskProfileArgument =
        RiskProfileArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizeBox(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Based on your answers",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark80,
                      fontSize: (14 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 10),
                  Text(
                    riskProfileArgument.riskProfile[0] == "e" ||
                            riskProfileArgument.riskProfile[0] == "E"
                        ? "You are an"
                        : "You are a",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.dark100,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  // const SizeBox(height: 5),
                  Text(
                    riskProfileArgument.riskProfile,
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.dark100,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 10),
                  Text(
                    riskProfileArgument.desc,
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark80,
                      fontSize: (14 / Dimensions.designWidth).w,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                const SizeBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<CheckBoxBloc, CheckBoxState>(
                      builder: (context, state) {
                        if (isChecked) {
                          return InkWell(
                            onTap: () {
                              isChecked = false;
                              triggerCheckBoxEvent(isChecked);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(
                                  (5 / Dimensions.designWidth).w),
                              child:
                                  SvgPicture.asset(ImageConstants.checkedBox),
                            ),
                          );
                        } else {
                          return InkWell(
                            onTap: () {
                              isChecked = true;
                              triggerCheckBoxEvent(isChecked);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(
                                  (5 / Dimensions.designWidth).w),
                              child:
                                  SvgPicture.asset(ImageConstants.uncheckedBox),
                            ),
                          );
                        }
                      },
                    ),
                    const SizeBox(width: 5),
                    Expanded(
                      child: Text(
                        "I confirm that the answers to the questions are accurate and true, I agree with this risk profile.",
                        style: TextStyles.primary.copyWith(
                          color: AppColors.dark80,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizeBox(height: 10),
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    if (isChecked) {
                      return GradientButton(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.errorSuccess,
                            arguments: ErrorArgumentModel(
                              hasSecondaryButton: false,
                              iconPath: ImageConstants.checkCircleOutlined,
                              title: "Your Risk Profiling is Complete",
                              message:
                                  "Great job! You're closer to completing your onboarding!",
                              buttonText: "Continue",
                              onTap: () {
                                if (riskProfileArgument.isInitial) {
                                  Navigator.pushReplacementNamed(
                                      context, Routes.acceptTermsAndConditions);
                                } else {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    Routes.dashboard,
                                    (routes) => false,
                                    arguments: DashboardArgumentModel(
                                      onboardingState: 8,
                                    ).toMap(),
                                  );
                                }
                              },
                              buttonTextSecondary: "",
                              onTapSecondary: () {},
                            ).toMap(),
                          );
                        },
                        text: "Save my Risk Profile",
                      );
                    } else {
                      return SolidButton(
                        onTap: () {},
                        text: "Save my Risk Profile",
                      );
                    }
                  },
                ),
                const SizeBox(height: 10),
                SolidButton(
                  boxShadow: [BoxShadows.primary],
                  color: Colors.white,
                  fontColor: AppColors.dark100,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.riskProfileQuestionnaire,
                      arguments: PreRiskProfileArgumentModel(
                        isInitial: riskProfileArgument.isInitial,
                      ).toMap(),
                    );
                  },
                  text: "Retake Risk Profile",
                ),
                SizeBox(
                  height: PaddingConstants.bottomPadding +
                      MediaQuery.paddingOf(context).bottom,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void triggerCheckBoxEvent(bool isChecked) {
    final CheckBoxBloc checkBoxBloc = context.read<CheckBoxBloc>();
    checkBoxBloc.add(CheckBoxEvent(isChecked: isChecked));
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    showButtonBloc.add(ShowButtonEvent(show: isChecked));
  }
}
