// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:investnation/bloc/index.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/data/repository/riskProfiling/index.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/widgets/core/application_progress.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';

class RiskProfilingScreen extends StatefulWidget {
  const RiskProfilingScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<RiskProfilingScreen> createState() => _RiskProfilingScreenState();
}

List riskProfileQuestions = [];

class _RiskProfilingScreenState extends State<RiskProfilingScreen> {
  bool isFetchingQuestions = false;

  late PreRiskProfileArgumentModel preRiskProfileArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
  }

  void argumentInitialization() {
    preRiskProfileArgument =
        PreRiskProfileArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        // actions: [
        //   InkWell(
        //     onTap: () {},
        //     child: SvgPicture.asset(ImageConstants.support),
        //   ),
        //   const SizeBox(width: PaddingConstants.horizontalPadding),
        // ],
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
                    "Risk Profiling",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.dark100,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  preRiskProfileArgument.isInitial
                      ? const ApplicationProgress(progress: 3)
                      : const SizeBox(),
                  SizeBox(height: preRiskProfileArgument.isInitial ? 10 : 0),
                  Text(
                    "The following questions will help us understand your current investment objectives, your investment horizon, your knowledge and Experience, return expectations and your financial circumstances.\n\nUnderstanding your risk profile will help us recommend the most suitable portfolio for you",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark80,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 10),
                ],
              ),
            ),
            Column(
              children: [
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    return GradientButton(
                      onTap: () async {
                        if (!isFetchingQuestions) {
                          final ShowButtonBloc showButtonBloc =
                              context.read<ShowButtonBloc>();
                          isFetchingQuestions = true;
                          showButtonBloc
                              .add(ShowButtonEvent(show: isFetchingQuestions));

                          try {
                            var getRpQuestionsResult =
                                await MapRiskProfileQuestions
                                    .mapRiskProfileQuestions();
                            if (getRpQuestionsResult["success"]) {
                              if (context.mounted) {
                                riskProfileQuestions.clear();
                                riskProfileQuestions = getRpQuestionsResult[
                                    "riskProfileQuestions"];
                                Navigator.pushNamed(
                                  context,
                                  Routes.riskProfileQuestionnaire,
                                  arguments: PreRiskProfileArgumentModel(
                                    isInitial: preRiskProfileArgument.isInitial,
                                  ).toMap(),
                                );
                              }
                              log("riskProfileQuestions -> $riskProfileQuestions");
                            } else {
                              if (context.mounted) {
                                showAdaptiveDialog(
                                  context: context,
                                  builder: (context) {
                                    return CustomDialog(
                                      svgAssetPath: ImageConstants.warning,
                                      title: "Sorry",
                                      message: getRpQuestionsResult[
                                              "message"] ??
                                          "There was an issue in fetching the risk profile questions, please try again later.",
                                      actionWidget: GradientButton(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        text: "Okay",
                                      ),
                                    );
                                  },
                                );
                              }
                            }
                          } catch (e) {
                            log(e.toString());
                          }

                          isFetchingQuestions = false;
                          showButtonBloc
                              .add(ShowButtonEvent(show: isFetchingQuestions));
                        }
                      },
                      text: "Start Profiling",
                      auxWidget: isFetchingQuestions
                          ? const LoaderRow()
                          : const SizeBox(),
                    );
                  },
                ),
                SizeBox(
                  height: PaddingConstants.bottomPadding +
                      MediaQuery.paddingOf(context).bottom,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
