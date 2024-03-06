// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:investnation/bloc/index.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/data/repository/onboarding/map_add_or_update_secondary_email.dart';
import 'package:investnation/main.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';

class UpdateSecondaryEmailScreen extends StatefulWidget {
  const UpdateSecondaryEmailScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<UpdateSecondaryEmailScreen> createState() =>
      _UpdateSecondaryEmailScreenState();
}

class _UpdateSecondaryEmailScreenState
    extends State<UpdateSecondaryEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailValid = false;
  bool isChecked = false;

  bool isLoading = false;

  late DashboardArgumentModel dashboardArgument;

  @override
  void initState() {
    super.initState();
    dashboardArgument =
        DashboardArgumentModel.fromMap(widget.argument as dynamic ?? {});
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
        leading: const AppBarLeading(),
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
                    "Update Secondary Email ID",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.dark100,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "Email Address",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark100,
                          fontSize: (14 / Dimensions.designWidth).w,
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

  Widget buildSubmitButton(BuildContext context, ShowButtonState state) {
    // final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();

    if (!_isEmailValid) {
      return SolidButton(onTap: () {}, text: "Proceed");
    } else {
      return BlocBuilder<ShowButtonBloc, ShowButtonState>(
        builder: (context, state) {
          return GradientButton(
            onTap: () async {
              if (!isLoading) {
                final ShowButtonBloc showButtonBloc =
                    context.read<ShowButtonBloc>();
                isLoading = true;
                showButtonBloc.add(ShowButtonEvent(show: isLoading));
                log("secEmailApi Req -> ${{"emailId": _emailController.text}}");
                try {
                  var secEmailApiRes = await MapAddOrUpdateSecondaryEmail
                      .mapAddOrUpdateSecondaryEmail(
                    {"emailId": _emailController.text},
                  );
                  log("secEmailApiRes -> $secEmailApiRes");
                  if (secEmailApiRes["success"]) {
                    await storage.write(
                        key: "secondaryEmailAddress",
                        value: _emailController.text);
                    storageSecondaryEmail =
                        await storage.read(key: "secondaryEmailAddress");
                    log("storageSecondaryEmail -> $storageSecondaryEmail");
                    if (context.mounted) {
                      showAdaptiveDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                            svgAssetPath: ImageConstants.checkCircleOutlined,
                            title: "Secondary Email Updated",
                            message:
                                "Your Secondary Email is updated successfully.",
                            actionWidget: GradientButton(
                              onTap: () {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  Routes.dashboard,
                                  (route) => false,
                                  arguments: DashboardArgumentModel(
                                    onboardingState:
                                        dashboardArgument.onboardingState,
                                  ).toMap(),
                                );
                              },
                              text: "Home",
                            ),
                          );
                        },
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
                            message: secEmailApiRes["message"] ??
                                "There was an issue adding the secondary email, please try again later.",
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

                isLoading = false;
                showButtonBloc.add(ShowButtonEvent(show: isLoading));
              }
            },
            text: "Proceed",
            auxWidget: isLoading ? const LoaderRow() : const SizeBox(),
          );
        },
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

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
