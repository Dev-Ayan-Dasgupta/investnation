import 'dart:async';
import 'dart:developer';

import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:investnation/bloc/index.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/data/repository/accounts/index.dart';
import 'package:investnation/data/repository/investment/index.dart';
import 'package:investnation/data/repository/onboarding/index.dart';
import 'package:investnation/data/repository/payments/index.dart';
import 'package:investnation/main.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/screens/common/index.dart';
import 'package:investnation/presentation/screens/investmentCreation/index.dart';
import 'package:investnation/presentation/screens/redeemAndTopUp/index.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:investnation/utils/helpers/index.dart';

import '../../../../data/repository/authentication/index.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

String pwdChangeCif = "";

class _OTPScreenState extends State<OTPScreen> {
  late int seconds;
  int pinputErrorCount = 0;
  final TextEditingController _pinController = TextEditingController();

  bool isClickable = true;

  late OTPArgumentModel otpArgumentModel;

  late final String obscuredEmail;
  late final String obscuredPhone;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    blocInitialization();
    startTimer(otpArgumentModel.isEmail ? 300 : 90);
  }

  void argumentInitialization() {
    otpArgumentModel =
        OTPArgumentModel.fromMap(widget.argument as dynamic ?? {});
    if (otpArgumentModel.isEmail) {
      obscuredEmail = ObscureHelper.obscureEmail(otpArgumentModel.emailOrPhone);
    } else {
      obscuredPhone = ObscureHelper.obscurePhone(otpArgumentModel.emailOrPhone);
    }
  }

  void blocInitialization() {
    final PinputErrorBloc pinputErrorBloc = context.read<PinputErrorBloc>();
    pinputErrorBloc.add(
        PinputErrorEvent(isError: false, isComplete: false, errorCount: 0));
  }

  void startTimer(int count) {
    final PinputErrorBloc pinputErrorBloc = context.read<PinputErrorBloc>();

    seconds = count;
    final OTPTimerBloc otpTimerBloc = context.read<OTPTimerBloc>();
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (seconds > 0) {
          seconds--;
          otpTimerBloc.add(OTPTimerEvent(seconds: seconds));
        } else {
          timer.cancel();
          pinputErrorBloc.add(PinputErrorEvent(
              isError: false, isComplete: false, errorCount: 0));
        }
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: AppBarLeading(
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (PaddingConstants.horizontalPadding /
                        Dimensions.designWidth)
                    .w,
              ),
              child: Column(
                children: [
                  Expanded(
                      child: Center(
                    child: Column(children: [
                      const SizeBox(height: 30),
                      BlocBuilder<PinputErrorBloc, PinputErrorState>(
                        builder: buildIcon,
                      ),
                      const SizeBox(height: 20),
                      BlocBuilder<PinputErrorBloc, PinputErrorState>(
                        builder: buildTitle,
                      ),
                      const SizeBox(height: 15),
                      BlocBuilder<PinputErrorBloc, PinputErrorState>(
                        builder: buildDescription,
                      ),
                      const SizeBox(height: 25),
                      BlocBuilder<PinputErrorBloc, PinputErrorState>(
                        builder: buildPinput,
                      ),
                      BlocBuilder<PinputErrorBloc, PinputErrorState>(
                        builder: buildTimer,
                      ),
                    ]),
                  ))
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
      ),
    );
  }

  Widget buildIcon(BuildContext context, PinputErrorState state) {
    return SvgPicture.asset(
      otpArgumentModel.isEmail ? ImageConstants.otp : ImageConstants.aod,
      width: (78 / Dimensions.designWidth).w,
      height: (70 / Dimensions.designHeight).h,
      colorFilter: const ColorFilter.mode(
        AppColors.primary80,
        BlendMode.srcIn,
      ),
    );
  }

  Widget buildTitle(BuildContext context, PinputErrorState state) {
    return Text(
      "Enter One Time Password",
      style: TextStyles.primaryMedium.copyWith(
        color: AppColors.dark80,
        fontSize: (24 / Dimensions.designWidth).w,
      ),
    );
  }

  Widget buildDescription(BuildContext context, PinputErrorState state) {
    if (pinputErrorCount < 3) {
      if (otpArgumentModel.isEmail) {
        return Text(
          "We have sent a 6-digit verification code to the email address provided: $obscuredEmail",
          style: TextStyles.primaryMedium.copyWith(
            color: AppColors.dark80,
            fontSize: (16 / Dimensions.designWidth).w,
          ),
          textAlign: TextAlign.center,
        );
      } else {
        return Text(
          "We have sent a 6-digit verification code to: $obscuredPhone",
          style: TextStyles.primaryMedium.copyWith(
            color: AppColors.dark80,
            fontSize: (16 / Dimensions.designWidth).w,
          ),
          textAlign: TextAlign.center,
        );
      }
    } else {
      return SizedBox(
        width: 80.w,
        child: Text(
          "You have exceeded maximum number of 3 retries. Please wait for 24 hours before you can try again.",
          style: TextStyles.primaryMedium.copyWith(
            color: const Color(0xFF343434),
            fontSize: (18 / Dimensions.designWidth).w,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Widget buildPinput(BuildContext context, PinputErrorState state) {
    final PinputErrorBloc pinputErrorBloc = context.read<PinputErrorBloc>();
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    return CustomPinput(
      pinController: _pinController,
      pinColor: (!state.isError)
          ? (state.isComplete)
              ? AppColors.green30
              : const Color(0XFFEEEEEE)
          : (state.errorCount >= 3)
              ? const Color(0XFFC0D6FF)
              : AppColors.red30,
      onChanged: (p0) async {
        if (_pinController.text.length == 6) {
          if (otpArgumentModel.isEmail) {
            // ! Onboarding initial
            if (otpArgumentModel.isInitial) {
              log("Verify Email Otp Request -> ${{
                "emailId": otpArgumentModel.emailOrPhone,
                "otp": _pinController.text,
              }}");
              try {
                var verifyEmailOtpResult =
                    await MapVerifyEmailOtp.mapVerifyEmailOtp({
                  "emailId": otpArgumentModel.emailOrPhone,
                  "otp": _pinController.text,
                });
                log("verifyEmailOtpResult -> $verifyEmailOtpResult");
                if (verifyEmailOtpResult["success"]) {
                  pinputErrorBloc.add(
                    PinputErrorEvent(
                      isError: false,
                      isComplete: true,
                      errorCount: pinputErrorCount,
                    ),
                  );
                  await Future.delayed(const Duration(milliseconds: 100));
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(
                      context,
                      Routes.createPassword,
                      arguments: CreateAccountArgumentModel(
                        email: otpArgumentModel.emailOrPhone,
                        isRetail: true,
                        userTypeId: 1,
                        companyId: 0,
                      ).toMap(),
                    );
                  }
                } else {
                  pinputErrorCount++;
                  seconds = 0;
                  showButtonBloc.add(const ShowButtonEvent(show: true));
                  pinputErrorBloc.add(
                    PinputErrorEvent(
                      isError: true,
                      isComplete: true,
                      errorCount: pinputErrorCount,
                    ),
                  );
                }
              } catch (e) {
                log(e.toString());
              }
            }
            // ! Forgot Password
            else {
              log("ValidateEmailOtpForPassword request -> ${{
                "emailId": otpArgumentModel.emailOrPhone,
                "otp": _pinController.text,
              }}");
              try {
                var result = await MapValidateEmailOtpForPassword
                    .mapValidateEmailOtpForPassword(
                  {
                    "emailId": otpArgumentModel.emailOrPhone,
                    "otp": _pinController.text,
                  },
                );
                log("Validate Email OTP For Password Response -> $result");
                await storage.write(key: "token", value: result["token"]);
                if (result["success"]) {
                  pinputErrorBloc.add(
                    PinputErrorEvent(
                      isError: false,
                      isComplete: true,
                      errorCount: pinputErrorCount,
                    ),
                  );
                  try {
                    var getCustomerDetailsResponse =
                        await MapCustomerDetails.mapCustomerDetails();
                    log("Get Customer Details API response -> $getCustomerDetailsResponse");
                    int retailOnboardingState =
                        getCustomerDetailsResponse["retailOnboardingState"];
                    pwdChangeCif = getCustomerDetailsResponse["cifDetails"]
                            .isEmpty
                        ? "UNREGISTERED"
                        : getCustomerDetailsResponse["cifDetails"][0]["cif"];
                    log("pwdChangeCif -> $pwdChangeCif");
                    if (retailOnboardingState >= 1) {
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(
                          context,
                          Routes.setPassword,
                          arguments: SetPasswordArgumentModel(
                            fromTempPassword: false,
                          ).toMap(),
                        );
                      }
                    } else {
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomDialog(
                              svgAssetPath: ImageConstants.warning,
                              title: "Email Not Registered",
                              message:
                                  "You do not have an account registered with this email address. Please register an account.",
                              actionWidget: GradientButton(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    Routes.onboarding,
                                  );
                                },
                                text: "Register",
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
                  pinputErrorCount++;
                  seconds = 0;
                  showButtonBloc.add(const ShowButtonEvent(show: true));
                  pinputErrorBloc.add(
                    PinputErrorEvent(
                      isError: true,
                      isComplete: true,
                      errorCount: pinputErrorCount,
                    ),
                  );
                  if (context.mounted) {
                    showAdaptiveDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialog(
                          svgAssetPath: ImageConstants.warning,
                          title: "Sorry",
                          message: result["message"],
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
            }
          } else {
            if (otpArgumentModel.isMobileUpdate) {
              // ! Update Mobile Number
              log("Update Retail Mobile Number Request -> ${{
                "otp": _pinController.text,
                "mobileNumber": otpArgumentModel.emailOrPhone,
              }}");
              try {
                setState(() {
                  isClickable = false;
                });
                var mobileUpdateResult = await MapUpdateRetailMobileNumber
                    .mapUpdateRetailMobileNumber(
                  {
                    "otp": _pinController.text,
                    "mobileNumber": otpArgumentModel.emailOrPhone,
                  },
                );
                log("Update Mobile API response -> $mobileUpdateResult");
                if (mobileUpdateResult["success"]) {
                  mobileChangesToday++;
                  pinputErrorBloc.add(
                    PinputErrorEvent(
                      isError: false,
                      isComplete: true,
                      errorCount: pinputErrorCount,
                    ),
                  );

                  await storage.write(
                    key: "mobileNumber",
                    value: otpArgumentModel.emailOrPhone,
                  );

                  storageMobileNumber = await storage.read(key: "mobileNumber");
                  profileMobileNumber = storageMobileNumber;
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialog(
                          svgAssetPath: ImageConstants.checkCircleOutlined,
                          title: "Mobile Number Updated",
                          message: messages[52]["messageText"],
                          actionWidget: GradientButton(
                            onTap: () {
                              mobileChangesToday++;
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(
                                context,
                                Routes.profileHome,
                                arguments: DashboardArgumentModel(
                                  onboardingState: 8,
                                ).toMap(),
                              );
                            },
                            text: labels[346]["labelText"],
                          ),
                        );
                      },
                    );
                  }
                } else {
                  pinputErrorCount++;
                  seconds = 0;
                  showButtonBloc.add(const ShowButtonEvent(show: true));
                  pinputErrorBloc.add(
                    PinputErrorEvent(
                      isError: true,
                      isComplete: true,
                      errorCount: pinputErrorCount,
                    ),
                  );
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialog(
                          svgAssetPath: ImageConstants.warning,
                          title: "Unable to Update",
                          message: messages[51]["messageText"],
                          actionWidget: GradientButton(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            text: labels[346]["labelText"],
                          ),
                        );
                      },
                    );
                  }
                }

                setState(() {
                  isClickable = true;
                });
              } catch (e) {
                log(e.toString());
              }
            }
            // ! Add Beneficiary
            else if (otpArgumentModel.isAddBeneficiary) {
              log("Verify Mobile Otp Request -> ${{
                "mobile": otpArgumentModel.emailOrPhone,
                "otp": _pinController.text,
                "isRevalidate": false,
                "isOnboarding": false,
              }}");
              try {
                var verifyMobileOtpResult =
                    await MapVerifyMobileOtp.mapVerifyMobileOtp(
                  {
                    "mobileNo": otpArgumentModel.emailOrPhone,
                    "otp": _pinController.text,
                    "isRevalidate": false,
                    "isOnboarding": false,
                  },
                );
                log("verifyMobileOtpResult -> $verifyMobileOtpResult");
                if (verifyMobileOtpResult["success"]) {
                  pinputErrorBloc.add(
                    PinputErrorEvent(
                      isError: false,
                      isComplete: true,
                      errorCount: pinputErrorCount,
                    ),
                  );
                  await Future.delayed(const Duration(milliseconds: 100));
                  log("createBeneficiaryApi Req -> ${{
                    "beneficiaryType": 1,
                    "accountNumber": receiverAccountNumber,
                    "name": benCustomerName,
                    "accountType": 1,
                    "swiftReference": benSwiftCodeRef,
                    "targetCurrency": "AED",
                    "countryCode": "AE",
                    "benBankCode": benBankCode,
                    "benIdExpiryDate": benIdExpiryDate,
                    "benBankName": benBankName,
                    "benSwiftCodeText": benSwiftCode,
                  }}");
                  try {
                    var createBeneficiaryApiResult =
                        await MapCreateBeneficiary.mapCreateBeneficiary(
                      {
                        "beneficiaryType": 1,
                        "accountNumber": receiverAccountNumber,
                        "name": benCustomerName,
                        "accountType": 1,
                        "swiftReference": benSwiftCodeRef,
                        "targetCurrency": "AED",
                        "countryCode": "AE",
                        "benBankCode": benBankCode,
                        "benIdExpiryDate": benIdExpiryDate,
                        "benBankName": benBankName,
                        "benSwiftCodeText": benSwiftCode,
                      },
                    );
                    log("createBeneficiaryApiResult -> $createBeneficiaryApiResult");

                    if (createBeneficiaryApiResult["success"]) {
                      // ! Clevertap Event

                      Map<String, dynamic> createBeneficiaryEventData = {
                        'email': profilePrimaryEmailId,
                        'beneficiaryAdded': true,
                        'iban': receiverAccountNumber,
                        'deviceId': deviceId,
                      };
                      CleverTapPlugin.recordEvent(
                        "Beneficiary Created",
                        createBeneficiaryEventData,
                      );
                      if (context.mounted) {
                        showAdaptiveDialog(
                          context: context,
                          builder: (context) {
                            return CustomDialog(
                              svgAssetPath: ImageConstants.checkCircleOutlined,
                              title: "Beneficiary Added",
                              message: "Beneficiary added successfully.",
                              auxWidget: GradientButton(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                    context,
                                    Routes.transferOutDetails,
                                    arguments: TransferOutArgumentModel(
                                      recipientname: benCustomerName,
                                      iban: receiverAccountNumber,
                                    ).toMap(),
                                  );
                                },
                                text: "Transfer",
                              ),
                              actionWidget: SolidButton(
                                color: Colors.white,
                                fontColor: AppColors.dark100,
                                boxShadow: [BoxShadows.primary],
                                onTap: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    Routes.dashboard,
                                    (route) => false,
                                    arguments: DashboardArgumentModel(
                                      onboardingState: 8,
                                    ).toMap(),
                                  );
                                },
                                text: "Go Home",
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
                              message: createBeneficiaryApiResult["message"] ??
                                  "There was an error in addition the beneficiary, please try again later.",
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
                  pinputErrorCount++;
                  seconds = 0;
                  showButtonBloc.add(const ShowButtonEvent(show: true));
                  pinputErrorBloc.add(
                    PinputErrorEvent(
                      isError: true,
                      isComplete: true,
                      errorCount: pinputErrorCount,
                    ),
                  );
                }
              } catch (e) {
                log(e.toString());
              }
            }
            // ! Make Transfer
            else if (otpArgumentModel.isMakeTransfer) {
              log("Verify Mobile Otp Request -> ${{
                "mobile": otpArgumentModel.emailOrPhone,
                "otp": _pinController.text,
                "isRevalidate": false,
                "isOnboarding": false,
              }}");
              try {
                var verifyMobileOtpResult =
                    await MapVerifyMobileOtp.mapVerifyMobileOtp(
                  {
                    "mobileNo": otpArgumentModel.emailOrPhone,
                    "otp": _pinController.text,
                    "isRevalidate": false,
                    "isOnboarding": false,
                  },
                );
                log("verifyMobileOtpResult -> $verifyMobileOtpResult");
                if (verifyMobileOtpResult["success"]) {
                  pinputErrorBloc.add(
                    PinputErrorEvent(
                      isError: false,
                      isComplete: true,
                      errorCount: pinputErrorCount,
                    ),
                  );

                  setState(() {
                    isClickable = false;
                  });

                  log("makeInternalTxnApi Req -> ${{
                    "cardNumber": cardNumber,
                    "mobileNo": profileMobileNumber,
                    "cardExpiryDate": cardExpiryDate,
                    "benCustomerName": benCustomerName,
                    "benAccountNumber": receiverAccountNumber,
                    "transactionAmount": senderAmount.toString(),
                    "benBankCode": benBankCode,
                    "cif": storageCif,
                  }}");
                  try {
                    var makeInternalTxnApiResult =
                        await MapMakeInternalMoneyTransfer
                            .mapMakeInternalMoneyTransfer(
                      {
                        "cardNumber": cardNumber,
                        "mobileNo": profileMobileNumber,
                        // storageMobileNumber,
                        // benMobileNo,
                        "cardExpiryDate": cardExpiryDate,
                        "benCustomerName": benCustomerName,
                        "benAccountNumber": receiverAccountNumber,
                        "transactionAmount": senderAmount.toString(),
                        "benBankCode": benBankCode,
                        "cif": storageCif,
                      },
                    );
                    log("makeInternalTxnApiResult -> $makeInternalTxnApiResult");
                    if (makeInternalTxnApiResult["success"]) {
                      log("Succesful Transfer");
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.transactionSucess,
                          (route) => false,
                          arguments: TransactionDetailsArgumentModel(
                            date: (makeInternalTxnApiResult["data"][0]["date"])
                                .split(',')
                                .last
                                .trim(),
                            status: makeInternalTxnApiResult["data"][0]
                                ["status"],
                            referenceNumber: makeInternalTxnApiResult["data"][0]
                                ["ftReferenceNo"],
                            amount:
                                "AED ${makeInternalTxnApiResult["data"][0]["amount"]}",
                            beneficiaryName: makeInternalTxnApiResult["data"][0]
                                ["transferTo"],
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
                              message: makeInternalTxnApiResult["message"] ??
                                  "There was an error in making the transaction, please try again later.",
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

                  setState(() {
                    isClickable = true;
                  });
                } else {
                  pinputErrorCount++;
                  seconds = 0;
                  showButtonBloc.add(const ShowButtonEvent(show: true));
                  pinputErrorBloc.add(
                    PinputErrorEvent(
                      isError: true,
                      isComplete: true,
                      errorCount: pinputErrorCount,
                    ),
                  );
                }
              } catch (e) {
                log(e.toString());
              }
            }
            // ! Make Investment
            else if (otpArgumentModel.isMakeInvestment) {
              log("Verify Mobile Otp Request -> ${{
                "mobile": otpArgumentModel.emailOrPhone,
                "otp": _pinController.text,
                "isRevalidate": false,
                "isOnboarding": false,
              }}");
              try {
                var verifyMobileOtpResult =
                    await MapVerifyMobileOtp.mapVerifyMobileOtp(
                  {
                    "mobileNo": otpArgumentModel.emailOrPhone,
                    "otp": _pinController.text,
                    "isRevalidate": false,
                    "isOnboarding": false,
                  },
                );
                log("verifyMobileOtpResult -> $verifyMobileOtpResult");
                if (verifyMobileOtpResult["success"]) {
                  pinputErrorBloc.add(
                    PinputErrorEvent(
                      isError: false,
                      isComplete: true,
                      errorCount: pinputErrorCount,
                    ),
                  );

                  setState(() {
                    isClickable = false;
                  });

                  log("makeInv Req -> ${{
                    {
                      "portfolio": portfolioBeingInvested,
                      "amount": amountBeingInvested,
                      "referralBonus": referralBonusInvested,
                    }
                  }}");
                  try {
                    var makeInvResult =
                        await MapCreateInvestment.mapCreateInvestment(
                      {
                        "portfolio": portfolioBeingInvested,
                        "amount": amountBeingInvested,
                        "referralBonus": referralBonusInvested,
                      },
                    );
                    log("makeInvResult -> $makeInvResult");
                    if (makeInvResult["success"]) {
                      log("Succesful Investment");
                      // ! Clevertap Event

                      Map<String, dynamic> createInvestmentEventData = {
                        'email': profilePrimaryEmailId,
                        'investmentMade': true,
                        'portfolio': portfolioBeingInvested,
                        'amountInvested':
                            amountBeingInvested - referralBonusInvested,
                        'referralBonus': referralBonusInvested,
                        'deviceId': deviceId,
                      };
                      CleverTapPlugin.recordEvent(
                        "Investment Created",
                        createInvestmentEventData,
                      );
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.investmentSuccess,
                          (route) => false,
                          arguments: InvestmentDetailsArgumentModel(
                            date: DateFormat('dd MMMM yyyy').format(
                              DateTime.parse(
                                (makeInvResult["investedOn"]).substring(0, 10),
                              ),
                            ),
                            status: "Success",
                            referenceNumber: makeInvResult["reference"],
                            transactionType: isTopUp ? "Top Up" : "Investment",
                            portfolio: portfolioBeingInvested,
                            amount: "AED $amountBeingInvested",
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
                              message: makeInvResult["message"] ??
                                  "There was an error in making the investment, please try again later.",
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

                  setState(() {
                    isClickable = true;
                  });
                } else {
                  pinputErrorCount++;
                  seconds = 0;
                  showButtonBloc.add(const ShowButtonEvent(show: true));
                  pinputErrorBloc.add(
                    PinputErrorEvent(
                      isError: true,
                      isComplete: true,
                      errorCount: pinputErrorCount,
                    ),
                  );
                }
              } catch (e) {
                log(e.toString());
              }
            }
            // ! Redeem Investment
            else if (otpArgumentModel.isRedeem) {
              log("Verify Mobile Otp Request -> ${{
                "mobile": otpArgumentModel.emailOrPhone,
                "otp": _pinController.text,
                "isRevalidate": false,
                "isOnboarding": false,
              }}");
              try {
                var verifyMobileOtpResult =
                    await MapVerifyMobileOtp.mapVerifyMobileOtp(
                  {
                    "mobileNo": otpArgumentModel.emailOrPhone,
                    "otp": _pinController.text,
                    "isRevalidate": false,
                    "isOnboarding": false,
                  },
                );
                log("verifyMobileOtpResult -> $verifyMobileOtpResult");
                if (verifyMobileOtpResult["success"]) {
                  pinputErrorBloc.add(
                    PinputErrorEvent(
                      isError: false,
                      isComplete: true,
                      errorCount: pinputErrorCount,
                    ),
                  );

                  setState(() {
                    isClickable = false;
                  });

                  log("makeRedemtionApi Req -> ${{
                    "portfolio": portfolioBeingInvested,
                    "amount": redeemAmount - redemptionFee,
                    "redemptionAmount": redeemAmount,
                    "redemptionFee": redemptionFee,
                  }}");

                  try {
                    var makeRedemtionApiRes =
                        await MapRedeemInvestment.mapRedeemInvestment(
                      {
                        "portfolio": portfolioBeingInvested,
                        "amount": redeemAmount - redemptionFee,
                        "redemptionAmount": redeemAmount,
                        "redemptionFee": redemptionFee,
                      },
                    );

                    log("makeRedemtionApiRes -> $makeRedemtionApiRes");
                    if (makeRedemtionApiRes["success"]) {
                      log("Redemption Success");

                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.redemptionSuccess,
                          (route) => false,
                          arguments: InvestmentDetailsArgumentModel(
                            date: DateFormat('dd MMMM yyyy').format(
                              DateTime.parse(
                                (makeRedemtionApiRes["investedOn"])
                                    .substring(0, 10),
                              ),
                            ),
                            status: "Success",
                            referenceNumber: makeRedemtionApiRes["reference"],
                            transactionType: "Redemption",
                            portfolio: portfolioBeingInvested,
                            amount:
                                "AED ${NumberFormatter.numberFormat(redeemAmount - (redemptionFeePct * redeemAmount / 100))}",
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
                              message: makeRedemtionApiRes["message"] ??
                                  "There was an error in redeeming your investment, please try again later.",
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

                    setState(() {
                      isClickable = true;
                    });
                  } catch (e) {
                    log(e.toString());
                  }
                } else {
                  pinputErrorCount++;
                  seconds = 0;
                  showButtonBloc.add(const ShowButtonEvent(show: true));
                  pinputErrorBloc.add(
                    PinputErrorEvent(
                      isError: true,
                      isComplete: true,
                      errorCount: pinputErrorCount,
                    ),
                  );
                }
              } catch (e) {
                log(e.toString());
              }
            } else {
              // ! During mobile verification at the time of onboarding
              log("Verify Mobile Otp Request -> ${{
                "mobile": otpArgumentModel.emailOrPhone,
                "otp": _pinController.text,
                "isRevalidate": false,
                "isOnboarding": true,
              }}");
              try {
                var verifyMobileOtpResult =
                    await MapVerifyMobileOtp.mapVerifyMobileOtp(
                  {
                    "mobileNo": otpArgumentModel.emailOrPhone,
                    "otp": _pinController.text,
                    "isRevalidate": false,
                    "isOnboarding": true,
                  },
                );
                log("verifyMobileOtpResult -> $verifyMobileOtpResult");
                if (verifyMobileOtpResult["success"]) {
                  // ! Clevertap
                  Map<String, dynamic> verifyMobileEventData = {
                    'mobileNo': otpArgumentModel.emailOrPhone,
                    'registrationStatus': 2,
                    'deviceId': deviceId,
                  };
                  CleverTapPlugin.recordEvent(
                    "Mobile Verified",
                    verifyMobileEventData,
                  );

                  pinputErrorBloc.add(
                    PinputErrorEvent(
                      isError: false,
                      isComplete: true,
                      errorCount: pinputErrorCount,
                    ),
                  );
                  await Future.delayed(const Duration(milliseconds: 100));
                  MyGetProfileData.getProfileData();
                  if (context.mounted) {
                    showAdaptiveDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialog(
                          svgAssetPath: ImageConstants.checkCircleOutlined,
                          title: "You're One Step Closer",
                          message: "Select below to continue",
                          auxWidget: GradientButton(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                Routes.verificationInit,
                                arguments:
                                    VerificationInitializationArgumentModel(
                                  isReKyc: false,
                                ).toMap(),
                              );
                            },
                            text: "Proceed and Scan your ID",
                          ),
                          actionWidget: SolidButton(
                            color: Colors.white,
                            fontColor: AppColors.dark100,
                            boxShadow: [BoxShadows.primary],
                            onTap: () async {
                              // await GetProfileData.getProfileData();
                              if (context.mounted) {
                                Navigator.pushNamed(
                                  context,
                                  Routes.dashboard,
                                  arguments: DashboardArgumentModel(
                                    onboardingState: 2,
                                  ).toMap(),
                                );
                              }
                            },
                            text: "Skip for now",
                          ),
                        );
                      },
                    );
                  }
                } else {
                  pinputErrorCount++;
                  seconds = 0;
                  showButtonBloc.add(const ShowButtonEvent(show: true));
                  pinputErrorBloc.add(
                    PinputErrorEvent(
                      isError: true,
                      isComplete: true,
                      errorCount: pinputErrorCount,
                    ),
                  );
                }
              } catch (e) {
                log(e.toString());
              }
            }
          }
        }
      },
      enabled: pinputErrorCount < 1 && seconds > 0 ? true : false,
    );
  }

  Widget buildTimer(BuildContext context, PinputErrorState state) {
    if (pinputErrorCount < 3) {
      return Column(
        children: [
          const SizeBox(height: 30),
          BlocBuilder<ShowButtonBloc, ShowButtonState>(
            builder: (context, state) {
              return Ternary(
                condition: pinputErrorCount == 0,
                truthy: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Your verification code will expire in ",
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.dark50,
                        fontSize: (14 / Dimensions.designWidth).w,
                      ),
                    ),
                    BlocBuilder<OTPTimerBloc, OTPTimerState>(
                      builder: (context, state) {
                        if (seconds % 60 < 10) {
                          return Text(
                            "${seconds ~/ 60}:0${seconds % 60}",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.red100,
                              fontSize: (14 / Dimensions.designWidth).w,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        } else {
                          return Text(
                            "${seconds ~/ 60}:${seconds % 60}",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.red100,
                              fontSize: (14 / Dimensions.designWidth).w,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                falsy: Text(
                  "Invalid Code",
                  style: TextStyles.primaryMedium.copyWith(
                    color: AppColors.red100,
                    fontSize: (14 / Dimensions.designWidth).w,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
          const SizeBox(height: 15),
          BlocBuilder<OTPTimerBloc, OTPTimerState>(
            builder: (context, state) {
              return InkWell(
                onTap: resendOTP,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: Text(
                  "Resend Verification Code",
                  style: TextStyles.primaryBold.copyWith(
                    color: seconds == 0 || pinputErrorCount > 0
                        ? AppColors.dark100
                        : AppColors.dark50,
                    fontSize: (16 / Dimensions.designWidth).w,
                  ),
                ),
              );
            },
          ),
        ],
      );
    } else {
      return Column(
        children: [
          const SizeBox(height: 20),
          Text(
            "OTP Frozen",
            style: TextStyles.primaryMedium.copyWith(
              color: const Color(0xFF636363),
              fontSize: (14 / Dimensions.designWidth).w,
            ),
          ),
        ],
      );
    }
  }

  void resendOTP() async {
    setState(() {
      isClickable = false;
    });
    final PinputErrorBloc pinputErrorBloc = context.read<PinputErrorBloc>();
    if (seconds == 0) {
      final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
      if (seconds == 0 || pinputErrorCount > 0) {
        if (otpArgumentModel.isEmail) {
          seconds = 300;
        } else {
          seconds = 90;
        }
        startTimer(seconds);
        final OTPTimerBloc otpTimerBloc = context.read<OTPTimerBloc>();
        otpTimerBloc.add(OTPTimerEvent(seconds: seconds));
      }
      if (otpArgumentModel.isEmail) {
        try {
          var result = await MapSendEmailOtp.mapSendEmailOtp(
              {"emailID": otpArgumentModel.emailOrPhone});
          if (!(result["success"])) {
            if (context.mounted) {
              showDialog(
                context: context,
                builder: (context) {
                  return CustomDialog(
                    svgAssetPath: ImageConstants.warning,
                    title: "Retry Limit Reached",
                    message: result["message"],
                    actionWidget: GradientButton(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        // Navigator.pushReplacementNamed(
                        //   context,
                        //   Routes.onboarding,
                        // );
                      },
                      text: "Go Home",
                    ),
                  );
                },
              );
              // isLoading = false;
              // showButtonBloc.add(ShowButtonEvent(show: isLoading));
            }
          }
        } catch (e) {
          log(e.toString());
        }
      } else {
        try {
          var result = await MapSendMobileOtp.mapSendMobileOtp(
            {"mobileNo": otpArgumentModel.emailOrPhone},
          );
          if (!(result["success"])) {
            if (context.mounted) {
              showDialog(
                context: context,
                builder: (context) {
                  return CustomDialog(
                    svgAssetPath: ImageConstants.warning,
                    title: "Retry Limit Reached",
                    message: result["message"],
                    actionWidget: GradientButton(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        // Navigator.pushReplacementNamed(
                        //   context,
                        //   Routes.onboarding,
                        // );
                      },
                      text: "Go Home",
                    ),
                  );
                },
              );
              // isLoading = false;
              // showButtonBloc.add(ShowButtonEvent(show: isLoading));
            }
          }
        } catch (e) {
          log(e.toString());
        }
      }
      pinputErrorCount = 0;
      _pinController.clear();
      pinputErrorBloc.add(
        PinputErrorEvent(
          isError: false,
          isComplete: false,
          errorCount: pinputErrorCount,
        ),
      );

      showButtonBloc.add(const ShowButtonEvent(show: true));
    }
    setState(() {
      isClickable = true;
    });
  }
}
