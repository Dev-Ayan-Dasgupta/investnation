import 'dart:developer';

import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:investnation/bloc/index.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/data/repository/authentication/index.dart';
import 'package:investnation/environment/index.dart';
import 'package:investnation/main.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/screens/common/index.dart';
import 'package:investnation/presentation/screens/onboarding/initialOnboarding/index.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investnation/utils/helpers/index.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  int toggle = 0;

  bool showNewPassword = false;
  bool showConfirmNewPassword = false;

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  // ? boolean flags for password criteria
  bool hasMin8 = false;
  bool hasUpperLower = false;
  bool hasNumeric = false;
  bool hasSpecial = false;

  bool isMatch = false;

  bool allTrue = false;

  bool isLoading = false;

  bool isLoggingIn = false;

  late SetPasswordArgumentModel setPasswordArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
  }

  void argumentInitialization() async {
    setPasswordArgument =
        SetPasswordArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

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
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Set Password",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.dark100,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 15),
                  Text(
                    "Please set a password for your chosen User ID",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark50,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 30),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                labels[48]["labelText"],
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.dark80,
                                  fontSize: (16 / Dimensions.designWidth).w,
                                ),
                              ),
                              const Asterisk(),
                            ],
                          ),
                          const SizeBox(height: 9),
                          BlocBuilder<ShowPasswordBloc, ShowPasswordState>(
                            builder: buildNewPassword,
                          ),
                          const SizeBox(height: 9),
                          BlocBuilder<ShowButtonBloc, ShowButtonState>(
                            builder: buildCriteriaError,
                          ),
                          const SizeBox(height: 15),
                          Row(
                            children: [
                              Text(
                                "Confirm New Password",
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.dark80,
                                  fontSize: (16 / Dimensions.designWidth).w,
                                ),
                              ),
                              const Asterisk(),
                            ],
                          ),
                          const SizeBox(height: 9),
                          BlocBuilder<ShowPasswordBloc, ShowPasswordState>(
                            builder: buildConfirmNewPassword,
                          ),
                          const SizeBox(height: 9),
                          BlocBuilder<ShowButtonBloc, ShowButtonState>(
                            builder: (context, state) {
                              if (_confirmNewPasswordController.text.length <
                                  8) {
                                return const SizeBox();
                              } else {
                                return BlocBuilder<MatchPasswordBloc,
                                    MatchPasswordState>(
                                  builder: buildMatchMessage,
                                );
                              }
                            },
                          ),
                          const SizeBox(height: 25),
                          BlocBuilder<CriteriaBloc, CriteriaState>(
                            builder: buildCriteriaSection,
                          ),
                          const SizeBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                BlocBuilder<CreatePasswordBloc, CreatePasswordState>(
                  builder: buildSubmitButton,
                ),
                SizeBox(
                  height: PaddingConstants.bottomPadding +
                      MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNewPassword(BuildContext context, ShowPasswordState state) {
    final ShowPasswordBloc passwordBloc = context.read<ShowPasswordBloc>();
    if (showNewPassword) {
      return CustomTextField(
        controller: _newPasswordController,
        minLines: 1,
        maxLines: 1,
        suffixIcon: Padding(
          padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
          child: InkWell(
            onTap: () {
              passwordBloc.add(
                  HidePasswordEvent(showPassword: false, toggle: ++toggle));
              showNewPassword = !showNewPassword;
            },
            child: Icon(
              Icons.visibility_outlined,
              color: const Color.fromRGBO(34, 97, 105, 0.5),
              size: (20 / Dimensions.designWidth).w,
            ),
          ),
        ),
        onChanged: (p0) {
          triggerCriteriaEvent(p0);
          triggerPasswordMatchEvent();
          triggerAllTrueEvent();
        },
        obscureText: !showNewPassword,
      );
    } else {
      return CustomTextField(
        controller: _newPasswordController,
        minLines: 1,
        maxLines: 1,
        suffixIcon: Padding(
          padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
          child: InkWell(
            onTap: () {
              passwordBloc.add(
                  DisplayPasswordEvent(showPassword: true, toggle: ++toggle));
              showNewPassword = !showNewPassword;
            },
            child: Icon(
              Icons.visibility_off_outlined,
              color: const Color.fromRGBO(34, 97, 105, 0.5),
              size: (20 / Dimensions.designWidth).w,
            ),
          ),
        ),
        onChanged: (p0) {
          triggerCriteriaEvent(p0);
          triggerPasswordMatchEvent();
          triggerAllTrueEvent();
        },
        obscureText: !showNewPassword,
      );
    }
  }

  Widget buildCriteriaError(BuildContext context, ShowButtonState state) {
    if (!(hasMin8 && hasUpperLower && hasNumeric && hasSpecial) &&
        _newPasswordController.text.isNotEmpty) {
      return Row(
        children: [
          SvgPicture.asset(
            ImageConstants.errorSolid,
            width: (13 / Dimensions.designWidth).w,
            height: (13 / Dimensions.designWidth).w,
          ),
          const SizeBox(width: 5),
          Text(
            "Password does not meet the criteria",
            style: TextStyles.primaryMedium.copyWith(
              color: AppColors.red100,
              fontSize: (12 / Dimensions.designWidth).w,
            ),
          ),
        ],
      );
    } else {
      return const SizeBox();
    }
  }

  Widget buildConfirmNewPassword(
      BuildContext context, ShowPasswordState state) {
    final ShowPasswordBloc confirmPasswordBloc =
        context.read<ShowPasswordBloc>();
    if (showConfirmNewPassword) {
      return CustomTextField(
        // width: 83.w,
        controller: _confirmNewPasswordController,
        minLines: 1,
        maxLines: 1,
        suffixIcon: Padding(
          padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
          child: InkWell(
            onTap: () {
              confirmPasswordBloc.add(
                  HidePasswordEvent(showPassword: false, toggle: ++toggle));
              showConfirmNewPassword = !showConfirmNewPassword;
            },
            child: Icon(
              Icons.visibility_outlined,
              color: const Color.fromRGBO(34, 97, 105, 0.5),
              size: (20 / Dimensions.designWidth).w,
            ),
          ),
        ),
        onChanged: (p0) {
          triggerPasswordMatchEvent();
          triggerAllTrueEvent();
        },
        obscureText: !showConfirmNewPassword,
      );
    } else {
      return CustomTextField(
        // width: 83.w,
        controller: _confirmNewPasswordController,
        minLines: 1,
        maxLines: 1,
        suffixIcon: Padding(
          padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
          child: InkWell(
            onTap: () {
              confirmPasswordBloc.add(
                  DisplayPasswordEvent(showPassword: true, toggle: ++toggle));
              showConfirmNewPassword = !showConfirmNewPassword;
            },
            child: Icon(
              Icons.visibility_off_outlined,
              color: const Color.fromRGBO(34, 97, 105, 0.5),
              size: (20 / Dimensions.designWidth).w,
            ),
          ),
        ),
        onChanged: (p0) {
          triggerPasswordMatchEvent();
          triggerAllTrueEvent();
        },
        obscureText: !showConfirmNewPassword,
      );
    }
  }

  Widget buildMatchMessage(BuildContext context, MatchPasswordState state) {
    return BlocBuilder<ShowPasswordBloc, ShowPasswordState>(
        builder: (context, state) {
      return Row(
        children: [
          Ternary(
            condition: isMatch,
            truthy: Icon(
              Icons.check_circle_rounded,
              color: AppColors.green100,
              size: (13 / Dimensions.designWidth).w,
            ),
            falsy: Icon(
              Icons.error,
              color: AppColors.orange100,
              size: (13 / Dimensions.designWidth).w,
            ),
          ),
          const SizeBox(width: 5),
          Text(
            isMatch ? "Password is matching" : "Password is not matching",
            style: TextStyles.primaryMedium.copyWith(
              color: isMatch ? AppColors.green100 : AppColors.orange100,
              fontSize: (12 / Dimensions.designWidth).w,
            ),
          ),
        ],
      );
    });
  }

  Widget buildCriteriaSection(BuildContext context, CriteriaState state) {
    return PasswordCriteria(
      criteria1Color: hasMin8 ? AppColors.dark100 : AppColors.red100,
      criteria2Color: hasNumeric ? AppColors.dark100 : AppColors.red100,
      criteria3Color: hasUpperLower ? AppColors.dark100 : AppColors.red100,
      criteria4Color: hasSpecial ? AppColors.dark100 : AppColors.red100,
      criteria1Widget: hasMin8
          ? SvgPicture.asset(
              ImageConstants.checkSmall,
              width: (10 / Dimensions.designWidth).w,
              height: (10 / Dimensions.designWidth).w,
            )
          : SvgPicture.asset(
              ImageConstants.redCross,
              width: (10 / Dimensions.designWidth).w,
              height: (10 / Dimensions.designWidth).w,
            ),
      criteria2Widget: hasNumeric
          ? SvgPicture.asset(
              ImageConstants.checkSmall,
              width: (10 / Dimensions.designWidth).w,
              height: (10 / Dimensions.designWidth).w,
            )
          : SvgPicture.asset(
              ImageConstants.redCross,
              width: (10 / Dimensions.designWidth).w,
              height: (10 / Dimensions.designWidth).w,
            ),
      criteria3Widget: hasUpperLower
          ? SvgPicture.asset(
              ImageConstants.checkSmall,
              width: (10 / Dimensions.designWidth).w,
              height: (10 / Dimensions.designWidth).w,
            )
          : SvgPicture.asset(
              ImageConstants.redCross,
              width: (10 / Dimensions.designWidth).w,
              height: (10 / Dimensions.designWidth).w,
            ),
      criteria4Widget: hasSpecial
          ? SvgPicture.asset(
              ImageConstants.checkSmall,
              width: (10 / Dimensions.designWidth).w,
              height: (10 / Dimensions.designWidth).w,
            )
          : SvgPicture.asset(
              ImageConstants.redCross,
              width: (10 / Dimensions.designWidth).w,
              height: (10 / Dimensions.designWidth).w,
            ),
    );
  }

  Widget buildSubmitButton(BuildContext context, CreatePasswordState state) {
    if (allTrue) {
      return Column(
        children: [
          const SizeBox(height: 15),
          GradientButton(
            onTap: () async {
              isLoading = true;
              final CreatePasswordBloc createPasswordBloc =
                  context.read<CreatePasswordBloc>();
              createPasswordBloc.add(CreatePasswordEvent(allTrue: allTrue));

              log("Request -> ${{
                "cif": pwdChangeCif,
                "password": AesHelper.encrypt(toUtf8(Environment.passPhrase),
                    toUtf8(_newPasswordController.text)),
                // EncryptDecrypt.encrypt(_newPasswordController.text),
              }}");

              try {
                var result = await MapChangePassword.mapChangePassword(
                  {
                    "cif": pwdChangeCif,
                    // storageCif ?? "UNREGISTERED",
                    // "emailId": fgtPwdEmail,
                    // storageEmail ?? "",
                    "password":
                        //  _newPasswordController.text,
                        AesHelper.encrypt(toUtf8(Environment.passPhrase),
                            toUtf8(_newPasswordController.text)),
                    // EncryptDecrypt.encrypt(_newPasswordController.text),
                  },
                  // setPasswordArgument.fromTempPassword
                  //     ? token ?? ""
                  //     : tokenCP ?? "",
                );
                log("Change Password API response -> $result");
                if (result["success"]) {
                  if (context.mounted) {
                    Navigator.pushNamed(
                      context,
                      Routes.errorSuccess,
                      // (route) => false,
                      arguments: ErrorArgumentModel(
                        hasSecondaryButton: false,
                        iconPath: ImageConstants.checkCircleOutlined,
                        title: "Password Set Successfully!",
                        message:
                            "Your password updated successfully.\nPlease log in again with your new password.",
                        buttonText: labels[205]["labelText"],
                        onTap: () async {
                          if (setPasswordArgument.fromTempPassword) {
                            final ShowButtonBloc showButtonBloc =
                                context.read<ShowButtonBloc>();
                            isLoggingIn = true;
                            showButtonBloc
                                .add(ShowButtonEvent(show: isLoggingIn));
                            log("BG Login Request -> ${{
                              "emailId": storageEmail,
                              "userTypeId": storageUserTypeId,
                              "userId": 0,
                              "companyId": storageCompanyId,
                              "password":
                                  // _confirmNewPasswordController.text,
                                  AesHelper.encrypt(
                                      toUtf8(Environment.passPhrase),
                                      toUtf8(
                                          _confirmNewPasswordController.text)),
                              // EncryptDecrypt.encrypt(
                              //     _confirmNewPasswordController.text),
                              "deviceId": storageDeviceId,
                              "registerDevice": true,
                              "deviceName": deviceName,
                              "deviceType": deviceType,
                              "appVersion": appVersion,
                              "fcmToken": fcmToken,
                            }}");

                            try {
                              var loginApiResult = await MapLogin.mapLogin(
                                {
                                  "emailId": storageEmail,
                                  "userTypeId": storageUserTypeId,
                                  "userId": 0,
                                  "companyId": storageCompanyId,
                                  "password":
                                      // _confirmNewPasswordController.text,
                                      // EncryptDecrypt.encrypt(
                                      //     _confirmNewPasswordController.text),
                                      AesHelper.encrypt(
                                          toUtf8(Environment.passPhrase),
                                          toUtf8(_confirmNewPasswordController
                                              .text)),
                                  "deviceId": storageDeviceId,
                                  "registerDevice": true,
                                  "deviceName": deviceName,
                                  "deviceType": deviceType,
                                  "appVersion": appVersion,
                                  "fcmToken": fcmToken,
                                },
                              );
                              log("BG login API result -> $loginApiResult");
                              if (loginApiResult["success"]) {
                                isUserLoggedIn = true;
                                passwordChangesToday =
                                    loginApiResult["passwordChangesToday"];
                                emailChangesToday =
                                    loginApiResult["emailChangesToday"];
                                mobileChangesToday =
                                    loginApiResult["mobileChangesToday"];
                                log("mobileChangesToday -> $mobileChangesToday");
                                onboardingState = result["onboardingState"];

                                await storage.write(
                                    key: "token",
                                    value: loginApiResult["token"]);
                                await getProfileData();
                                // ! CleverTap User Profiles
                                var profile =
                                    GenerateCleverTapJson.generateCleverTapJson(
                                  profileName ?? "",
                                  storageEidNumber ?? "",
                                  profilePrimaryEmailId ?? "",
                                  profileMobileNumber ?? "",
                                  profileDoB ?? "1970-01-01",
                                );
                                CleverTapPlugin.onUserLogin(profile);
                                CleverTapPlugin.profileSet(profile);
                                await storage.write(
                                    key: "loggedOut", value: false.toString());
                                storageLoggedOut =
                                    await storage.read(key: "loggedOut") ==
                                        "true";
                                if (context.mounted) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    Routes.onboarding,
                                    (route) => false,
                                  );
                                }
                              } else {
                                if (context.mounted) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomDialog(
                                        svgAssetPath: ImageConstants.warning,
                                        title: "Error",
                                        message: loginApiResult["message"] ??
                                            "There was an eror logging in",
                                        actionWidget: GradientButton(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          text: labels[293]["labelText"],
                                        ),
                                      );
                                    },
                                  );
                                }
                              }
                            } catch (e) {
                              log(e.toString());
                            }

                            isLoggingIn = false;
                            showButtonBloc
                                .add(ShowButtonEvent(show: isLoggingIn));
                          } else {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              Routes.loginUserId,
                              (route) => false,
                              arguments: StoriesArgumentModel(
                                      isBiometric: persistBiometric!)
                                  .toMap(),
                            );
                          }
                        },
                        auxWidget:
                            isLoggingIn ? const LoaderRow() : const SizeBox(),
                        buttonTextSecondary: "",
                        onTapSecondary: () {},
                      ).toMap(),
                    );
                  }
                  await storage.write(
                      key: "password",
                      value: AesHelper.encrypt(toUtf8(Environment.passPhrase),
                          toUtf8(_confirmNewPasswordController.text))
                      // EncryptDecrypt.encrypt(
                      //     _confirmNewPasswordController.text),
                      );
                  storagePassword = await storage.read(key: "password");
                  log("storagePassword -> $storagePassword");
                  await storage.write(key: "cif", value: cif);
                  storageCif = await storage.read(key: "cif");
                  log("storageCif -> $storageCif");
                } else {
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialog(
                          svgAssetPath: ImageConstants.warning,
                          title: "Password Change Error",
                          message: result["message"],
                          actionWidget: GradientButton(
                            onTap: () {
                              Navigator.pop(context);
                              // Navigator.pushReplacementNamed(
                              //     context, Routes.loginUserId);
                            },
                            text: labels[346]["labelText"],
                          ),
                        );
                      },
                    );
                  }
                }
              } catch (e) {
                log(e.toString());
              }

              isLoading = false;
              createPasswordBloc.add(CreatePasswordEvent(allTrue: allTrue));
            },
            text: "Save",
            auxWidget: isLoading ? const LoaderRow() : const SizeBox(),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          const SizeBox(height: 15),
          SolidButton(onTap: () {}, text: "Save"),
        ],
      );
    }
  }

  void triggerCriteriaEvent(String p0) {
    final CriteriaBloc criteriaBloc = context.read<CriteriaBloc>();
    final ShowButtonBloc showCriteriaMessageBloc =
        context.read<ShowButtonBloc>();

    if (p0.length >= 8) {
      criteriaBloc.add(CriteriaMin8Event(hasMin8: true));
      hasMin8 = true;
    } else {
      criteriaBloc.add(CriteriaMin8Event(hasMin8: false));
      hasMin8 = false;
    }

    if (p0.contains(RegExp(r'[0-9]'))) {
      criteriaBloc.add(CriteriaNumericEvent(hasNumeric: true));
      hasNumeric = true;
    } else {
      criteriaBloc.add(CriteriaNumericEvent(hasNumeric: false));
      hasNumeric = false;
    }

    if (p0.contains(RegExp(r'[A-Z]')) && p0.contains(RegExp(r'[a-z]'))) {
      criteriaBloc.add(CriteriaUpperLowerEvent(hasUpperLower: true));
      hasUpperLower = true;
    } else {
      criteriaBloc.add(CriteriaUpperLowerEvent(hasUpperLower: false));
      hasUpperLower = false;
    }

    if (p0.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      criteriaBloc.add(CriteriaSpecialEvent(hasSpecial: true));
      hasSpecial = true;
    } else {
      criteriaBloc.add(CriteriaSpecialEvent(hasSpecial: false));
      hasSpecial = false;
    }

    showCriteriaMessageBloc.add(
      ShowButtonEvent(
        show: hasMin8 && hasNumeric && hasUpperLower && hasSpecial,
      ),
    );
  }

  void triggerPasswordMatchEvent() {
    final MatchPasswordBloc matchPasswordBloc =
        context.read<MatchPasswordBloc>();

    final ShowButtonBloc matchPasswordMessageBloc =
        context.read<ShowButtonBloc>();

    if (_newPasswordController.text == _confirmNewPasswordController.text) {
      isMatch = true;
      matchPasswordBloc.add(MatchPasswordEvent(isMatch: isMatch, count: 0));
    } else {
      isMatch = false;
      matchPasswordBloc.add(MatchPasswordEvent(isMatch: isMatch, count: 0));
    }

    matchPasswordMessageBloc.add(ShowButtonEvent(show: isMatch));
  }

  void triggerAllTrueEvent() {
    allTrue = hasMin8 && hasNumeric && hasUpperLower && hasSpecial && isMatch;
    final CreatePasswordBloc createPasswordBloc =
        context.read<CreatePasswordBloc>();
    createPasswordBloc.add(CreatePasswordEvent(allTrue: allTrue));
  }

  Future<void> getProfileData() async {
    try {
      var getProfileDataResult = await MapProfileData.mapProfileData();
      log("getProfileDataResult -> $getProfileDataResult");
      if (getProfileDataResult["success"]) {
        profileName = getProfileDataResult["name"];
        await storage.write(key: "customerName", value: profileName);
        storageCustomerName = await storage.read(key: "customerName");

        profilePhotoBase64 = getProfileDataResult["profileImageBase64"];
        await storage.write(
            key: "profilePhotoBase64", value: profilePhotoBase64);
        storageProfilePhotoBase64 =
            await storage.read(key: "profilePhotoBase64");
        profileDoB = getProfileDataResult["dateOfBirth"];
        profilePrimaryEmailId = getProfileDataResult["emailID"];
        profileSecondaryEmailId = getProfileDataResult["secondaryEmail"];
        profileMobileNumber = getProfileDataResult["mobileNumber"];
        profileAddressLine1 = getProfileDataResult["addressLine_1"];
        profileAddressLine2 = getProfileDataResult["addressLine_2"];
        profileCity = getProfileDataResult["city"] ?? "";
        profileState = getProfileDataResult["state"] ?? "";
        profilePinCode = getProfileDataResult["pinCode"];
        isExpiredRiskProfiling = getProfileDataResult["isExpiredRiskProfiling"];

        await storage.write(
            key: "eiDNumber", value: getProfileDataResult["eidNo"]);
        storageEidNumber = await storage.read(key: "eiDNumber");

        await storage.write(key: "emailAddress", value: profilePrimaryEmailId);
        storageEmail = await storage.read(key: "emailAddress");
        await storage.write(
            key: "secondaryEmailAddress", value: profileSecondaryEmailId);
        storageSecondaryEmail =
            await storage.read(key: "secondaryEmailAddress");
        log("storageSecondaryEmail -> $storageSecondaryEmail");
        await storage.write(key: "mobileNumber", value: profileMobileNumber);
        storageMobileNumber = await storage.read(key: "mobileNumber");

        await storage.write(key: "addressLine1", value: profileAddressLine1);
        storageAddressLine1 = await storage.read(key: "addressLine1");
        await storage.write(key: "addressLine2", value: profileAddressLine2);
        storageAddressLine2 = await storage.read(key: "addressLine2");

        await storage.write(key: "addressCity", value: profileCity);
        storageAddressCity = await storage.read(key: "addressCity");
        await storage.write(key: "addressState", value: profileState);
        storageAddressState = await storage.read(key: "addressState");

        await storage.write(key: "poBox", value: profilePinCode);
        storageAddressPoBox = await storage.read(key: "poBox");

        profileAddress =
            "$profileAddressLine1,\n $profileAddressLine2,\n $profileCity,\n $profileState,\n $profilePinCode";
        // "${getProfileDataResult["addressLine_1"]} ${getProfileDataResult["addressLine_2"]} ${getProfileDataResult["city"] ?? ""} ${getProfileDataResult["state"] ?? ""} ${getProfileDataResult["pinCode"]}";

        log("profileName -> $profileName");
        log("profilePhotoBase64 -> $profilePhotoBase64");
        log("profileDoB -> $profileDoB");
        log("profileEmailId -> $profilePrimaryEmailId");
        log("profileSecondaryEmailId -> $profileSecondaryEmailId");
        log("profileMobileNumber -> $profileMobileNumber");
        log("profileAddress -> $profileAddress");
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
