import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/presentation/widgets/core/risk_profile_progress.dart';
import 'package:investnation/presentation/widgets/riskProfiling/index.dart';
import 'package:investnation/utils/constants/index.dart';

class RiskIncomeQuestionnaireScreen extends StatefulWidget {
  const RiskIncomeQuestionnaireScreen({super.key});

  @override
  State<RiskIncomeQuestionnaireScreen> createState() =>
      _RiskIncomeQuestionnaireScreenState();
}

class _RiskIncomeQuestionnaireScreenState
    extends State<RiskIncomeQuestionnaireScreen> {
  bool q1a = false;
  bool q1b = false;
  bool q1c = false;
  bool q1d = false;

  bool q2a = false;
  bool q2b = false;
  bool q2c = false;
  bool q2d = false;

  bool q3a = false;
  bool q3b = false;
  bool q3c = false;
  bool q3d = false;

  final PageController _pageController = PageController();
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
            const RiskProfileProgress(progress: 2),
            const SizeBox(height: 20),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: 3,
                itemBuilder: (context, index) {
                  // ! First Question
                  if (index == 0) {
                    return Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizeBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Percentage of your liquid net worth that you would like to invest with us?",
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.dark80,
                                  fontSize: (14 / Dimensions.designWidth).w,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizeBox(height: 20),
                        RiskProfileButton(
                          onTap: () {
                            setState(() {
                              q1a = true;
                              q1b = q1c = q1d = false;
                            });
                            _pageController.animateToPage(
                              index + 1,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.easeIn,
                            );
                          },
                          isSelected: q1a,
                          widget: Text(
                            "Less than 25%",
                            style: TextStyles.primaryBold.copyWith(
                              color: AppColors.dark100,
                              fontSize: (14 / Dimensions.designWidth).w,
                            ),
                          ),
                        ),
                        RiskProfileButton(
                          onTap: () {
                            setState(() {
                              q1b = true;
                              q1a = q1c = q1d = false;
                            });
                            _pageController.animateToPage(
                              index + 1,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.easeIn,
                            );
                          },
                          isSelected: q1b,
                          widget: Text(
                            "Between 25% and 50%",
                            style: TextStyles.primaryBold.copyWith(
                              color: AppColors.dark100,
                              fontSize: (14 / Dimensions.designWidth).w,
                            ),
                          ),
                        ),
                        RiskProfileButton(
                          onTap: () {
                            setState(() {
                              q1c = true;
                              q1a = q1b = q1d = false;
                            });
                            _pageController.animateToPage(
                              index + 1,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.easeIn,
                            );
                          },
                          isSelected: q1c,
                          widget: Text(
                            "More than 50%",
                            style: TextStyles.primaryBold.copyWith(
                              color: AppColors.dark100,
                              fontSize: (14 / Dimensions.designWidth).w,
                            ),
                          ),
                        ),
                        // RiskProfileButton(
                        //   onTap: () {
                        //     setState(() {
                        //       q1d = true;
                        //       q1a = q1b = q1c = false;
                        //     });
                        //     _pageController.animateToPage(
                        //       index + 1,
                        //       duration: const Duration(milliseconds: 100),
                        //       curve: Curves.easeIn,
                        //     );
                        //   },
                        //   isSelected: q1d,
                        //   widget: Text(
                        //     "Above AED 500,000",
                        //     style: TextStyles.primaryBold.copyWith(
                        //       color: AppColors.dark100,
                        //       fontSize: (14 / Dimensions.designWidth).w,
                        //     ),
                        //   ),
                        // ),
                      ],
                    );
                  } // ! Second Question
                  else if (index == 1) {
                    return Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizeBox(height: 20),
                        Row(
                          children: [
                            Text(
                              "I'm relying on the ___ of the money I have invested with you, including any earnings to cover my spending this year.",
                              style: TextStyles.primaryMedium.copyWith(
                                color: AppColors.dark80,
                                fontSize: (14 / Dimensions.designWidth).w,
                              ),
                            ),
                          ],
                        ),
                        const SizeBox(height: 20),
                        RiskProfileButton(
                          onTap: () {
                            setState(() {
                              q2a = true;
                              q2b = q2c = q2d = false;
                            });
                            _pageController.animateToPage(
                              index + 1,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.easeIn,
                            );
                          },
                          isSelected: q2a,
                          widget: Text(
                            "Less than 25%",
                            style: TextStyles.primaryBold.copyWith(
                              color: AppColors.dark100,
                              fontSize: (14 / Dimensions.designWidth).w,
                            ),
                          ),
                        ),
                        RiskProfileButton(
                          onTap: () {
                            setState(() {
                              q2b = true;
                              q2a = q2c = q2d = false;
                            });
                            _pageController.animateToPage(
                              index + 1,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.easeIn,
                            );
                          },
                          isSelected: q2b,
                          widget: Text(
                            "Between 25% and 50%",
                            style: TextStyles.primaryBold.copyWith(
                              color: AppColors.dark100,
                              fontSize: (14 / Dimensions.designWidth).w,
                            ),
                          ),
                        ),
                        RiskProfileButton(
                          onTap: () {
                            setState(() {
                              q2c = true;
                              q2a = q2b = q2d = false;
                            });
                            _pageController.animateToPage(
                              index + 1,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.easeIn,
                            );
                          },
                          isSelected: q2c,
                          widget: Text(
                            "More than 50%",
                            style: TextStyles.primaryBold.copyWith(
                              color: AppColors.dark100,
                              fontSize: (14 / Dimensions.designWidth).w,
                            ),
                          ),
                        ),
                        RiskProfileButton(
                          onTap: () {
                            setState(() {
                              q2a = true;
                              q2b = q2c = q2d = false;
                            });
                            _pageController.animateToPage(
                              index + 1,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.easeIn,
                            );
                          },
                          isSelected: q2d,
                          widget: Text(
                            "Unemployed",
                            style: TextStyles.primaryBold.copyWith(
                              color: AppColors.dark100,
                              fontSize: (14 / Dimensions.designWidth).w,
                            ),
                          ),
                        ),
                      ],
                    );
                  } //! Third Question
                  else if (index == 2) {
                    return Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizeBox(height: 20),
                        Row(
                          children: [
                            Text(
                              "How long do you want to hold your investments",
                              style: TextStyles.primaryMedium.copyWith(
                                color: AppColors.dark80,
                                fontSize: (14 / Dimensions.designWidth).w,
                              ),
                            ),
                          ],
                        ),
                        const SizeBox(height: 20),
                        RiskProfileButton(
                          onTap: () {
                            setState(() {
                              q3a = true;
                              q3b = q3c = q3d = false;
                            });
                            Navigator.pushNamed(
                                context, Routes.riskToleranceQuestionnaire);
                          },
                          isSelected: q3a,
                          widget: Text(
                            "Less than 3 years",
                            style: TextStyles.primaryBold.copyWith(
                              color: AppColors.dark100,
                              fontSize: (14 / Dimensions.designWidth).w,
                            ),
                          ),
                        ),
                        RiskProfileButton(
                          onTap: () {
                            setState(() {
                              q3b = true;
                              q3a = q3c = q3d = false;
                            });
                            Navigator.pushNamed(
                                context, Routes.riskToleranceQuestionnaire);
                          },
                          isSelected: q3b,
                          widget: Text(
                            "At least 3 years",
                            style: TextStyles.primaryBold.copyWith(
                              color: AppColors.dark100,
                              fontSize: (14 / Dimensions.designWidth).w,
                            ),
                          ),
                        ),
                        RiskProfileButton(
                          onTap: () {
                            setState(() {
                              q3c = true;
                              q3a = q3b = q3d = false;
                            });
                            Navigator.pushNamed(
                                context, Routes.riskToleranceQuestionnaire);
                          },
                          isSelected: q3c,
                          widget: Text(
                            "Above 3 years",
                            style: TextStyles.primaryBold.copyWith(
                              color: AppColors.dark100,
                              fontSize: (14 / Dimensions.designWidth).w,
                            ),
                          ),
                        ),
                        RiskProfileButton(
                          onTap: () {
                            setState(() {
                              q3d = true;
                              q3a = q3b = q3c = false;
                            });
                            Navigator.pushNamed(
                                context, Routes.riskToleranceQuestionnaire);
                          },
                          isSelected: q3d,
                          widget: Text(
                            "No specific period",
                            style: TextStyles.primaryBold.copyWith(
                              color: AppColors.dark100,
                              fontSize: (14 / Dimensions.designWidth).w,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Text("Hello");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
