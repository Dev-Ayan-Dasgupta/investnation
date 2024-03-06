// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:investnation/bloc/index.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/data/repository/riskProfiling/index.dart';
import 'package:investnation/main.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/screens/common/index.dart';
import 'package:investnation/presentation/screens/dashboardAndVerifications/riskProfiling/index.dart';
import 'package:investnation/presentation/widgets/core/application_progress.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/presentation/widgets/riskProfiling/index.dart';
import 'package:investnation/presentation/widgets/riskProfiling/risk_profiling_grid_item.dart';
import 'package:investnation/utils/constants/index.dart';

class RiskProfileQuestionnaireScreen extends StatefulWidget {
  const RiskProfileQuestionnaireScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<RiskProfileQuestionnaireScreen> createState() =>
      _RiskProfileQuestionnaireScreenState();
}

class _RiskProfileQuestionnaireScreenState
    extends State<RiskProfileQuestionnaireScreen> {
  List<int> answers = [];
  bool isUploading = false;
  final PageController _pageController = PageController();
  int page = 0;
  int progress = 3;

  List<AnswerStatus> answerStatuses = [];

  void populateAnswerStatuses() {
    answerStatuses.clear();
    log("riskProfileQuestions.length -> ${riskProfileQuestions.length}");
    for (var i = 0; i < riskProfileQuestions.length; i++) {
      if (riskProfileQuestions[i]["questionType"] == 0) {
        for (var j = 0;
            j < riskProfileQuestions[i]["riskProfileQuestionItems"].length;
            j++) {
          answerStatuses.add(
            AnswerStatus(
              questionId: riskProfileQuestions[i]["questionId"],
              itemId: riskProfileQuestions[i]["riskProfileQuestionItems"][j]
                  ["itemId"],
              isSelected: false,
            ),
          );
        }
      }
    }
    log("answerStatuses -> $answerStatuses");
  }

  List<bool> optionsStatus = [];

  bool showButton = false;

  List<RiskProfileGridModel> riskProfileGridModels = [
    RiskProfileGridModel(
      heading: "Funds",
      description: "(Mutual Funds and/or Exchange Funds)",
      isSelected: false,
    ),
    RiskProfileGridModel(
      heading: "Equities",
      description: "(Stocks and shares)",
      isSelected: false,
    ),
    RiskProfileGridModel(
      heading: "Bonds & Sukuls",
      description: "(Fixed Income)",
      isSelected: false,
    ),
    RiskProfileGridModel(
      heading: "Commodities",
      description: "(Gold, Silver, Oil)",
      isSelected: false,
    ),
    RiskProfileGridModel(
      heading: "Currencies",
      description: "(Buy and Sell)",
      isSelected: false,
    ),
    RiskProfileGridModel(
      heading: "Structured Products",
      description: "(Equities/Index linked)",
      isSelected: false,
    ),
    RiskProfileGridModel(
      heading: "Futures, Options, Swaps",
      description: "",
      isSelected: false,
    ),
    RiskProfileGridModel(
      heading: "Private Equity, Hedge Funds",
      description: "",
      isSelected: false,
    ),
  ];

  late PreRiskProfileArgumentModel preRiskProfileArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    populateAnswerStatuses();
  }

  void argumentInitialization() {
    preRiskProfileArgument =
        PreRiskProfileArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  void updateAnswerStatus(int quesId, int optId) {
    for (var i = 0; i < answerStatuses.length; i++) {
      if (answerStatuses[i].questionId == quesId) {
        if (answerStatuses[i].itemId == optId) {
          answerStatuses[i].isSelected = true;
        } else {
          answerStatuses[i].isSelected = false;
        }
      }
    }
  }

  bool optionSelectionStatus(int quesId, int optId) {
    for (var i = 0; i < answerStatuses.length; i++) {
      if (answerStatuses[i].questionId == quesId &&
          answerStatuses[i].itemId == optId) {
        return answerStatuses[i].isSelected;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        if (page == 0) {
          Navigator.pop(context);
        } else {
          page--;
          _pageController.animateToPage(
            page,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeIn,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: AppBarLeading(
            onTap: () {
              if (page == 0) {
                Navigator.pop(context);
              } else {
                page--;
                _pageController.animateToPage(
                  page,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeIn,
                );
              }
            },
          ),
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
                        ? ApplicationProgress(progress: progress)
                        : const SizeBox(),
                    SizeBox(height: preRiskProfileArgument.isInitial ? 10 : 0),
                    Expanded(
                      child: PageView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        itemCount: riskProfileQuestions.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      riskProfileQuestions[index]["question"],
                                      style: TextStyles.primaryMedium.copyWith(
                                        color: AppColors.dark80,
                                        fontSize:
                                            (20 / Dimensions.designWidth).w,
                                      ),
                                    ),
                                  ),
                                  const SizeBox(width: 5),
                                  riskProfileQuestions[index]
                                              ["questionHelper"] ==
                                          null
                                      ? const SizeBox()
                                      : const CustomTooltip(
                                          description: "",
                                        )
                                ],
                              ),
                              const SizeBox(height: 20),
                              riskProfileQuestions[index]["questionType"] == 0
                                  ? Flexible(
                                      child: ListView.builder(
                                        itemBuilder: (context, index2) {
                                          return RiskProfileButton(
                                            onTap: () {
                                              updateAnswerStatus(
                                                  riskProfileQuestions[index]
                                                      ["questionId"],
                                                  riskProfileQuestions[index][
                                                          "riskProfileQuestionItems"]
                                                      [index2]["itemId"]);
                                              setState(() {});
                                              page++;
                                              log("page -> $page");
                                              _pageController.animateToPage(
                                                index + 1,
                                                duration: const Duration(
                                                    milliseconds: 100),
                                                curve: Curves.easeIn,
                                              );
                                              populateAnswers(index, index2);
                                            },
                                            isSelected: optionSelectionStatus(
                                                riskProfileQuestions[index]
                                                    ["questionId"],
                                                riskProfileQuestions[index][
                                                        "riskProfileQuestionItems"]
                                                    [index2]["itemId"]),
                                            widget: HtmlWidget(
                                              riskProfileQuestions[index][
                                                      "riskProfileQuestionItems"]
                                                  [index2]["item"],
                                            ),
                                          );
                                        },
                                        itemCount: riskProfileQuestions[index]
                                                ["riskProfileQuestionItems"]
                                            .length,
                                      ),
                                    )
                                  : Flexible(
                                      child: GridView.builder(
                                        itemCount: riskProfileQuestions[index]
                                                ["riskProfileQuestionItems"]
                                            .length,
                                        // riskProfileGridModels.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 3 / 2,
                                        ),
                                        itemBuilder: (context, index2) {
                                          return Padding(
                                            padding: EdgeInsets.all(
                                                (4 / Dimensions.designWidth).w),
                                            child: RiskProfilingGridItem(
                                                onTap: () {
                                                  setState(() {
                                                    showButton = false;
                                                    log("showButton -> $showButton");
                                                    riskProfileGridModels[
                                                                index2]
                                                            .isSelected =
                                                        !(riskProfileGridModels[
                                                                index2]
                                                            .isSelected);
                                                    populateAnswers(
                                                        index, index2);
                                                    for (var i = 0;
                                                        i <
                                                            riskProfileGridModels
                                                                .length;
                                                        i++) {
                                                      if (riskProfileGridModels[
                                                              i]
                                                          .isSelected) {
                                                        showButton = true;
                                                        log("showButton -> $showButton");
                                                        break;
                                                      }
                                                    }
                                                  });
                                                },
                                                isSelected:
                                                    riskProfileGridModels[
                                                            index2]
                                                        .isSelected,
                                                // heading: riskProfileGridModels[index2]
                                                //     .heading,
                                                description: riskProfileQuestions[
                                                            index][
                                                        "riskProfileQuestionItems"]
                                                    [index2]["item"]),
                                          );
                                        },
                                      ),
                                    ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Ternary(
                condition:
                    (page == riskProfileQuestions.length - 1) && showButton,
                truthy: Column(
                  children: [
                    BlocBuilder<ShowButtonBloc, ShowButtonState>(
                      builder: (context, state) {
                        return GradientButton(
                          onTap: () async {
                            if (!isUploading) {
                              final ShowButtonBloc showButtonBloc =
                                  context.read<ShowButtonBloc>();
                              isUploading = true;
                              showButtonBloc
                                  .add(ShowButtonEvent(show: isUploading));
                              log("set RP Request -> ${{
                                "questions": answers
                              }}");
                              try {
                                var setRpResult =
                                    await MapSetRiskProfile.mapSetRiskProfile(
                                  {"questions": answers},
                                );
                                log("setRpResult -> $setRpResult");
                                if (setRpResult["success"]) {
                                  var getRpResult =
                                      await MapRiskProfile.mapRiskProfile();
                                  log("getRpResult -> $getRpResult");
                                  if (getRpResult["success"]) {
                                    // ! Clevertap
                                    Map<String, dynamic>
                                        setRiskProfileEventData = {
                                      'isRiskProfileSuccess': true,
                                      'riskProfile':
                                          getRpResult["riskProfile"] ?? "",
                                      'registrationStatus': 8,
                                      'deviceId': deviceId,
                                    };
                                    CleverTapPlugin.recordEvent(
                                      "Set Risk Profile",
                                      setRiskProfileEventData,
                                    );

                                    await storage.write(
                                        key: "riskProfile",
                                        value: getRpResult["riskProfile"]);
                                    storageRiskProfile = await storage.read(
                                            key: "riskProfile") ??
                                        "";
                                    log("storageRiskProfile -> $storageRiskProfile");
                                    if (context.mounted) {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.riskProfilingResults,
                                        arguments: RiskProfileArgumentModel(
                                          riskProfile:
                                              getRpResult["riskProfile"],
                                          desc: getRpResult["desc"],
                                          isInitial:
                                              preRiskProfileArgument.isInitial,
                                        ).toMap(),
                                      );
                                    }
                                  } else {
                                    if (context.mounted) {
                                      showAdaptiveDialog(
                                        context: context,
                                        builder: (context) {
                                          return CustomDialog(
                                            svgAssetPath:
                                                ImageConstants.warning,
                                            title: "Sorry",
                                            message: getRpResult["message"] ??
                                                "There was an error in fetching your risk profile, please try again later.",
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
                                } else {
                                  if (context.mounted) {
                                    showAdaptiveDialog(
                                      context: context,
                                      builder: (context) {
                                        return CustomDialog(
                                          svgAssetPath: ImageConstants.warning,
                                          title: "Sorry",
                                          message: setRpResult["message"] ??
                                              "There was an error in setting your risk profile, please try again later.",
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

                              isUploading = false;
                              showButtonBloc
                                  .add(ShowButtonEvent(show: isUploading));
                            }
                          },
                          text: page == riskProfileQuestions.length - 1
                              ? "Proceed"
                              : "Next",
                          auxWidget:
                              isUploading ? const LoaderRow() : const SizeBox(),
                        );
                      },
                    ),
                    SizeBox(
                      height: PaddingConstants.bottomPadding +
                          MediaQuery.paddingOf(context).bottom,
                    ),
                  ],
                ),
                falsy: const SizeBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void populateAnswers(int idx, int option) {
    if (idx < 8) {
      for (var i = 0;
          i < riskProfileQuestions[idx]["riskProfileQuestionItems"].length;
          i++) {
        if (answers.contains(riskProfileQuestions[idx]
            ["riskProfileQuestionItems"][i]["itemId"])) {
          answers.remove(riskProfileQuestions[idx]["riskProfileQuestionItems"]
              [i]["itemId"]);
          break;
        }
      }
      answers.add(riskProfileQuestions[idx]["riskProfileQuestionItems"][option]
          ["itemId"]);
    } else {
      if (answers.contains(riskProfileQuestions[idx]["riskProfileQuestionItems"]
          [option]["itemId"])) {
        answers.remove(riskProfileQuestions[idx]["riskProfileQuestionItems"]
            [option]["itemId"]);
      } else {
        answers.add(riskProfileQuestions[idx]["riskProfileQuestionItems"]
            [option]["itemId"]);
      }
    }
    log("answers -> $answers");
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class RiskProfileGridModel {
  final String heading;
  final String description;
  bool isSelected;
  RiskProfileGridModel({
    required this.heading,
    required this.description,
    required this.isSelected,
  });
}

class AnswerStatus {
  int questionId;
  int itemId;
  bool isSelected;
  AnswerStatus({
    required this.questionId,
    required this.itemId,
    required this.isSelected,
  });

  AnswerStatus copyWith({
    int? questionId,
    int? itemId,
    bool? isSelected,
  }) {
    return AnswerStatus(
      questionId: questionId ?? this.questionId,
      itemId: itemId ?? this.itemId,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'questionId': questionId,
      'itemId': itemId,
      'isSelected': isSelected,
    };
  }

  factory AnswerStatus.fromMap(Map<String, dynamic> map) {
    return AnswerStatus(
      questionId: map['questionId'] as int,
      itemId: map['itemId'] as int,
      isSelected: map['isSelected'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory AnswerStatus.fromJson(String source) =>
      AnswerStatus.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AnswerStatus(questionId: $questionId, itemId: $itemId, isSelected: $isSelected)';

  @override
  bool operator ==(covariant AnswerStatus other) {
    if (identical(this, other)) return true;

    return other.questionId == questionId &&
        other.itemId == itemId &&
        other.isSelected == isSelected;
  }

  @override
  int get hashCode =>
      questionId.hashCode ^ itemId.hashCode ^ isSelected.hashCode;
}
