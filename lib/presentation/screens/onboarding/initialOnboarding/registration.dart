import 'dart:developer';

import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:investnation/bloc/index.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/data/repository/onboarding/index.dart';
import 'package:investnation/data/repository/referral/index.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/screens/common/index.dart';

import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

String emailAddress = "";

bool isRefCode = false;
String refCode = "";

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailValid = false;
  late RegistrationArgumentModel registrationArgument;
  // bool _isLoading = false;
  bool isChecked = false;

  final TextEditingController _referralIdController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    registrationArgument =
        RegistrationArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const AppBarLeading(
            // onTap: () {
            //   PromptAreYouSure.promptUser(context, true);
            // },
            ),
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
                    "Let's get Started!",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.dark100,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    "This Email address will be used as your User ID for your account",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark50,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "Email Address",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark100,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      const Asterisk(),
                    ],
                  ),
                  const SizeBox(height: 10),
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                      return CustomTextField(
                        borderColor: (_emailController.text.contains('@') &&
                                _emailController.text.contains('.'))
                            ? _isEmailValid ||
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
                        controller: _emailController,
                        suffixIcon:
                            BlocBuilder<ShowButtonBloc, ShowButtonState>(
                          builder: buildCheckCircle,
                        ),
                        onChanged: emailValidation,
                      );
                    },
                  ),
                  const SizeBox(height: 8),
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: buildErrorMessage,
                  ),
                  const SizeBox(height: 10),
                  Row(
                    children: [
                      BlocBuilder<CheckBoxBloc, CheckBoxState>(
                        builder: buildCheckBox,
                      ),
                      const SizeBox(width: 5),
                      Row(
                        children: [
                          Text(
                            'I have been referred by someone else',
                            style: TextStyles.primary.copyWith(
                              color: const Color.fromRGBO(0, 0, 0, 0.5),
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: buildSubmitButton,
                ),
                const SizeBox(height: 10),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.loginUserId,
                      arguments:
                          StoriesArgumentModel(isBiometric: persistBiometric!)
                              .toMap(),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account?",
                      style: TextStyles.primary.copyWith(
                        color: AppColors.dark100,
                        fontSize: (16 / Dimensions.designWidth).w,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: " Login",
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
    );
  }

  Widget buildCheckBox(BuildContext context, CheckBoxState state) {
    if (isChecked) {
      return InkWell(
        onTap: () {
          isChecked = false;
          triggerCheckBoxEvent(isChecked);
          // triggerAllTrueEvent();
        },
        child: Padding(
          padding: EdgeInsets.all((5 / Dimensions.designWidth).w),
          child: SvgPicture.asset(
            ImageConstants.checkedBox,
            width: (14 / Dimensions.designWidth).w,
            height: (14 / Dimensions.designWidth).w,
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          isChecked = true;
          triggerCheckBoxEvent(isChecked);
          // triggerAllTrueEvent();
        },
        child: Padding(
          padding: EdgeInsets.all((5 / Dimensions.designWidth).w),
          child: SvgPicture.asset(
            ImageConstants.uncheckedBox,
            width: (14 / Dimensions.designWidth).w,
            height: (14 / Dimensions.designWidth).w,
          ),
        ),
      );
    }
  }

  Widget buildCheckCircle(BuildContext context, ShowButtonState state) {
    if (!_isEmailValid) {
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

  void triggerCheckBoxEvent(bool isChecked) {
    final CheckBoxBloc checkBoxBloc = context.read<CheckBoxBloc>();
    checkBoxBloc.add(CheckBoxEvent(isChecked: isChecked));
  }

  void emailValidation(String p0) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    if (EmailValidator.validate(p0)) {
      _isEmailValid = true;
      // if (double.tryParse(p0.split('@').first) != null) {
      //   _isEmailValid = false;
      // } else {

      // }
      showButtonBloc.add(ShowButtonEvent(show: _isEmailValid));
    } else {
      _isEmailValid = false;
      showButtonBloc.add(ShowButtonEvent(show: _isEmailValid));
    }
    showButtonBloc.add(ShowButtonEvent(show: _isEmailValid || p0.length <= 5));
    log(_emailController.text.split('@').last);
    log("contains non spcl -> ${(RegExp("[A-Za-z0-9.-]").hasMatch(_emailController.text.split('@').last))}");
    log("does not contain spcl -> ${!(_emailController.text.split('@').last.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')))}");
    log("@ is last -> ${_emailController.text.split('@').last.isEmpty}");
  }

  Widget buildErrorMessage(BuildContext context, ShowButtonState state) {
    if ((double.tryParse(_emailController.text.split('@').first) != null) ||
        (_emailController.text.contains('@') &&
            _emailController.text.contains('.'))) {
      if ((_isEmailValid ||
          _emailController.text.isEmpty ||
          !_emailController.text.contains('@') ||
          (_emailController.text.contains('@') &&
              (RegExp("[A-Za-z0-9.-]")
                  .hasMatch(_emailController.text.split('@').last)) &&
              !(_emailController.text
                  .split('@')
                  .last
                  .contains(RegExp(r'[!@#$%^&*(),_?":{}|<>\/\\]')))))) {
        return const SizeBox();
      } else {
        return Row(
          children: [
            SvgPicture.asset(
              ImageConstants.errorSolid,
              width: (10 / Dimensions.designWidth).w,
              height: (10 / Dimensions.designWidth).w,
            ),
            const SizeBox(width: 5),
            Text(
              "Invalid email address",
              style: TextStyles.primaryMedium.copyWith(
                color: const Color(0xFFC94540),
                fontSize: (12 / Dimensions.designWidth).w,
              ),
            ),
          ],
        );
      }
    } else {
      return const SizeBox();
    }
  }

  Widget buildSubmitButton(BuildContext context, ShowButtonState state) {
    // final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();

    if (!_isEmailValid) {
      return SolidButton(onTap: () {}, text: "Proceed");
    } else {
      return BlocBuilder<ShowButtonBloc, ShowButtonState>(
        builder: (context, state) {
          return GradientButton(
            onTap: () async {
              if (isChecked) {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (context) {
                    final ShowButtonBloc showButtonBloc =
                        context.read<ShowButtonBloc>();
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                (10 / Dimensions.designWidth).w),
                            topRight: Radius.circular(
                                (10 / Dimensions.designWidth).w),
                          ),
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: (PaddingConstants.horizontalPadding /
                                  Dimensions.designWidth)
                              .w,
                          vertical: (PaddingConstants.bottomPadding /
                                  Dimensions.designHeight)
                              .h,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              ImageConstants.warning,
                              width: (111 / Dimensions.designHeight).h,
                              height: (111 / Dimensions.designHeight).h,
                            ),
                            const SizeBox(height: 20),
                            Text(
                              "Enter the referral ID",
                              style: TextStyles.primaryBold.copyWith(
                                color: AppColors.dark100,
                                fontSize: (20 / Dimensions.designWidth).w,
                              ),
                            ),
                            const SizeBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  "Referral ID",
                                  style: TextStyles.primaryMedium.copyWith(
                                    color: AppColors.dark100,
                                    fontSize: (16 / Dimensions.designWidth).w,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const Asterisk(),
                              ],
                            ),
                            const SizeBox(height: 8),
                            CustomTextField(
                              controller: _referralIdController,
                              onChanged: (p0) {
                                // final ShowButtonBloc showButtonBloc =
                                //     context.read<ShowButtonBloc>();
                                showButtonBloc.add(ShowButtonEvent(
                                    show: _referralIdController.text.length ==
                                        8));
                              },
                            ),
                            const SizeBox(height: 15),
                            BlocBuilder<ShowButtonBloc, ShowButtonState>(
                              builder: (context, state) {
                                if (_referralIdController.text.length == 8) {
                                  return GradientButton(
                                    onTap: () async {
                                      if (!isLoading) {
                                        ShowButtonBloc showButtonBloc =
                                            context.read<ShowButtonBloc>();
                                        isLoading = true;
                                        showButtonBloc.add(
                                            ShowButtonEvent(show: isLoading));

                                        log("Check Ref Code req -> ${{
                                          "referralCode":
                                              _referralIdController.text,
                                        }}");

                                        try {
                                          var checkReferralCodeRes =
                                              await MapCheckReferralCode
                                                  .mapCheckReferralCode({
                                            "referralCode":
                                                _referralIdController.text,
                                          });

                                          log("checkReferralCodeRes -> $checkReferralCodeRes");
                                          if (checkReferralCodeRes["success"]) {
                                            isRefCode = true;
                                            refCode =
                                                _referralIdController.text;
                                            Map<String, dynamic>
                                                registerReferralEventData = {
                                              'email': _emailController.text,
                                              'referralCode':
                                                  _referralIdController.text,
                                              'registrationStatus': 0,
                                              'deviceId': deviceId,
                                            };
                                            CleverTapPlugin.recordEvent(
                                              "Referral Entered",
                                              registerReferralEventData,
                                            );
                                            await otpScreenNav();
                                          } else {
                                            if (context.mounted) {
                                              showAdaptiveDialog(
                                                context: context,
                                                builder: (context) {
                                                  return CustomDialog(
                                                    svgAssetPath:
                                                        ImageConstants.warning,
                                                    title: "Sorry",
                                                    message: checkReferralCodeRes[
                                                            "message"] ??
                                                        "You have entered an invalid Referral Code",
                                                    actionWidget:
                                                        GradientButton(
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

                                        isLoading = false;
                                        showButtonBloc.add(
                                            ShowButtonEvent(show: isLoading));
                                      }
                                    },
                                    text: "Proceed",
                                    auxWidget: isLoading
                                        ? const LoaderRow()
                                        : const SizeBox(),
                                  );
                                } else {
                                  return SolidButton(
                                    onTap: () {},
                                    text: "Proceed",
                                  );
                                }
                              },
                            ),
                            const SizeBox(height: 10),
                            SolidButton(
                              boxShadow: [BoxShadows.primary],
                              fontColor: AppColors.dark100,
                              color: Colors.white,
                              onTap: () {
                                Navigator.pop(context);
                              },
                              text: "Go Back",
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                if (!isLoading) {
                  ShowButtonBloc showButtonBloc =
                      context.read<ShowButtonBloc>();
                  isLoading = true;
                  showButtonBloc.add(ShowButtonEvent(show: isLoading));

                  Map<String, dynamic> registerEventData = {
                    'email': _emailController.text,
                    'registrationStatus': 0,
                    'deviceId': deviceId,
                  };
                  CleverTapPlugin.recordEvent(
                    "Start Register",
                    registerEventData,
                  );

                  await otpScreenNav();

                  isLoading = false;
                  showButtonBloc.add(ShowButtonEvent(show: isLoading));
                }
              }
            },
            text: "Proceed",
            auxWidget: isLoading ? const LoaderRow() : const SizeBox(),
          );
        },
      );
    }
  }

  Future<void> otpScreenNav() async {
    log("Validate Email Request -> ${{
      "emailId": _emailController.text,
      "userTypeId": 1,
    }}");
    try {
      var validateEmailResult = await MapValidateEmail.mapValidateEmail({
        "emailId": _emailController.text,
        "userTypeId": 1,
      });
      log("Validate Email API Response -> $validateEmailResult");
      if (validateEmailResult["success"]) {
        try {
          var sendEmailOtpResult = await MapSendEmailOtp.mapSendEmailOtp(
            {
              "emailID": _emailController.text,
            },
          );
          if (sendEmailOtpResult["success"]) {
            if (context.mounted) {
              Navigator.pushNamed(
                context,
                Routes.otp,
                arguments: OTPArgumentModel(
                  emailOrPhone: _emailController.text,
                  isEmail: true,
                  isBusiness:
                      registrationArgument.isUpdateCorpEmail ? true : false,
                  isInitial: registrationArgument.isInitial,
                  isLogin: false,
                  isEmailIdUpdate: !(registrationArgument.isInitial),
                  isMobileUpdate: false,
                  isReKyc: false,
                  isAddBeneficiary: false,
                  isMakeTransfer: false,
                  isMakeInvestment: false,
                  isRedeem: false,
                ).toMap(),
              );
            }
          } else {
            if (context.mounted) {
              showAdaptiveDialog(
                context: context,
                builder: (context) {
                  return CustomDialog(
                    svgAssetPath: ImageConstants.warning,
                    title: "Sorry",
                    message: sendEmailOtpResult["message"] ??
                        "There was an error in sending Email OTP, please try again later",
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
      } else {
        if (context.mounted) {
          showAdaptiveDialog(
            context: context,
            builder: (context) {
              return CustomDialog(
                svgAssetPath: ImageConstants.warning,
                title: "User already exists",
                message: "Try logging in again",
                actionWidget: GradientButton(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      Routes.loginUserId,
                      arguments:
                          StoriesArgumentModel(isBiometric: persistBiometric!)
                              .toMap(),
                    );
                  },
                  text: "Login",
                ),
              );
            },
          );
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _referralIdController.dispose();
    super.dispose();
  }
}
