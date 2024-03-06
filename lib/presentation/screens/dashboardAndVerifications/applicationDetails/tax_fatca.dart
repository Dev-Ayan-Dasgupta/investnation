import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:investnation/bloc/index.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/widgets/core/application_progress.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';

class ApplicationTaxFATCAScreen extends StatefulWidget {
  const ApplicationTaxFATCAScreen({super.key});

  @override
  State<ApplicationTaxFATCAScreen> createState() =>
      _ApplicationTaxFATCAScreenState();
}

class _ApplicationTaxFATCAScreenState extends State<ApplicationTaxFATCAScreen> {
  int progress = 2;
  bool isUSCitizen = false;
  bool isUSResident = false;
  bool isPPonly = true;
  bool isEmirateID = false;
  bool isTINvalid = false;
  bool isCRS = false;
  bool hasTIN = false;
  bool isShowButton = false;

  bool usResidentYes = false;
  bool usResidentNo = false;

  bool isQues1Yes = false;
  bool isQues2Yes = false;
  bool isQues3Yes = false;
  bool isQues4Yes = false;

  bool isQues1No = false;
  bool isQues2No = false;
  bool isQues3No = false;
  bool isQues4No = false;

  int toggles = 0;

  bool isShowTCCHelp = false;

  final TextEditingController _tinssnController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        Navigator.pushReplacementNamed(context, Routes.applicationIncome);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: AppBarLeading(
            onTap: () {
              Navigator.pushReplacementNamed(context, Routes.applicationIncome);
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
                      "FATCA/CRS",
                      style: TextStyles.primaryBold.copyWith(
                        color: AppColors.dark100,
                        fontSize: (28 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 30),
                    ApplicationProgress(progress: progress),
                    const SizeBox(height: 30),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "U.S. Resident Confirmation",
                                  style: TextStyles.primaryBold.copyWith(
                                    color: AppColors.dark100,
                                    fontSize: (16 / Dimensions.designWidth).w,
                                  ),
                                ),
                                // const SizeBox(width: 10),
                                // BlocBuilder<ShowButtonBloc, ShowButtonState>(
                                //   builder: buildTitleTooltip,
                                // ),
                              ],
                            ),
                            const SizeBox(height: 20),
                            BlocBuilder<ApplicationTaxBloc,
                                ApplicationTaxState>(
                              builder: buildQuestion1,
                            ),
                            const SizeBox(height: 10),
                            BlocBuilder<ApplicationTaxBloc,
                                ApplicationTaxState>(
                              builder: buildQuestion1Buttons,
                            ),
                            const SizeBox(height: 20),
                            BlocBuilder<ApplicationTaxBloc,
                                ApplicationTaxState>(
                              builder: buildQuestion2,
                            ),
                            const SizeBox(height: 10),
                            BlocBuilder<ApplicationTaxBloc,
                                ApplicationTaxState>(
                              builder: buildQuestion2Buttons,
                            ),
                            const SizeBox(height: 20),
                            BlocBuilder<ApplicationTaxBloc,
                                ApplicationTaxState>(
                              builder: buildQuestion3,
                            ),
                            const SizeBox(height: 10),
                            BlocBuilder<ApplicationTaxBloc,
                                ApplicationTaxState>(
                              builder: buildQuestion3Buttons,
                            ),
                            const SizeBox(height: 20),
                            BlocBuilder<ApplicationTaxBloc,
                                ApplicationTaxState>(
                              builder: buildQuestion4,
                            ),
                            const SizeBox(height: 10),
                            BlocBuilder<ApplicationTaxBloc,
                                ApplicationTaxState>(
                              builder: buildQuestion4Buttons,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<ShowButtonBloc, ShowButtonState>(
                builder: (context, state) {
                  if (isShowButton) {
                    return Column(
                      children: [
                        const SizeBox(height: 20),
                        GradientButton(
                          onTap: () async {
                            if (isQues1Yes ||
                                isQues2Yes ||
                                isQues3Yes ||
                                isQues4Yes) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomDialog(
                                    svgAssetPath: ImageConstants.warning,
                                    title: "Oops!",
                                    message:
                                        "“U.S. Person” and / or “Specified U.S. Person” are not allowed to subscribe to investment products",
                                    auxWidget: GradientButton(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          Routes.dashboard,
                                          arguments: DashboardArgumentModel(
                                            onboardingState: 5,
                                          ).toMap(),
                                        );
                                      },
                                      text: "Yes, go home",
                                    ),
                                    actionWidget: SolidButton(
                                      color: Colors.white,
                                      fontColor: AppColors.dark100,
                                      boxShadow: [BoxShadows.primary],
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      text: "Close",
                                    ),
                                  );
                                },
                              );
                            } else {
                              Navigator.pushNamed(
                                context,
                                Routes.applicationTaxCrs,
                                arguments: TaxCrsArgumentModel(
                                  isUSFATCA: storageIsUSFATCA ?? true,
                                  ustin: storageUsTin ?? "",
                                ).toMap(),
                              );
                            }
                            // await storage.write(
                            //     key: "isUSFatca",
                            //     value: isUSCitizen.toString());
                            // storageIsUSFATCA =
                            //     await storage.read(key: "isUSFatca") == "true";
                            // await storage.write(
                            //     key: "usTin", value: _tinssnController.text);
                            // storageUsTin = await storage.read(key: "usTin");

                            // await storage.write(
                            //     key: "stepsCompleted", value: 7.toString());
                            // // storageStepsCompleted = int.parse(
                            // //     await storage.read(key: "stepsCompleted") ??
                            // //         "0");
                          },
                          text: "Continue",
                        ),
                        SizeBox(
                          height: PaddingConstants.bottomPadding +
                              MediaQuery.paddingOf(context).bottom,
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        SolidButton(onTap: () {}, text: "Continue"),
                        SizeBox(
                          height: PaddingConstants.bottomPadding +
                              MediaQuery.paddingOf(context).bottom,
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildQuestion1Buttons(
      BuildContext context, ApplicationTaxState state) {
    final ApplicationTaxBloc applicationTaxBloc =
        context.read<ApplicationTaxBloc>();
    final ButtonFocussedBloc buttonFocussedBloc =
        context.read<ButtonFocussedBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    if (isUSCitizen) {
      return const SizeBox();
    } else {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                builder: (context, state) {
                  return SolidButton(
                    borderRadius: (10 / Dimensions.designWidth).w,
                    width: (182 / Dimensions.designWidth).w,
                    color: Colors.white,
                    fontColor: AppColors.dark100,
                    boxShadow: [BoxShadows.primary],
                    borderColor:
                        isQues1Yes ? AppColors.primary100 : Colors.transparent,
                    onTap: () {
                      // isUSResident = true;
                      isQues1Yes = true;
                      isQues1No = false;
                      applicationTaxBloc.add(
                        ApplicationTaxEvent(
                          isUSCitizen: isUSCitizen,
                          isUSResident: isUSResident,
                          isPPonly: isPPonly,
                          isTINvalid: isTINvalid,
                          isCRS: isCRS,
                          hasTIN: hasTIN,
                        ),
                      );
                      usResidentYes = true;
                      usResidentNo = false;
                      buttonFocussedBloc.add(
                        ButtonFocussedEvent(
                          isFocussed: isQues1Yes,
                          toggles: ++toggles,
                        ),
                      );
                      if ((isQues1No == false && isQues1Yes == false) ||
                          (isQues2No == false && isQues2Yes == false) ||
                          (isQues3No == false && isQues3Yes == false) ||
                          (isQues4No == false && isQues4Yes == false)) {
                        isShowButton = false;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      } else {
                        isShowButton = true;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      }
                    },
                    text: "Yes",
                  );
                },
              ),
              BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                builder: (context, state) {
                  return SolidButton(
                    borderRadius: (10 / Dimensions.designWidth).w,
                    width: (182 / Dimensions.designWidth).w,
                    color: Colors.white,
                    fontColor: AppColors.dark100,
                    boxShadow: [BoxShadows.primary],
                    borderColor:
                        isQues1No ? AppColors.primary100 : Colors.transparent,
                    onTap: () {
                      // isUSResident = false;
                      isQues1Yes = false;
                      isQues1No = true;
                      storageUsTin = "";
                      applicationTaxBloc.add(
                        ApplicationTaxEvent(
                          isUSCitizen: isUSCitizen,
                          isUSResident: isUSResident,
                          isPPonly: isPPonly,
                          isTINvalid: isTINvalid,
                          isCRS: isCRS,
                          hasTIN: hasTIN,
                        ),
                      );
                      usResidentYes = false;
                      usResidentNo = true;
                      buttonFocussedBloc.add(
                        ButtonFocussedEvent(
                          isFocussed: isQues1Yes,
                          toggles: ++toggles,
                        ),
                      );
                      if ((isQues1No == false && isQues1Yes == false) ||
                          (isQues2No == false && isQues2Yes == false) ||
                          (isQues3No == false && isQues3Yes == false) ||
                          (isQues4No == false && isQues4Yes == false)) {
                        isShowButton = false;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      } else {
                        isShowButton = true;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      }
                    },
                    text: "No",
                  );
                },
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget buildQuestion2Buttons(
      BuildContext context, ApplicationTaxState state) {
    final ApplicationTaxBloc applicationTaxBloc =
        context.read<ApplicationTaxBloc>();
    final ButtonFocussedBloc buttonFocussedBloc =
        context.read<ButtonFocussedBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    if (isUSCitizen) {
      return const SizeBox();
    } else {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                builder: (context, state) {
                  return SolidButton(
                    borderRadius: (10 / Dimensions.designWidth).w,
                    width: (182 / Dimensions.designWidth).w,
                    color: Colors.white,
                    fontColor: AppColors.dark100,
                    boxShadow: [BoxShadows.primary],
                    borderColor:
                        isQues2Yes ? AppColors.primary100 : Colors.transparent,
                    onTap: () {
                      // isUSResident = true;
                      isQues2Yes = true;
                      isQues2No = false;
                      applicationTaxBloc.add(
                        ApplicationTaxEvent(
                          isUSCitizen: isUSCitizen,
                          isUSResident: isUSResident,
                          isPPonly: isPPonly,
                          isTINvalid: isTINvalid,
                          isCRS: isCRS,
                          hasTIN: hasTIN,
                        ),
                      );
                      usResidentYes = true;
                      usResidentNo = false;
                      buttonFocussedBloc.add(
                        ButtonFocussedEvent(
                          isFocussed: isQues2Yes,
                          toggles: ++toggles,
                        ),
                      );
                      if ((isQues1No == false && isQues1Yes == false) ||
                          (isQues2No == false && isQues2Yes == false) ||
                          (isQues3No == false && isQues3Yes == false) ||
                          (isQues4No == false && isQues4Yes == false)) {
                        isShowButton = false;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      } else {
                        isShowButton = true;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      }
                    },
                    text: "Yes",
                  );
                },
              ),
              BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                builder: (context, state) {
                  return SolidButton(
                    borderRadius: (10 / Dimensions.designWidth).w,
                    width: (182 / Dimensions.designWidth).w,
                    color: Colors.white,
                    fontColor: AppColors.dark100,
                    boxShadow: [BoxShadows.primary],
                    borderColor:
                        isQues2No ? AppColors.primary100 : Colors.transparent,
                    onTap: () {
                      // isUSResident = false;
                      isQues2Yes = false;
                      isQues2No = true;
                      storageUsTin = "";
                      applicationTaxBloc.add(
                        ApplicationTaxEvent(
                          isUSCitizen: isUSCitizen,
                          isUSResident: isUSResident,
                          isPPonly: isPPonly,
                          isTINvalid: isTINvalid,
                          isCRS: isCRS,
                          hasTIN: hasTIN,
                        ),
                      );
                      usResidentYes = false;
                      usResidentNo = true;
                      buttonFocussedBloc.add(
                        ButtonFocussedEvent(
                          isFocussed: isQues2Yes,
                          toggles: ++toggles,
                        ),
                      );
                      if ((isQues1No == false && isQues1Yes == false) ||
                          (isQues2No == false && isQues2Yes == false) ||
                          (isQues3No == false && isQues3Yes == false) ||
                          (isQues4No == false && isQues4Yes == false)) {
                        isShowButton = false;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      } else {
                        isShowButton = true;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      }
                    },
                    text: "No",
                  );
                },
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget buildQuestion3Buttons(
      BuildContext context, ApplicationTaxState state) {
    final ApplicationTaxBloc applicationTaxBloc =
        context.read<ApplicationTaxBloc>();
    final ButtonFocussedBloc buttonFocussedBloc =
        context.read<ButtonFocussedBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    if (isUSCitizen) {
      return const SizeBox();
    } else {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                builder: (context, state) {
                  return SolidButton(
                    borderRadius: (10 / Dimensions.designWidth).w,
                    width: (182 / Dimensions.designWidth).w,
                    color: Colors.white,
                    fontColor: AppColors.dark100,
                    boxShadow: [BoxShadows.primary],
                    borderColor:
                        isQues3Yes ? AppColors.primary100 : Colors.transparent,
                    onTap: () {
                      // isUSResident = true;
                      isQues3Yes = true;
                      isQues3No = false;
                      applicationTaxBloc.add(
                        ApplicationTaxEvent(
                          isUSCitizen: isUSCitizen,
                          isUSResident: isUSResident,
                          isPPonly: isPPonly,
                          isTINvalid: isTINvalid,
                          isCRS: isCRS,
                          hasTIN: hasTIN,
                        ),
                      );
                      usResidentYes = true;
                      usResidentNo = false;
                      buttonFocussedBloc.add(
                        ButtonFocussedEvent(
                          isFocussed: isQues3Yes,
                          toggles: ++toggles,
                        ),
                      );
                      if ((isQues1No == false && isQues1Yes == false) ||
                          (isQues2No == false && isQues2Yes == false) ||
                          (isQues3No == false && isQues3Yes == false) ||
                          (isQues4No == false && isQues4Yes == false)) {
                        isShowButton = false;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      } else {
                        isShowButton = true;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      }
                    },
                    text: "Yes",
                  );
                },
              ),
              BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                builder: (context, state) {
                  return SolidButton(
                    borderRadius: (10 / Dimensions.designWidth).w,
                    width: (182 / Dimensions.designWidth).w,
                    color: Colors.white,
                    fontColor: AppColors.dark100,
                    boxShadow: [BoxShadows.primary],
                    borderColor:
                        isQues3No ? AppColors.primary100 : Colors.transparent,
                    onTap: () {
                      // isUSResident = false;
                      isQues3Yes = false;
                      isQues3No = true;
                      storageUsTin = "";
                      applicationTaxBloc.add(
                        ApplicationTaxEvent(
                          isUSCitizen: isUSCitizen,
                          isUSResident: isUSResident,
                          isPPonly: isPPonly,
                          isTINvalid: isTINvalid,
                          isCRS: isCRS,
                          hasTIN: hasTIN,
                        ),
                      );
                      usResidentYes = false;
                      usResidentNo = true;
                      buttonFocussedBloc.add(
                        ButtonFocussedEvent(
                          isFocussed: isQues3Yes,
                          toggles: ++toggles,
                        ),
                      );
                      if ((isQues1No == false && isQues1Yes == false) ||
                          (isQues2No == false && isQues2Yes == false) ||
                          (isQues3No == false && isQues3Yes == false) ||
                          (isQues4No == false && isQues4Yes == false)) {
                        isShowButton = false;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      } else {
                        isShowButton = true;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      }
                    },
                    text: "No",
                  );
                },
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget buildQuestion4Buttons(
      BuildContext context, ApplicationTaxState state) {
    final ApplicationTaxBloc applicationTaxBloc =
        context.read<ApplicationTaxBloc>();
    final ButtonFocussedBloc buttonFocussedBloc =
        context.read<ButtonFocussedBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    if (isUSCitizen) {
      return const SizeBox();
    } else {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                builder: (context, state) {
                  return SolidButton(
                    borderRadius: (10 / Dimensions.designWidth).w,
                    width: (182 / Dimensions.designWidth).w,
                    color: Colors.white,
                    fontColor: AppColors.dark100,
                    boxShadow: [BoxShadows.primary],
                    borderColor:
                        isQues4Yes ? AppColors.primary100 : Colors.transparent,
                    onTap: () {
                      // isUSResident = true;
                      isQues4Yes = true;
                      isQues4No = false;
                      applicationTaxBloc.add(
                        ApplicationTaxEvent(
                          isUSCitizen: isQues4Yes,
                          isUSResident: isQues4Yes,
                          isPPonly: isPPonly,
                          isTINvalid: isTINvalid,
                          isCRS: isCRS,
                          hasTIN: hasTIN,
                        ),
                      );
                      usResidentYes = true;
                      usResidentNo = false;
                      buttonFocussedBloc.add(
                        ButtonFocussedEvent(
                          isFocussed: isQues4Yes,
                          toggles: ++toggles,
                        ),
                      );
                      if ((isQues1No == false && isQues1Yes == false) ||
                          (isQues2No == false && isQues2Yes == false) ||
                          (isQues3No == false && isQues3Yes == false) ||
                          (isQues4No == false && isQues4Yes == false)) {
                        isShowButton = false;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      } else {
                        isShowButton = true;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      }
                    },
                    text: "Yes",
                  );
                },
              ),
              BlocBuilder<ButtonFocussedBloc, ButtonFocussedState>(
                builder: (context, state) {
                  return SolidButton(
                    borderRadius: (10 / Dimensions.designWidth).w,
                    width: (182 / Dimensions.designWidth).w,
                    color: Colors.white,
                    fontColor: AppColors.dark100,
                    boxShadow: [BoxShadows.primary],
                    borderColor:
                        isQues4No ? AppColors.primary100 : Colors.transparent,
                    onTap: () {
                      // isUSResident = false;
                      isQues4Yes = false;
                      isQues4No = true;
                      storageUsTin = "";
                      applicationTaxBloc.add(
                        ApplicationTaxEvent(
                          isUSCitizen: isQues4Yes,
                          isUSResident: isQues4Yes,
                          isPPonly: isPPonly,
                          isTINvalid: isTINvalid,
                          isCRS: isCRS,
                          hasTIN: hasTIN,
                        ),
                      );
                      usResidentYes = false;
                      usResidentNo = true;
                      buttonFocussedBloc.add(
                        ButtonFocussedEvent(
                          isFocussed: isQues4Yes,
                          toggles: ++toggles,
                        ),
                      );
                      if ((isQues1No == false && isQues1Yes == false) ||
                          (isQues2No == false && isQues2Yes == false) ||
                          (isQues3No == false && isQues3Yes == false) ||
                          (isQues4No == false && isQues4Yes == false)) {
                        isShowButton = false;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      } else {
                        isShowButton = true;
                        showButtonBloc.add(
                          ShowButtonEvent(show: isShowButton),
                        );
                      }
                    },
                    text: "No",
                  );
                },
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget buildTinTextField(BuildContext context, ApplicationTaxState state) {
    final ApplicationTaxBloc applicationTaxBloc =
        context.read<ApplicationTaxBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    if (isUSCitizen || isUSResident) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Please provide your US Tax Identification Number (TIN).",
                style: TextStyles.primary.copyWith(
                  color: AppColors.dark80,
                  fontSize: (16 / Dimensions.designWidth).w,
                ),
              ),
              const Asterisk(),
            ],
          ),
          const SizeBox(height: 10),
          CustomTextField(
            controller: _tinssnController,
            keyboardType: TextInputType.number,
            borderColor:
                !isTINvalid ? AppColors.red100 : const Color(0xFFEEEEEE),
            onChanged: (p0) {
              if (_tinssnController.text.length == 9) {
                isTINvalid = true;
                applicationTaxBloc.add(
                  ApplicationTaxEvent(
                      isUSCitizen: isUSCitizen,
                      isUSResident: isUSResident,
                      isPPonly: isPPonly,
                      isTINvalid: isTINvalid,
                      isCRS: isCRS,
                      hasTIN: hasTIN),
                );
                isShowButton = true;
                showButtonBloc.add(ShowButtonEvent(show: isShowButton));
              } else {
                isTINvalid = false;
                applicationTaxBloc.add(
                  ApplicationTaxEvent(
                      isUSCitizen: isUSCitizen,
                      isUSResident: isUSResident,
                      isPPonly: isPPonly,
                      isTINvalid: isTINvalid,
                      isCRS: isCRS,
                      hasTIN: hasTIN),
                );
                isShowButton = false;
                showButtonBloc.add(ShowButtonEvent(show: isShowButton));
              }
            },
            hintText: "000000000",
          ),
          const SizeBox(height: 7),
          Ternary(
            condition: isTINvalid,
            truthy: const SizeBox(),
            falsy: Row(
              children: [
                Icon(
                  Icons.error_rounded,
                  color: AppColors.red100,
                  size: (13 / Dimensions.designWidth).w,
                ),
                const SizeBox(width: 5),
                Text(
                  "Must be 9 digits",
                  style: TextStyles.primaryMedium.copyWith(
                    color: AppColors.red100,
                    fontSize: (12 / Dimensions.designWidth).w,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  Widget buildQuestion1(BuildContext context, ApplicationTaxState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Are you a U.S. citizen or reside in the U.S.?",
              style: TextStyles.primary.copyWith(
                color: AppColors.dark80,
                fontSize: (14 / Dimensions.designWidth).w,
              ),
            ),
            const Asterisk(),
          ],
        ),
      ],
    );
  }

  Widget buildQuestion2(BuildContext context, ApplicationTaxState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Do you have any mailing address in the U.S.?",
              style: TextStyles.primary.copyWith(
                color: AppColors.dark80,
                fontSize: (14 / Dimensions.designWidth).w,
              ),
            ),
            const Asterisk(),
          ],
        ),
      ],
    );
  }

  Widget buildQuestion3(BuildContext context, ApplicationTaxState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Do you have U.S. Telephone Number?",
              style: TextStyles.primary.copyWith(
                color: AppColors.dark80,
                fontSize: (14 / Dimensions.designWidth).w,
              ),
            ),
            const Asterisk(),
          ],
        ),
      ],
    );
  }

  Widget buildQuestion4(BuildContext context, ApplicationTaxState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Do you have any “in-care-of” or “hold mail” address in the U.S.?",
                style: TextStyles.primary.copyWith(
                  color: AppColors.dark80,
                  fontSize: (14 / Dimensions.designWidth).w,
                ),
              ),
            ),
            const Asterisk(),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tinssnController.dispose();
    super.dispose();
  }
}
