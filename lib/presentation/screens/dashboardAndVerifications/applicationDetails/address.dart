import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:investnation/bloc/index.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/data/models/widgets/index.dart';
import 'package:investnation/data/repository/onboarding/index.dart';
import 'package:investnation/main.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/screens/common/index.dart';
import 'package:investnation/presentation/widgets/core/application_progress.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:investnation/utils/helpers/index.dart';

class ApplicationAddressScreen extends StatefulWidget {
  const ApplicationAddressScreen({Key? key}) : super(key: key);

  @override
  State<ApplicationAddressScreen> createState() =>
      _ApplicationAddressScreenState();
}

class _ApplicationAddressScreenState extends State<ApplicationAddressScreen> {
  int progress = 1;

  final TextEditingController _countryController =
      TextEditingController(text: "United Arab Emirates");
  final TextEditingController _address1Controller =
      TextEditingController(text: storageAddressLine1 ?? "");
  final TextEditingController _address2Controller =
      TextEditingController(text: storageAddressLine2 ?? "");
  final TextEditingController _cityController =
      TextEditingController(text: storageAddressCity ?? "");
  final TextEditingController _stateController =
      TextEditingController(text: storageAddressState ?? "");
  final TextEditingController _zipController =
      TextEditingController(text: storageAddressPoBox ?? "");

  bool isAddress1Entered = storageAddressLine1 == null ? false : true;
  bool isCitySelected = false;
  bool isCountrySelected = true;

  int toggles = 0;

  String selectedValue = "Dubai";
  DropDownCountriesModel? selectedCountry = DropDownCountriesModel(
    countryFlagBase64: dhabiCountriesWithFlags[uaeIndex].countryFlagBase64,
    countrynameOrCode: dhabiCountriesWithFlags[uaeIndex].countrynameOrCode,
  );
  String? selectedCountryName =
      dhabiCountriesWithFlags[uaeIndex].countrynameOrCode;

  String? selectedCity;

  int emirateIndex = 0;
  int dhabiCountryIndex = uaeIndex;

  bool isUploading = false;

