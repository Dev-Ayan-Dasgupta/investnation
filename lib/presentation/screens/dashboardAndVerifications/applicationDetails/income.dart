import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:investnation/bloc/index.dart';
import 'package:investnation/data/repository/onboarding/index.dart';
import 'package:investnation/main.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/widgets/core/application_progress.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:investnation/utils/helpers/index.dart';

class ApplicationIncomeScreen extends StatefulWidget {
  const ApplicationIncomeScreen({super.key});

  @override
  State<ApplicationIncomeScreen> createState() =>
      _ApplicationIncomeScreenState();
}

class _ApplicationIncomeScreenState extends State<ApplicationIncomeScreen> {
  int progress = 2;

  bool isIncomeSourceSelected = storageIncomeSource == null ? false : true;
  int toggles = 0;

  String? selectedValue = storageIncomeSource;

  bool isUploading = false;

  // List<String> items = ["item1", "item2", "item3"];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        PromptExit.promptUser(context, true);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: AppBarLeading(
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, Routes.applicationAddress);
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
                      "Income",
                      style: TextStyles.primaryBold.copyWith(
                        color: AppColors.dark100,
                        fontSize: (28 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 30),
                    ApplicationProgress(progress: progress),
                    const SizeBox(height: 30),
                    Text(
                      "Income Status",
                      style: TextStyles.primaryBold.copyWith(
                        color: AppColors.dark100,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 20),
                    Text(
                      "Source of Income",
                      style: TextStyles.primary.copyWith(
                        color: AppColors.dark80,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 9),
                    BlocBuilder<DropdownSelectedBloc, DropdownSelectedState>(
                      builder: buildDropdown,
                    ),
                  ],
                ),
              ),
              BlocBuilder<DropdownSelectedBloc, DropdownSelectedState>(
                builder: buildSubmitButton,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropdown(BuildContext context, DropdownSelectedState state) {
    final DropdownSelectedBloc incomeSourceSelectedBloc =
        context.read<DropdownSelectedBloc>();
    return CustomDropDown(
      title: "Select",
      items: sourceOfIncomeDDs,
      value: selectedValue,
      onChanged: (value) {
        toggles++;
        isIncomeSourceSelected = true;
        selectedValue = value as String;
        incomeSourceSelectedBloc.add(
          DropdownSelectedEvent(
            isDropdownSelected: isIncomeSourceSelected,
            toggles: toggles,
          ),
        );
      },
    );
  }

  Widget buildSubmitButton(BuildContext context, DropdownSelectedState state) {
    if (isIncomeSourceSelected) {
      return Column(
        children: [
          GradientButton(
            onTap: () async {
              if (!isUploading) {
                final DropdownSelectedBloc showButtonBloc =
                    context.read<DropdownSelectedBloc>();
                isUploading = true;
                showButtonBloc.add(DropdownSelectedEvent(
                    isDropdownSelected: isUploading, toggles: toggles));
                await storage.write(key: "incomeSource", value: selectedValue);
                storageIncomeSource = await storage.read(key: "incomeSource");
                log("income source request -> ${{
                  "incomeSource": selectedValue
                }}");
                try {
                  var result = await MapAddOrUpdateIncomeSource
                      .mapAddOrUpdateIncomeSource(
                    {"incomeSource": selectedValue},
                  );
                  log("Income Source API response -> $result");
                  if (result["success"]) {
                    MyGetProfileData.getProfileData();
                    if (context.mounted) {
                      Navigator.pushNamed(context, Routes.applicationTaxFatca);
                    }
                  } else {
                    if (context.mounted) {
                      showAdaptiveDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                            svgAssetPath: ImageConstants.warning,
                            title: "Sorry",
                            message: result["message"] ??
                                "There was an error in uploading income source, please try again later.",
                            actionWidget: GradientButton(
                              onTap: () {},
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
                showButtonBloc.add(DropdownSelectedEvent(
                    isDropdownSelected: isUploading, toggles: toggles));

                await storage.write(key: "stepsCompleted", value: 6.toString());
                // storageStepsCompleted =
                //     int.parse(await storage.read(key: "stepsCompleted") ?? "0");
              }
            },
            text: "Continue",
            auxWidget: isUploading ? const LoaderRow() : const SizeBox(),
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
  }
}
