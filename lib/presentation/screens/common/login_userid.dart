// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:investnation/bloc/index.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/data/repository/authentication/index.dart';
import 'package:investnation/data/repository/onboarding/index.dart';
import 'package:investnation/environment/index.dart';
import 'package:investnation/main.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/screens/common/index.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:investnation/utils/helpers/index.dart';

class LoginUserIdScreen extends StatefulWidget {
  const LoginUserIdScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<LoginUserIdScreen> createState() => _LoginUserIdScreenState();
}

String fgtPwdEmail = "";

class _LoginUserIdScreenState extends State<LoginUserIdScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController =
      TextEditingController(text: storageEmail ?? "");
  bool showPassword = false;
  bool isEmailValid = storageEmail == null ? false : true;
  int toggle = 0;

  bool isLoggingIn = false;

  bool isLoading = false;

  bool isSendingOtp = false;
  bool isClickable = true;

  late StoriesArgumentModel storiesArgument;

  @override
  void initState() {
    super.initState();
    storiesArgument =
        StoriesArgumentModel.fromMap(widget.argument as dynamic ?? {});
    if (persistBiometric! && !storageLoggedOut!) {
      performBiometricLogin();
    }
  }

  Future<void> performBiometricLogin() async {
    bool isAuthenticated = await BiometricHelper.authenticateUser();

    log("isAuthenticated -> $isAuthenticated");
    if (isAuthenticated) {
      setState(() {
        isClickable = false;
        isLoggingIn = true;
      });

      if (context.mounted) {
        onSubmit(storagePassword ?? "");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        leading: const AppBarLeading(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  (PaddingConstants.horizontalPadding / Dimensions.designWidth)
                      .w,
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Log in",
                          style: TextStyles.primaryBold.copyWith(
                            color: AppColors.dark100,
                            fontSize: (28 / Dimensions.designWidth).w,
                          ),
                        ),
                        const SizeBox(
                          height: 36,
                        ),
                        Row(
                          children: [
                            Text(
                              "User ID",
                              style: TextStyles.primaryMedium.copyWith(
                                color: AppColors.dark100,
                                fontSize: (14 / Dimensions.designWidth).w,
                              ),
                            ),
                            Text(
                              " (Email address)",
                              style: TextStyles.primaryMedium.copyWith(
                                color: AppColors.dark100,
                                fontSize: (14 / Dimensions.designWidth).w,
                              ),
                            ),
                            const Asterisk(),
                          ],
                        ),
                        const SizeBox(
                          height: 14,
                        ),
                        CustomTextField(
                          controller: _emailController,
                          borderColor: (_emailController.text.contains('@') &&
                                  _emailController.text.contains('.'))
                              ? isEmailValid ||
                                      _emailController.text.isEmpty ||
                                      !_emailController.text.contains('@') ||
                                      (_emailController.text.contains('@') &&
                                          (RegExp("[A-Za-z0-9.-]").hasMatch(
                                              _emailController.text
                                                  .split('@')
                                                  .last)) &&
                                          !(_emailController.text
                                              .split('@')
                                              .last
                                              .contains(RegExp(
                                                  r'[!@#$%^&*(),_?":{}|<>\/\\]'))))
                                  ? const Color(0xFFEEEEEE)
                                  : AppColors.red100
                              : const Color(0xFFEEEEEE),
                          suffixIcon:
                              BlocBuilder<ShowButtonBloc, ShowButtonState>(
                            builder: buildCheckCircle,
                          ),
                          onChanged: emailValidation,
                        ),
                        const SizeBox(
                          height: 24,
                        ),
                        Row(
                          children: [
                            Text(
                              "Password",
                              style: TextStyles.primaryMedium.copyWith(
                                color: AppColors.dark100,
                                fontSize: (14 / Dimensions.designWidth).w,
                              ),
                            ),
                            const Asterisk(),
                          ],
                        ),
                        const SizeBox(
                          height: 14,
                        ),
                        BlocBuilder<ShowPasswordBloc, ShowPasswordState>(
                          builder: buildShowPassword,
                        ),
                        const SizeBox(
                          height: 24,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child:
                                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                                builder: buildSubmitButton,
                              ),
                            ),
                          ],
                        ),
                        const SizeBox(
                          height: 36,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.forgotPassword,
                                );
                              },
                              // onForgotEmailPwd,
                              child: Text(
                                "Forgot Password?",
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.dark50,
                                  fontSize: (16 / Dimensions.designWidth).w,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // const SizeBox(
                        //   height: 24,
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: <Widget>[
                        //     const Expanded(
                        //         child: Divider(color: AppColors.dark80)),
                        //     const SizeBox(width: 10),
                        //     Text(
                        //       "or log in with",
                        //       style: TextStyles.primaryMedium.copyWith(
                        //         color: AppColors.dark100,
                        //         fontSize: (12 / Dimensions.designWidth).w,
                        //       ),
                        //     ),
                        //     const SizeBox(width: 10),
                        //     const Expanded(
                        //         child: Divider(color: AppColors.dark80)),
                        //   ],
                        // ),
                        // const SizeBox(
                        //   height: 24,
                        // ),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: SolidButton(
                        //         onTap: () {
                        //           Navigator.pushNamed(context, Routes.uaePass);
                        //         },
                        //         text: "Login with UAE PASS",
                        //         color: Colors.white,
                        //         fontColor: Colors.black,
                        //         borderRadius: (15 / Dimensions.designWidth).w,
                        //         borderColor: Colors.black,
                        //         borderWidth: 1,
                        //         auxWidget: Row(
                        //           children: [
                        //             SvgPicture.asset(
                        //                 ImageConstants.fingerPrint),
                        //             const SizeBox(width: 10),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.registration,
                          arguments: RegistrationArgumentModel(
                            isInitial: true,
                            isUpdateCorpEmail: false,
                          ).toMap(),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account?  ",
                          style: TextStyles.primary.copyWith(
                            color: AppColors.dark100,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Register",
                              style: TextStyles.primaryBold.copyWith(
                                color: AppColors.primary100,
                                fontSize: (16 / Dimensions.designWidth).w,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizeBox(
                  height: PaddingConstants.bottomPadding +
                      MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          ),
          isClickable
              ? const SizeBox()
              : SizedBox(
                  width: 100.w,
                  height: 100.h,
                  child: InkWell(
                    onTap: () {},
                    child: Center(
                      child: SpinKitFadingCircle(
                        color: AppColors.primary100,
                        size: (50 / Dimensions.designWidth).w,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void onForgotEmailPwd() async {
    setState(() {
      isClickable = false;
    });

    fgtPwdEmail = _emailController.text;

    if (!isLoading && isEmailValid) {
      isLoading = true;
      try {
        var result = await MapSendEmailOtp.mapSendEmailOtp(
            {"emailID": _emailController.text});
        log("Send Email OTP Response -> $result");

        if (result["success"]) {
          if (context.mounted) {
            Navigator.pushNamed(
              context,
              Routes.otp,
              arguments: OTPArgumentModel(
                emailOrPhone: _emailController.text,
                isEmail: true,
                isBusiness: false,
                isInitial: false,
                isLogin: false,
                isEmailIdUpdate: false,
                isMobileUpdate: false,
                isReKyc: false,
                isAddBeneficiary: false,
                isMakeTransfer: false,
                isMakeInvestment: false,
                isRedeem: false,
              ).toMap(),
            );
          }
        }
        isLoading = false;
        setState(() {
          isClickable = true;
        });
      } catch (e) {
        log(e.toString());
      }
    }
  }

  void emailValidation(String p0) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    isEmailValid = EmailValidator.validate(p0);
    showButtonBloc.add(ShowButtonEvent(show: isEmailValid));
    // if (EmailValidator.validate(p0)) {
    //   if (double.tryParse(p0.split('@').first) != null) {
    //     isEmailValid = false;
    //   } else {
    //     isEmailValid = true;
    //   }
    //   showButtonBloc.add(ShowButtonEvent(show: isEmailValid));
    // } else {
    //   isEmailValid = false;
    //   showButtonBloc.add(ShowButtonEvent(show: isEmailValid));
    // }
  }

  Widget buildCheckCircle(BuildContext context, ShowButtonState state) {
    if (!isEmailValid) {
      return Padding(
        padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
        child: InkWell(
          onTap: () {
            _emailController.clear();
          },
          child: SvgPicture.asset(
            ImageConstants.deleteText,
            width: (17.5 / Dimensions.designWidth).w,
            height: (17.5 / Dimensions.designWidth).w,
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
        child: SvgPicture.asset(
          ImageConstants.checkCircle,
          width: (20 / Dimensions.designWidth).w,
          height: (20 / Dimensions.designWidth).w,
          colorFilter: const ColorFilter.mode(
            AppColors.green100,
            BlendMode.srcIn,
          ),
        ),
      );
    }
  }

  Widget buildSubmitButton(BuildContext context, ShowButtonState state) {
    // final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();

    if (!isEmailValid || _passwordController.text.length < 8) {
      return SolidButton(onTap: () {}, text: "Login");
    } else {
      return BlocBuilder<ShowButtonBloc, ShowButtonState>(
        builder: (context, state) {
          return GradientButton(
            onTap: () async {
              if (!isLoggingIn) {
                final ShowButtonBloc showButtonBloc =
                    context.read<ShowButtonBloc>();
                isLoggingIn = true;
                showButtonBloc.add(ShowButtonEvent(show: isLoggingIn));
                log("Login Request -> ${{
                  "emailId": _emailController.text,
                  "userTypeId": storageUserTypeId,
                  "userId": storageUserId,
                  "companyId": storageCompanyId,
                  "password":
                      // _passwordController.text,
                      // EncryptDecrypt.encrypt(_passwordController.text),
                      AesHelper.encrypt(toUtf8(Environment.passPhrase),
                          toUtf8(_passwordController.text)),
                  "deviceId": storageDeviceId,
                  "registerDevice": false,
                  "deviceName": deviceName,
                  "deviceType": deviceType,
                  "appVersion": appVersion,
                  "fcmToken": fcmToken,
                  "isUAEPass": false,
                  "uaePassCode": "",
                }}");

                try {
                  var result = await MapLogin.mapLogin({
                    "emailId": _emailController.text,
                    "userTypeId": storageUserTypeId,
                    "userId": storageUserId,
                    "companyId": storageCompanyId,
                    "password":
                        // _passwordController.text,
                        // EncryptDecrypt.encrypt(_passwordController.text),

                        AesHelper.encrypt(toUtf8(Environment.passPhrase),
                            toUtf8(_passwordController.text)),
                    "deviceId": storageDeviceId,
                    "registerDevice": false,
                    "deviceName": deviceName,
                    "deviceType": deviceType,
                    "appVersion": appVersion,
                    "fcmToken": fcmToken,
                    "isUAEPass": false,
                    "uaePassCode": "",
                  });
                  log("Login API Response -> $result");

                  if (result["success"]) {
                    // ! If different user logs in then clear persist biometric in flutter_secure_storage
                    if (storageEmail != _emailController.text) {
                      await storage.write(
                          key: "persistBiometric", value: "false");
                      persistBiometric =
                          await storage.read(key: "persistBiometric") == "true";
                      log("persistBiometric -> $persistBiometric");
                    } else {
                      // await storage.write(
                      //     key: "persistBiometric", value: "true");
                      // persistBiometric =
                      //     await storage.read(key: "persistBiometric") == "true";
                      // log("persistBiometric -> $persistBiometric");
                    }

                    isUserLoggedIn = true;
                    if (result["isTemporaryPassword"]) {
                      if (context.mounted) {
                        Navigator.pushNamed(
                          context,
                          Routes.setPassword,
                          arguments: SetPasswordArgumentModel(
                            fromTempPassword: true,
                          ).toMap(),
                        );
                      }
                    }
                    passwordChangesToday = result["passwordChangesToday"];
                    emailChangesToday = result["emailChangesToday"];
                    mobileChangesToday = result["mobileChangesToday"];
                    onboardingState = result["onboardingState"];
                    log("mobileChangesToday -> $mobileChangesToday");
                    await storage.write(
                        key: "newInstall", value: true.toString());
                    storageIsNotNewInstall =
                        (await storage.read(key: "newInstall")) == "true";
                    await storage.write(
                        key: "loggedOut", value: false.toString());
                    storageLoggedOut =
                        await storage.read(key: "loggedOut") == "true";
                    await storage.write(
                        key: "loggedOut", value: false.toString());
                    storageLoggedOut =
                        await storage.read(key: "loggedOut") == "true";

                    await storage.write(key: "cif", value: result["cif"]);
                    storageCif = await storage.read(key: "cif");
                    log("storageCif -> $storageCif");

                    await storage.write(
                      key: "password",
                      value:
                          // EncryptDecrypt.encrypt(_passwordController.text),
                          AesHelper.encrypt(toUtf8(Environment.passPhrase),
                              toUtf8(_passwordController.text)),
                    );

                    storagePassword = await storage.read(key: "password");
                    log("storagePassword -> $storagePassword");

                    await storage.write(key: "token", value: result["token"]);
                    await getProfileData();
                    // ! CleverTap User Profiles

                    var profile = GenerateCleverTapJson.generateCleverTapJson(
                      profileName ?? "",
                      storageEidNumber ?? "",
                      profilePrimaryEmailId ?? "",
                      profileMobileNumber ?? "",
                      profileDoB ?? "1970-01-01",
                    );

                    CleverTapPlugin.onUserLogin(profile);
                    CleverTapPlugin.profileSet(profile);
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.dashboard,
                        (routes) => false,
                        arguments: DashboardArgumentModel(
                          onboardingState: result["onboardingState"],
                        ).toMap(),
                      );
                    }
                  } else {
                    await storage.write(key: "token", value: result["token"]);
                    if (context.mounted) {
                      if (result["reasonCode"] == 12) {
                        showDormantPopUp(result["reason"]);
                      } else {
                        showAdaptiveDialog(
                          context: context,
                          builder: (context) {
                            return CustomDialog(
                              svgAssetPath: ImageConstants.warning,
                              title: result["reasonCode"] == 6
                                  ? "Emirates ID expired"
                                  : "Sorry",
                              message: result["reason"] ??
                                  "There was an error while logging in, please try again later.",
                              auxWidget: result["reasonCode"] == 6
                                  ? GradientButton(
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.pushNamed(
                                          context,
                                          Routes.verificationInit,
                                          arguments:
                                              VerificationInitializationArgumentModel(
                                            isReKyc: true,
                                          ).toMap(),
                                        );
                                      },
                                      text: "Proceed",
                                    )
                                  : null,
                              actionWidget: result["reasonCode"] == 6
                                  ? SolidButton(
                                      color: Colors.white,
                                      fontColor: AppColors.dark100,
                                      boxShadow: [BoxShadows.primary],
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      text: "Cancel",
                                    )
                                  : GradientButton(
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
                  }
                } catch (e) {
                  log(e.toString());
                }

                isLoggingIn = false;
                showButtonBloc.add(ShowButtonEvent(show: isLoggingIn));
              }
            },
            text: "Login",
            auxWidget: isLoggingIn ? const LoaderRow() : const SizeBox(),
          );
        },
      );
    }
  }

  Widget buildShowPassword(BuildContext context, ShowPasswordState state) {
    final ShowPasswordBloc passwordBloc = context.read<ShowPasswordBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    if (showPassword) {
      return CustomTextField(
        controller: _passwordController,
        minLines: 1,
        maxLines: 1,
        suffixIcon: Padding(
          padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
          child: InkWell(
            onTap: () {
              passwordBloc.add(
                  HidePasswordEvent(showPassword: false, toggle: ++toggle));
              showPassword = !showPassword;
            },
            child: Icon(
              Icons.visibility_outlined,
              color: const Color.fromRGBO(34, 97, 105, 0.5),
              size: (20 / Dimensions.designWidth).w,
            ),
          ),
        ),
        onChanged: (p0) {
          // triggerCriteriaEvent(p0);
          // triggerPasswordMatchEvent();
          // triggerAllTrueEvent();
          showButtonBloc.add(ShowButtonEvent(show: showPassword));
        },
        obscureText: !showPassword,
      );
    } else {
      return CustomTextField(
        controller: _passwordController,
        minLines: 1,
        maxLines: 1,
        suffixIcon: Padding(
          padding: EdgeInsets.only(left: (10 / Dimensions.designWidth).w),
          child: InkWell(
            onTap: () {
              passwordBloc.add(
                  DisplayPasswordEvent(showPassword: true, toggle: ++toggle));
              showPassword = !showPassword;
            },
            child: Icon(
              Icons.visibility_off_outlined,
              color: const Color.fromRGBO(34, 97, 105, 0.5),
              size: (20 / Dimensions.designWidth).w,
            ),
          ),
        ),
        onChanged: (p0) {
          // triggerCriteriaEvent(p0);
          // triggerPasswordMatchEvent();
          // triggerAllTrueEvent();
          showButtonBloc.add(ShowButtonEvent(show: showPassword));
        },
        obscureText: !showPassword,
      );
    }
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
            "$profileAddressLine1${profileAddressLine1 == "" ? '' : ",\n"}$profileAddressLine2${profileAddressLine2 == "" ? '' : ",\n"}$profileCity${profileCity == "" ? '' : ",\n"}$profileState${profileState == "" ? '' : ",\n"}$profilePinCode";

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

  void onSubmit(String password) async {
    log("onSubmit request -> ${{
      "emailId": storageEmail,
      "userTypeId": storageUserTypeId,
      "userId": storageUserId,
      "companyId": storageCompanyId,
      "password": password,
      // EncryptDecrypt.encrypt(password),
      "deviceId": storageDeviceId,
      "registerDevice": false,
      "deviceName": deviceName,
      "deviceType": deviceType,
      "appVersion": appVersion,
      "fcmToken": fcmToken,
    }}");
    try {
      var result = await MapLogin.mapLogin({
        "emailId": storageEmail,
        "userTypeId": storageUserTypeId,
        "userId": storageUserId,
        "companyId": storageCompanyId,
        "password": password,
        // EncryptDecrypt.encrypt(password),
        "deviceId": storageDeviceId,
        "registerDevice": false,
        "deviceName": deviceName,
        "deviceType": deviceType,
        "appVersion": appVersion,
        "fcmToken": fcmToken,
      });
      log("Login API Response -> $result");
      await storage.write(key: "token", value: result["token"]);

      if (result["isTemporaryPassword"]) {
        if (context.mounted) {
          Navigator.pushNamed(
            context,
            Routes.setPassword,
            arguments: SetPasswordArgumentModel(
              fromTempPassword: true,
            ).toMap(),
          );
        }
      }

      if (result["success"]) {
        // ! If different user logs in then clear persist biometric in flutter_secure_storage
        if (storageEmail != _emailController.text) {
          await storage.write(key: "persistBiometric", value: "false");
          persistBiometric =
              await storage.read(key: "persistBiometric") == "true";
          log("persistBiometric -> $persistBiometric");
        } else {
          // await storage.write(key: "persistBiometric", value: "true");
          // persistBiometric =
          //     await storage.read(key: "persistBiometric") == "true";
          // log("persistBiometric -> $persistBiometric");
        }

        isUserLoggedIn = true;
        passwordChangesToday = result["passwordChangesToday"];
        emailChangesToday = result["emailChangesToday"];
        mobileChangesToday = result["mobileChangesToday"];
        onboardingState = result["onboardingState"];
        log("mobileChangesToday -> $mobileChangesToday");
        await storage.write(key: "cif", value: result["cif"]);
        storageCif = await storage.read(key: "cif");
        log("storageCif -> $storageCif");
        await storage.write(key: "newInstall", value: true.toString());
        storageIsNotNewInstall =
            (await storage.read(key: "newInstall")) == "true";
        customerName = result["customerName"];
        await storage.write(key: "customerName", value: customerName);
        storageCustomerName = await storage.read(key: "customerName");
        if (context.mounted) {
          await getProfileData();
          // ! CleverTap User Profiles
          var profile = GenerateCleverTapJson.generateCleverTapJson(
            profileName ?? "",
            storageEidNumber ?? "",
            profilePrimaryEmailId ?? "",
            profileMobileNumber ?? "",
            profileDoB ?? "1970-01-01",
          );
          CleverTapPlugin.onUserLogin(profile);
          CleverTapPlugin.profileSet(profile);
          await storage.write(key: "loggedOut", value: false.toString());
          storageLoggedOut = await storage.read(key: "loggedOut") == "true";
          if (context.mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.dashboard,
              (route) => false,
              arguments: DashboardArgumentModel(
                onboardingState: result["onboardingState"],
              ).toMap(),
            );
          }
        }
        // await storage.write(key: "cif", value: cif.toString());
        // storageCif = await storage.read(key: "cif");
        // log("storageCif -> $storageCif");

        await storage.write(key: "isCompany", value: isCompany.toString());
        storageIsCompany = await storage.read(key: "isCompany") == "true";
        log("storageIsCompany -> $storageIsCompany");

        await storage.write(
            key: "isCompanyRegistered", value: isCompanyRegistered.toString());
        storageisCompanyRegistered =
            await storage.read(key: "isCompanyRegistered") == "true";
        log("storageisCompanyRegistered -> $storageisCompanyRegistered");

        await storage.write(key: "isFirstLogin", value: true.toString());
        storageIsFirstLogin =
            (await storage.read(key: "isFirstLogin")) == "true";
      } else {
        await storage.write(key: "token", value: result["token"]);

        if (context.mounted) {
          if (result["reasonCode"] == 12) {
            showDormantPopUp(result["reason"]);
          } else {
            showAdaptiveDialog(
              context: context,
              builder: (context) {
                return CustomDialog(
                  svgAssetPath: ImageConstants.warning,
                  title: result["reasonCode"] == 6
                      ? "Emirates ID expired"
                      : "Sorry",
                  message: result["reason"] ??
                      "There was an error while logging in, please try again later.",
                  auxWidget: result["reasonCode"] == 6
                      ? GradientButton(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(
                              context,
                              Routes.verificationInit,
                              arguments:
                                  VerificationInitializationArgumentModel(
                                isReKyc: true,
                              ).toMap(),
                            );
                          },
                          text: "Proceed",
                        )
                      : null,
                  actionWidget: result["reasonCode"] == 6
                      ? SolidButton(
                          color: Colors.white,
                          fontColor: AppColors.dark100,
                          boxShadow: [BoxShadows.primary],
                          onTap: () {
                            Navigator.pop(context);
                          },
                          text: "Cancel",
                        )
                      : GradientButton(
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

        log("Reason Code -> ${result["reasonCode"]}");
      }
    } catch (e) {
      log(e.toString());
    }

    if (mounted) {
      setState(() {
        isLoggingIn = false;
      });
    }
  }

  void promptWrongCredentials() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Wrong Credentials",
          message: "You have entered invalid username or password",
          actionWidget: GradientButton(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(
                  context,
                  Routes.loginUserId,
                  arguments:
                      StoriesArgumentModel(isBiometric: persistBiometric!)
                          .toMap(),
                );
              },
              text: labels[88]["labelText"]),
        );
      },
    );
  }

  void promptVerifySession() {
    bool isLoading = false;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: messages[65]["messageText"],
          message: messages[66]["messageText"],
          auxWidget: BlocBuilder<ShowButtonBloc, ShowButtonState>(
            builder: (context, state) {
              return GradientButton(
                onTap: () async {
                  isLoading = true;
                  final ShowButtonBloc showButtonBloc =
                      context.read<ShowButtonBloc>();
                  showButtonBloc.add(ShowButtonEvent(show: isLoading));
                  log("login api request -> ${{
                    "emailId": storageEmail,
                    "userTypeId": 1,
                    "userId": storageUserId,
                    "companyId": 0,
                    "password": storagePassword ?? "",
                    // EncryptDecrypt.encrypt(storagePassword ?? ""),
                    "deviceId": storageDeviceId,
                    "registerDevice": true,
                    "deviceName": deviceName,
                    "deviceType": deviceType,
                    "appVersion": appVersion,
                    "fcmToken": fcmToken,
                  }}");

                  try {
                    var result = await MapLogin.mapLogin({
                      "emailId": storageEmail,
                      "userTypeId": 1,
                      "userId": storageUserId,
                      "companyId": 0,
                      "password": storagePassword ?? "",
                      // EncryptDecrypt.encrypt(storagePassword ?? ""),
                      "deviceId": storageDeviceId,
                      "registerDevice": true,
                      "deviceName": deviceName,
                      "deviceType": deviceType,
                      "appVersion": appVersion,
                      "fcmToken": fcmToken,
                    });
                    log("Login API Response -> $result");
                    await storage.write(key: "token", value: result["token"]);

                    if (result["isTemporaryPassword"]) {
                      if (context.mounted) {
                        Navigator.pushNamed(
                          context,
                          Routes.setPassword,
                          arguments: SetPasswordArgumentModel(
                            fromTempPassword: true,
                          ).toMap(),
                        );
                      }
                    }

                    if (result["success"]) {
                      // ! If different user logs in then clear persist biometric in flutter_secure_storage
                      if (storageEmail != _emailController.text) {
                        await storage.write(
                            key: "persistBiometric", value: "false");
                        persistBiometric =
                            await storage.read(key: "persistBiometric") ==
                                "true";
                        log("persistBiometric -> $persistBiometric");
                      } else {
                        // await storage.write(
                        //     key: "persistBiometric", value: "true");
                        // persistBiometric =
                        //     await storage.read(key: "persistBiometric") ==
                        //         "true";
                        // log("persistBiometric -> $persistBiometric");
                      }
                      isUserLoggedIn = true;
                      passwordChangesToday = result["passwordChangesToday"];
                      emailChangesToday = result["emailChangesToday"];
                      mobileChangesToday = result["mobileChangesToday"];
                      onboardingState = result["onboardingState"];
                      log("mobileChangesToday -> $mobileChangesToday");
                      await storage.write(
                          key: "newInstall", value: true.toString());
                      storageIsNotNewInstall =
                          (await storage.read(key: "newInstall")) == "true";
                      customerName = result["customerName"];
                      await storage.write(
                          key: "customerName", value: customerName);
                      storageCustomerName =
                          await storage.read(key: "customerName");
                      if (context.mounted) {
                        await storage.write(
                            key: "retailLoggedIn", value: true.toString());
                        storageRetailLoggedIn =
                            await storage.read(key: "retailLoggedIn") == "true";
                        if (context.mounted) {
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
                              await storage.read(key: "loggedOut") == "true";
                          if (context.mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              Routes.dashboard,
                              (route) => false,
                              arguments: DashboardArgumentModel(
                                onboardingState: result["onboardingState"],
                              ).toMap(),
                            );
                          }
                        }
                      }

                      await storage.write(
                          key: "isFirstLogin", value: true.toString());
                      storageIsFirstLogin =
                          (await storage.read(key: "isFirstLogin")) == "true";
                    } else {
                      await storage.write(key: "token", value: result["token"]);

                      if (context.mounted) {
                        if (result["reasonCode"] == 12) {
                          showDormantPopUp(result["reason"]);
                        } else {
                          showAdaptiveDialog(
                            context: context,
                            builder: (context) {
                              return CustomDialog(
                                svgAssetPath: ImageConstants.warning,
                                title: result["reasonCode"] == 6
                                    ? "Emirates ID expired"
                                    : "Sorry",
                                message: result["reason"] ??
                                    "There was an error while logging in, please try again later.",
                                auxWidget: result["reasonCode"] == 6
                                    ? GradientButton(
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.pushNamed(
                                            context,
                                            Routes.verificationInit,
                                            arguments:
                                                VerificationInitializationArgumentModel(
                                              isReKyc: true,
                                            ).toMap(),
                                          );
                                        },
                                        text: "Proceed",
                                      )
                                    : null,
                                actionWidget: result["reasonCode"] == 6
                                    ? SolidButton(
                                        color: Colors.white,
                                        fontColor: AppColors.dark100,
                                        boxShadow: [BoxShadows.primary],
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        text: "Cancel",
                                      )
                                    : GradientButton(
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

                      log("Reason Code -> ${result["reasonCode"]}");
                    }
                  } catch (e) {
                    log(e.toString());
                  }

                  isLoading = false;
                  showButtonBloc.add(ShowButtonEvent(show: isLoading));
                },
                text: labels[31]["labelText"],
                auxWidget: isLoading ? const LoaderRow() : const SizeBox(),
              );
            },
          ),
          actionWidget: SolidButton(
            onTap: () {
              Navigator.pop(context);
            },
            text: labels[166]["labelText"],
            color: Colors.white,
            fontColor: AppColors.dark100,
            boxShadow: [BoxShadows.primary],
          ),
        );
      },
    );
  }

  void promptMaxRetries(String reason) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Retry Limit Reached",
          message: reason,
          actionWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(
                context,
                Routes.onboarding,
              );
            },
            text: "Go Home",
          ),
        );
      },
    );
  }

  void promptKycExpired() async {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Identification Document Expired",
          message:
              "${messages[9]["messageText"]} ${messages[10]["messageText"]}",
          actionWidget: BlocBuilder<ShowButtonBloc, ShowButtonState>(
            builder: (context, state) {
              return GradientButton(
                onTap: () async {
                  Navigator.pushReplacementNamed(
                    context,
                    Routes.verificationInit,
                    arguments: VerificationInitializationArgumentModel(
                      isReKyc: true,
                    ).toMap(),
                  );
                },
                text: "Verify",
                auxWidget: isSendingOtp ? const LoaderRow() : const SizeBox(),
              );
            },
          ),
        );
      },
    );
  }

  void showDormantPopUp(String message) {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Dormant Account",
          message: message,
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