  bool isPoValid = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DropdownSelectedBloc residenceSelectedBloc =
        context.read<DropdownSelectedBloc>();
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
              "Address",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.dark100,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 30),
            ApplicationProgress(progress: progress),
            const SizeBox(height: 30),
            Text(
              "Address Details",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.dark100,
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Country",
                          style: TextStyles.primary.copyWith(
                            color: AppColors.dark80,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                        const Asterisk(),
                      ],
                    ),
                    const SizeBox(height: 9),
                    // BlocBuilder<DropdownSelectedBloc, DropdownSelectedState>(
                    //   builder: (context, state) {
                    //     return CustomDropdownCountries(
                    //       title: "Select a country",
                    //       items: dhabiCountriesWithFlags,
                    //       value: selectedCountry,
                    //       onChanged: (value) {
                    //         ShowButtonBloc showButtonBloc =
                    //             context.read<ShowButtonBloc>();
                    //         toggles++;
                    //         isCountrySelected = true;
                    //         selectedCountry = value as DropDownCountriesModel;
                    //         selectedCountryName =
                    //             selectedCountry?.countrynameOrCode;
                    //         dhabiCountryIndex =
                    //             dhabiCountryNames.indexOf(selectedCountryName!);
                    //         // emirateIndex = emirates.indexOf(selectedValue!);
                    //         residenceSelectedBloc.add(
                    //           DropdownSelectedEvent(
                    //             isDropdownSelected:
                    //                 // isEmirateSelected &&
                    //                 isCountrySelected &&
                    //                     (isAddress1Entered
                    //                     // && isCityEntered
                    //                     ),
                    //             toggles: toggles,
                    //           ),
                    //         );
                    //         showButtonBloc
                    //             .add(ShowButtonEvent(show: isCountrySelected));
                    //       },
                    //     );
                    //   },
                    // ),
                    CustomTextField(
                      controller: _countryController,
                      onChanged: (p0) {},
                      enabled: false,
                      color: const Color(0xFFF9F9F9),
                      fontColor: const Color(0xFFAAAAAA),
                      suffixIcon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: (10 / Dimensions.designWidth).w,
                        color: const Color(0xFFAAAAAA),
                      ),
                    ),
                    const SizeBox(height: 20),
                    Row(
                      children: [
                        Text(
                          "Address line 1",
                          style: TextStyles.primary.copyWith(
                            color: AppColors.dark80,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                        const Asterisk(),
                      ],
                    ),
                    const SizeBox(height: 9),
                    CustomTextField(
                      controller: _address1Controller,
                      onChanged: (p0) {
                        if (_address1Controller.text.isEmpty) {
                          isAddress1Entered = false;
                        } else {
                          isAddress1Entered = true;
                        }
                        ShowButtonBloc showButtonBloc =
                            context.read<ShowButtonBloc>();
                        residenceSelectedBloc.add(
                          DropdownSelectedEvent(
                            isDropdownSelected:
                                // isResidenceYearSelected &&
                                (isAddress1Entered
                                // && isCityEntered
                                ),
                            toggles: toggles,
                          ),
                        );
                        showButtonBloc
                            .add(ShowButtonEvent(show: isAddress1Entered));
                      },
                      hintText: "Address",
                    ),
                    const SizeBox(height: 20),
                    Text(
                      "Address line 2",
                      style: TextStyles.primary.copyWith(
                        color: AppColors.dark80,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 9),
                    CustomTextField(
                      controller: _address2Controller,
                      onChanged: (p0) {},
                      hintText: "Address",
                    ),
                    const SizeBox(height: 20),
                    Row(
                      children: [
                        Text(
                          "City",
                          style: TextStyles.primary.copyWith(
                            color: AppColors.dark80,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                        const Asterisk(),
                      ],
                    ),
                    const SizeBox(height: 9),
                    // CustomTextField(
                    //   controller: _cityController,
                    //   onChanged: (p0) {
                    //     final ShowButtonBloc showButtonBloc =
                    //         context.read<ShowButtonBloc>();
                    //     if (p0.isEmpty) {
                    //       isCitySelected = false;
                    //     } else {
                    //       isCitySelected = true;
                    //     }
                    //     showButtonBloc.add(
                    //       ShowButtonEvent(show: isCitySelected),
                    //     );
                    //   },
                    //   hintText: "City",
                    // ),
                    BlocBuilder<DropdownSelectedBloc, DropdownSelectedState>(
                      builder: (context, state) {
                        return CustomDropDown(
                          title: "Select a City",
                          items: cityNames,
                          value: selectedCity,
                          onChanged: (value) {
                            ShowButtonBloc showButtonBloc =
                                context.read<ShowButtonBloc>();
                            toggles++;
                            isCitySelected = true;
                            selectedCity = value as String;
                            residenceSelectedBloc.add(
                              DropdownSelectedEvent(
                                isDropdownSelected:
                                    // isEmirateSelected &&
                                    isCountrySelected &&
                                        (isAddress1Entered
                                        // && isCityEntered
                                        ),
                                toggles: toggles,
                              ),
                            );
                            showButtonBloc
                                .add(ShowButtonEvent(show: isCountrySelected));
                          },
                        );
                      },
                    ),
                    const SizeBox(height: 20),
                    Row(
                      children: [
                        Text(
                          "State/Province",
                          style: TextStyles.primary.copyWith(
                            color: AppColors.dark80,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                        // const Asterisk(),
                      ],
                    ),
                    const SizeBox(height: 9),
                    CustomTextField(
                      controller: _stateController,
                      onChanged: (p0) {},
                      hintText: "State/Province",
                    ),
                    // BlocBuilder<DropdownSelectedBloc, DropdownSelectedState>(
                    //   builder: (context, state) {
                    //     return CustomDropDown(
                    //       title: "Select from the list",
                    //       items: emirates,
                    //       value: selectedValue,
                    //       onChanged: (value) {
                    //         toggles++;
                    //         isEmirateSelected = true;
                    //         selectedValue = value as String;
                    //         emirateIndex = emirates.indexOf(selectedValue!);
                    //         residenceSelectedBloc.add(
                    //           DropdownSelectedEvent(
                    //             isDropdownSelected: isEmirateSelected &&
                    //                 isCountrySelected &&
                    //                 (isAddress1Entered
                    //                 // && isCityEntered
                    //                 ),
                    //             toggles: toggles,
                    //           ),
                    //         );
                    //       },
                    //     );
                    //   },
                    // ),
                    const SizeBox(height: 20),
                    Text(
                      "Postal/Zip Code",
                      style: TextStyles.primary.copyWith(
                        color: AppColors.dark80,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 9),
                    BlocBuilder<ShowButtonBloc, ShowButtonState>(
                      builder: (context, state) {
                        return CustomTextField(
                          controller: _zipController,
                          // keyboardType: TextInputType.numberWithOptions(decimal: true),
                          borderColor: const Color(0xFFEEEEEE),
                          onChanged: (p0) {},
                          // hintText: "0000",
                        );
                      },
                    ),
                    // const SizeBox(height: 7),
                    // BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    //   builder: (context, state) {
                    //     return Ternary(
                    //       condition: (isPoValid || _zipController.text.isEmpty),
                    //       truthy: const SizeBox(),
                    //       falsy: Row(
                    //         children: [
                    //           Icon(
                    //             Icons.error_rounded,
                    //             color: AppColors.red100,
                    //             size: (13 / Dimensions.designWidth).w,
                    //           ),
                    //           const SizeBox(width: 5),
                    //           Text(
                    //             "Must be 4 digits",
                    //             style: TextStyles.primaryMedium.copyWith(
                    //               color: AppColors.red100,
                    //               fontSize: (12 / Dimensions.designWidth).w,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     );
                    //   },
                    // ),

                    const SizeBox(height: 30),
                  ],
                ),
              ),
            ),
            const SizeBox(height: 20),
            BlocBuilder<ShowButtonBloc, ShowButtonState>(
              builder: (context, state) {
                if (
                    // isEmirateSelected &&
                    isAddress1Entered && isCountrySelected && isCitySelected) {
                  return Column(
                    children: [
                      GradientButton(
                        onTap: () async {
                          if (!isUploading) {
                            final ShowButtonBloc showButtonBloc =
                                context.read<ShowButtonBloc>();
                            isUploading = true;
                            showButtonBloc
                                .add(ShowButtonEvent(show: isUploading));

                            log("uploadAddress Request -> ${{
                              "addressLine_1": _address1Controller.text,
                              "addressLine_2": _address2Controller.text,
                              "cityId": 1,
                              "stateId": 1,
                              "city": selectedCity ?? "",
                              // _cityController.text,
                              "state": _stateController.text,
                              "countryId": 1,
                              "pinCode": _zipController.text,
                            }}");
                            try {
                              var uploadAddressResult =
                                  await MapRegisterRetailCustomerAddress
                                      .mapRegisterRetailCustomerAddress(
                                {
                                  "addressLine_1": _address1Controller.text,
                                  "addressLine_2": _address2Controller.text,
                                  "cityId": 1,
                                  "stateId": 1,
                                  "city": selectedCity ?? "",
                                  // _cityController.text,

                                  "state": _stateController.text,
                                  "countryId": 1,
                                  "pinCode": _zipController.text,
                                },
                              );
                              log("uploadAddressResult -> $uploadAddressResult");
                              if (uploadAddressResult["success"]) {
                                MyGetProfileData.getProfileData();
                                await storage.write(
                                    key: "addressCountry",
                                    value: _countryController.text);
                                storageAddressCountry =
                                    await storage.read(key: "addressCountry");
                                await storage.write(
                                    key: "addressLine1",
                                    value: _address1Controller.text);
                                storageAddressLine1 =
                                    await storage.read(key: "addressLine1");
                                await storage.write(
                                    key: "addressLine2",
                                    value: _address2Controller.text);
                                storageAddressLine2 =
                                    await storage.read(key: "addressLine2");
                                await storage.write(
                                    key: "addressCity",
                                    value: _cityController.text);
                                storageAddressCity =
                                    await storage.read(key: "addressCity");
                                await storage.write(
                                    key: "addressState",
                                    value: _stateController.text);
                                storageAddressState =
                                    await storage.read(key: "addressState");
                                await storage.write(
                                    key: "addressEmirate",
                                    value: selectedValue);
                                storageAddressEmirate =
                                    await storage.read(key: "addressEmirate");
                                await storage.write(
                                    key: "poBox", value: _zipController.text);
                                storageAddressPoBox =
                                    await storage.read(key: "poBox");

                                if (context.mounted) {
                                  if (dhabiCountryIndex == uaeIndex) {
                                    Navigator.pushNamed(
                                        context, Routes.applicationIncome);
                                  } else {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.notAvailable,
                                      arguments: NotAvailableArgumentModel(
                                        country:
                                            dhabiCountries[dhabiCountryIndex]
                                                ["countryName"],
                                      ).toMap(),
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
                                        message: uploadAddressResult[
                                                "message"] ??
                                            "There was an error in uploading the address, please try again.",
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
                            showButtonBloc.add(
                              ShowButtonEvent(show: isUploading),
                            );
                            await storage.write(
                                key: "stepsCompleted", value: 5.toString());
                            storageStepsCompleted = int.parse(
                                await storage.read(key: "stepsCompleted") ??
                                    "5");
                          }
                        },
                        text: "Continue",
                        auxWidget:
                            isUploading ? const LoaderRow() : const SizeBox(),
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
                      SolidButton(
                          onTap: () {
                            log("IsCountrySelected -> $isCountrySelected");
                            log("IsCitySelected -> $isCitySelected");
                            log("IsAddress1Entered -> $isAddress1Entered");
                          },
                          text: "Continue"),
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
    );
  }

  @override
  void dispose() {
    _countryController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
  }
}
