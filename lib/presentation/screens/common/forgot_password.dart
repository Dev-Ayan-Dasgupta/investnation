import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:investnation/bloc/index.dart';
import 'package:investnation/data/models/index.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/screens/common/index.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';

import '../../../data/repository/onboarding/index.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailValid = false;

  bool isLoading = false;

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
                    "Enter Email Address",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.dark100,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    "We will send the OTP to your registered email address",
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
                    // Navigator.pushNamed(
                    //   context,
                    //   Routes.loginUserId,
                    //   arguments:
                    //       StoriesArgumentModel(isBiometric: persistBiometric!)
                    //           .toMap(),
                    // );
                    Navigator.pop(context);
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

  void emailValidation(String p0) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    _isEmailValid = EmailValidator.validate(p0);

    // if (EmailValidator.validate(p0)) {
    //   if (double.tryParse(p0.split('@').first) != null) {
    //     _isEmailValid = false;
    //   } else {
    //     _isEmailValid = true;
    //   }
    //   showButtonBloc.add(ShowButtonEvent(show: _isEmailValid));
    // } else {
    //   _isEmailValid = false;
    //   showButtonBloc.add(ShowButtonEvent(show: _isEmailValid));
    // }
    showButtonBloc.add(ShowButtonEvent(show: _isEmailValid || p0.length <= 5));
    log(_emailController.text.split('@').last);
    log("contains non spcl -> ${(RegExp("[A-Za-z0-9.-]").hasMatch(_emailController.text.split('@').last))}");
    log("does not contain spcl -> ${!(_emailController.text.split('@').last.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')))}");
    log("@ is last -> ${_emailController.text.split('@').last.isEmpty}");
  }

  Widget buildErrorMessage(BuildContext context, ShowButtonState state) {
    if ((_emailController.text.contains('@') &&
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
      // return BlocBuilder<ShowButtonBloc, ShowButtonState>(
      //   builder: (context, state) {
      //     return GradientButton(
      //       onTap: onForgotEmailPwd,
      //       text: "Proceed",
      //       auxWidget: isLoading ? const LoaderRow() : const SizeBox(),
      //     );
      //   },
      // );
      return GradientButton(
        onTap: onForgotEmailPwd,
        text: "Proceed",
        auxWidget: isLoading ? const LoaderRow() : const SizeBox(),
      );
    }
  }

  void onForgotEmailPwd() async {
    log("onForgotEmailPwd executing");

    fgtPwdEmail = _emailController.text;

    if (!isLoading && _isEmailValid) {
      setState(() {
        isLoading = true;
      });
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

        setState(() {
          isLoading = false;
        });
      } catch (e) {
        log(e.toString());
      }
    }
  }
}
