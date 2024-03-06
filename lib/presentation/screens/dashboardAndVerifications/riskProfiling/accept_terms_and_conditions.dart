import 'dart:developer';

import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:investnation/bloc/index.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/data/repository/onboarding/index.dart';
import 'package:investnation/main.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/screens/common/index.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:investnation/utils/constants/legal.dart';
import 'package:investnation/utils/helpers/index.dart';

class AcceptTermsAndConditionsScreen extends StatefulWidget {
  const AcceptTermsAndConditionsScreen({super.key});

  @override
  State<AcceptTermsAndConditionsScreen> createState() =>
      _AcceptTermsAndConditionsScreenState();
}

class _AcceptTermsAndConditionsScreenState
    extends State<AcceptTermsAndConditionsScreen> {
  bool isChecked = false;
  final ScrollController _scrollController = ScrollController();
  bool scrollDown = true;

  bool isUploading = false;

  late CreateAccountArgumentModel createAccountArgumentModel;

  @override
  void initState() {
    super.initState();
    // createAccountArgumentModel =
    //     CreateAccountArgumentModel.fromMap(widget.argument as dynamic ?? {});
    final ScrollDirectionBloc scrollDirectionBloc =
        context.read<ScrollDirectionBloc>();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (_scrollController.hasClients) {
          if (_scrollController.offset >
              (_scrollController.position.maxScrollExtent -
                      _scrollController.position.minScrollExtent) /
                  2) {
            scrollDown = false;
            scrollDirectionBloc
                .add(ScrollDirectionEvent(scrollDown: scrollDown));
          } else {
            scrollDown = true;
            scrollDirectionBloc
                .add(ScrollDirectionEvent(scrollDown: scrollDown));
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ScrollDirectionBloc scrollDirectionBloc =
        context.read<ScrollDirectionBloc>();
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
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Terms & Conditions",
                        style: TextStyles.primaryBold.copyWith(
                          color: AppColors.dark100,
                          fontSize: (28 / Dimensions.designWidth).w,
                        ),
                      ),
                      const SizeBox(height: 20),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: 1,
                                itemBuilder: (context, _) {
                                  return SizedBox(
                                    width: 100.w,
                                    child: HtmlWidget(terms),
                                  );
                                },
                              ),
                            ),
                          ],
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
                                  child: SvgPicture.asset(
                                      ImageConstants.checkedBox),
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
                                  child: SvgPicture.asset(
                                      ImageConstants.uncheckedBox),
                                ),
                              );
                            }
                          },
                        ),
                        const SizeBox(width: 5),
                        Expanded(
                          child: Text(
                            "I've read all the terms and conditions to open the addtional account",
                            style: TextStyles.primary.copyWith(
                              color: const Color(0XFF414141),
                              fontSize: (14 / Dimensions.designWidth).w,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizeBox(height: 20),
                    BlocBuilder<ShowButtonBloc, ShowButtonState>(
                      builder: (context, state) {
                        if (isChecked) {
                          return GradientButton(
                            onTap: () async {
                              if (!isUploading) {
                                final ShowButtonBloc showButtonBloc =
                                    context.read<ShowButtonBloc>();
                                isUploading = true;
                                showButtonBloc
                                    .add(ShowButtonEvent(show: isUploading));

                                try {
                                  var createCustomerResult =
                                      await MapCreateCustomer
                                          .mapCreateCustomer();
                                  log("createCustomerResult -> $createCustomerResult");
                                  if (createCustomerResult["err"] != null) {
                                    if (context.mounted) {
                                      ApiException.apiException(
                                        context,
                                      );
                                    }
                                  } else {
                                    if (createCustomerResult["success"]) {
                                      // ! Clevertap Event

                                      Map<String, dynamic> createUserEventData =
                                          {
                                        'email': profilePrimaryEmailId ?? "",
                                        't&cAcknowledged': true,
                                        'cardCreated': true,
                                        'deviceId': deviceId,
                                      };
                                      CleverTapPlugin.recordEvent(
                                        "T&C Acknowledgement and Card Created at GAIA",
                                        createUserEventData,
                                      );

                                      await storage.write(
                                          key: "cif",
                                          value: createCustomerResult["cif"]);
                                      storageCif =
                                          await storage.read(key: "cif");
                                      log("storageCif -> $storageCif");

                                      await storage.write(
                                          key: "token",
                                          value: createCustomerResult[
                                              "renewToken"]);

                                      if (context.mounted) {
                                        Navigator.pushNamed(
                                          context,
                                          Routes.errorSuccess,
                                          arguments: ErrorArgumentModel(
                                            hasSecondaryButton: false,
                                            iconPath: ImageConstants
                                                .checkCircleOutlined,
                                            title: "Completed",
                                            message:
                                                "Great job! You're closer to completing your onboarding!",
                                            buttonText: "Continue",
                                            onTap: () {
                                              Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                Routes.dashboard,
                                                (routes) => false,
                                                arguments:
                                                    DashboardArgumentModel(
                                                  onboardingState: 8,
                                                ).toMap(),
                                              );
                                            },
                                            buttonTextSecondary: "",
                                            onTapSecondary: () {},
                                          ).toMap(),
                                        );
                                      }
                                    } else {
                                      if (context.mounted) {
                                        Navigator.pushNamed(
                                          context,
                                          Routes.pendingStatus,
                                        );
                                        // showAdaptiveDialog(
                                        //   context: context,
                                        //   builder: (context) {
                                        //     return CustomDialog(
                                        //       svgAssetPath:
                                        //           ImageConstants.warning,
                                        //       title: "Sorry",
                                        //       message: createCustomerResult[
                                        //               "message"] ??
                                        //           "There was an error in creating the customer, please try again later.",
                                        //       actionWidget: GradientButton(
                                        //         onTap: () {
                                        //           Navigator.pop(context);
                                        //         },
                                        //         text: "Okay",
                                        //       ),
                                        //     );
                                        //   },
                                        // );
                                      }
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
                            text: "I Agree",
                            auxWidget: isUploading
                                ? const LoaderRow()
                                : const SizeBox(),
                          );
                        } else {
                          return SolidButton(onTap: () {}, text: "I Agree");
                        }
                      },
                    ),
                    SizeBox(
                      height: PaddingConstants.bottomPadding +
                          MediaQuery.of(context).padding.bottom,
                    ),
                  ],
                ),
              ],
            ),
            BlocBuilder<ScrollDirectionBloc, ScrollDirectionState>(
              builder: (context, state) {
                return Positioned(
                  right: 0,
                  bottom: (150 / Dimensions.designWidth).w -
                      MediaQuery.of(context).viewPadding.bottom,
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () async {
                      if (!scrollDown) {
                        if (_scrollController.hasClients) {
                          await _scrollController.animateTo(
                            _scrollController.position.minScrollExtent,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                          );
                          scrollDown = true;
                          scrollDirectionBloc.add(
                              ScrollDirectionEvent(scrollDown: scrollDown));
                        }
                      } else {
                        if (_scrollController.hasClients) {
                          await _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                          );

                          scrollDown = false;
                          scrollDirectionBloc.add(
                              ScrollDirectionEvent(scrollDown: scrollDown));
                        }
                      }
                    },
                    child: Container(
                      width: (50 / Dimensions.designWidth).w,
                      height: (50 / Dimensions.designWidth).w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadows.primary],
                        color: Colors.white,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          !scrollDown
                              ? ImageConstants.arrowUpward
                              : ImageConstants.arrowDownward,
                          // : ImageConstants.arrowDownward,
                          width: (16 / Dimensions.designWidth).w,
                          height: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                    ),
                  ),
                );
              },
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
