import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investnation/bloc/index.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/data/repository/authentication/index.dart';
import 'package:investnation/main.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/screens/common/index.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';

import 'package:webview_flutter/webview_flutter.dart';

class UaePassScreen extends StatefulWidget {
  const UaePassScreen({super.key});

  @override
  State<UaePassScreen> createState() => _UaePassScreenState();
}

class _UaePassScreenState extends State<UaePassScreen> {
  late WebViewController webViewController;

  bool isSendingOtp = false;
  bool isLoggingIn = false;

  // final String _clientId = 'fhc_Investnation_mob_stage';
  // final String _responseType = 'code';
  // final String _scope = 'urn:uae:digitalid:profile:general';
  // final String _acrValuesAppNotInstalled =
  //     'urn:safelayer:tws:policies:authentication:level:low';
  // final String _acrValuesAppInstalled =
  //     'urn:digitalid:authentication:flow:mobileondevice';
  // final String _redirectUri =
  //     'https://uat-azfhcapitalplatform.fh.ae/uaepass/oauth';
  // final String _state = const Uuid().v4();

  @override
  void initState() {
    super.initState();
    initializeWebView();
  }

  Future<void> initializeWebView() async {
    webViewController = WebViewController();
    webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    webViewController.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (progress) {},
        onNavigationRequest: (request) async {
          String? currentUrl = request.url;
          log("Current Url -> $currentUrl");

          if (currentUrl.contains("code=")) {
            String code =
                (currentUrl.split("&state").first).split("code=").last;
            log("code -> $code");
            // currentUrl.split("code=").last;
            onSubmit(storageEmail ?? "", code);
          }

          return NavigationDecision.navigate;
        },
      ),
    );
    webViewController.loadRequest(
      Uri.parse(
        // "https://stg-id.uaepass.ae/idshub/authorize?response_type=$_responseType&client_id=$_clientId&scope=$_scope&state=$_state&redirect_uri=$_redirectUri&acr_values=$_acrValuesAppInstalled",
        "https://stg-ids.uaepass.ae/oauth2/authorize?scope=urn%3Auae%3Adigitalid%3Aprofile%3Ageneral&acr_values=urn%3Asafelayer%3Atws%3Apolicies%3Aauthentication%3Alevel%3Alow&response_type=code&state=8bd28ff0-c22e-11ed-a0bc-279963ffcf94&redirect_uri=https%3A%2F%2Fuat-azfhcapitalplatform.fh.ae%2Fuaepass%2Foauth&client_id=fhc_Investnation_mob_stage",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: WebViewWidget(controller: webViewController),
    );
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

  void onSubmit(String password, String passCode) async {
    log("onSubmit request -> ${{
      "emailId": "abc@example.com",
      // storageEmail,
      "userTypeId": storageUserTypeId,
      "userId": storageUserId,
      "companyId": storageCompanyId,
      "password": "Test@123",
      "deviceId": storageDeviceId,
      "registerDevice": false,
      "deviceName": deviceName,
      "deviceType": deviceType,
      "appVersion": appVersion,
      "fcmToken": fcmToken,
      "isUAEPass": true,
      "uaePassCode": passCode,
    }}");
    try {
      var result = await MapLogin.mapLogin({
        "emailId": "abc@example.com",
        // storageEmail,
        "userTypeId": storageUserTypeId,
        "userId": storageUserId,
        "companyId": storageCompanyId,
        "password": "Test@123",
        "deviceId": storageDeviceId,
        "registerDevice": false,
        "deviceName": deviceName,
        "deviceType": deviceType,
        "appVersion": appVersion,
        "fcmToken": fcmToken,
        "isUAEPass": true,
        "uaePassCode": passCode,
      });
      log("Login API Response -> $result");

      await storage.write(key: "token", value: result["token"]);

      if (result["success"]) {
        await storage.write(key: "loggedOut", value: false.toString());
        storageLoggedOut = await storage.read(key: "loggedOut") == "true";
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
        log("Reason Code -> ${result["reasonCode"]}");
        if (context.mounted) {
          switch (result["reasonCode"]) {
            case 0:
              navigateBack(result["message"]);
              break;
            case 1:
              // promptWrongCredentials();
              break;
            case 2:
              promptWrongCredentials();
              break;
            case 3:
              promptWrongCredentials();
              break;
            case 4:
              promptWrongCredentials();
              break;
            case 5:
              promptWrongCredentials();
              break;
            case 6:
              promptKycExpired();
              break;
            case 7:
              // promptVerifySession();
              log("onSubmit request -> ${{
                "emailId": "abc@example.com",
                "userTypeId": storageUserTypeId,
                "userId": storageUserId,
                "companyId": storageCompanyId,
                "password": "Test@123",
                "deviceId": storageDeviceId,
                "registerDevice": false,
                "deviceName": deviceName,
                "deviceType": deviceType,
                "appVersion": appVersion,
                "fcmToken": fcmToken,
                "isUAEPass": true,
                "uaePassCode": passCode,
              }}");

              try {
                var result = await MapLogin.mapLogin({
                  "emailId": "abc@example.com",
                  "userTypeId": storageUserTypeId,
                  "userId": storageUserId,
                  "companyId": storageCompanyId,
                  "password": "Test@123",
                  "deviceId": storageDeviceId,
                  "registerDevice": false,
                  "deviceName": deviceName,
                  "deviceType": deviceType,
                  "appVersion": appVersion,
                  "fcmToken": fcmToken,
                  "isUAEPass": true,
                  "uaePassCode": passCode,
                });
                log("Login API Response -> $result");

                await storage.write(key: "token", value: result["token"]);
                if (result["success"]) {
                  await storage.write(
                      key: "loggedOut", value: false.toString());
                  storageLoggedOut =
                      await storage.read(key: "loggedOut") == "true";
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
                  await storage.write(key: "customerName", value: customerName);
                  storageCustomerName = await storage.read(key: "customerName");
                  if (context.mounted) {
                    await storage.write(
                        key: "retailLoggedIn", value: true.toString());
                    storageRetailLoggedIn =
                        await storage.read(key: "retailLoggedIn") == "true";
                    if (context.mounted) {
                      await getProfileData();
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
                  log("Reason Code -> ${result["reasonCode"]}");
                  if (context.mounted) {
                    switch (result["reasonCode"]) {
                      case 0:
                        navigateBack(result["message"]);
                        break;
                      case 1:
                        // promptWrongCredentials();
                        break;
                      case 2:
                        promptWrongCredentials();
                        break;
                      case 3:
                        promptWrongCredentials();
                        break;
                      case 4:
                        promptWrongCredentials();
                        break;
                      case 5:
                        promptWrongCredentials();
                        break;
                      case 6:
                        promptKycExpired();
                        break;
                      case 7:
                        promptVerifySession();
                        break;
                      case 9:
                        promptMaxRetries();
                        break;
                      default:
                    }
                  }
                }
              } catch (e) {
                log(e.toString());
              }

              break;
            case 9:
              promptMaxRetries();
              break;
            default:
          }
        }
      }
    } catch (e) {
      log(e.toString());
    }

    setState(() {
      isLoggingIn = false;
    });
  }

  void navigateBack(String? error) {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Error",
          message:
              error ?? "There was an error loggin in, please try again later",
          actionWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            text: "Okay",
          ),
        );
      },
    );
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
                arguments: StoriesArgumentModel(isBiometric: persistBiometric!)
                    .toMap(),
              );
            },
            text: labels[88]["labelText"],
          ),
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

                  log("onSubmit second request -> ${{
                    "emailId": "abc@example.com",
                    // storageEmail,
                    "userTypeId": storageUserTypeId,
                    "userId": storageUserId,
                    "companyId": storageCompanyId,
                    "password": "Test@123",
                    // password,
                    // EncryptDecrypt.encrypt(password),
                    "deviceId": storageDeviceId,
                    "registerDevice": false,
                    "deviceName": deviceName,
                    "deviceType": deviceType,
                    "appVersion": appVersion,
                    "fcmToken": fcmToken,
                    "isUAEPass": true,
                    // "uaePassCode": passCode,
                  }}");
                  try {
                    var result = await MapLogin.mapLogin({
                      "emailId": "abc@example.com",

                      "userTypeId": storageUserTypeId,
                      "userId": storageUserId,
                      "companyId": storageCompanyId,
                      "password": "Test@123",

                      "deviceId": storageDeviceId,
                      "registerDevice": false,
                      "deviceName": deviceName,
                      "deviceType": deviceType,
                      "appVersion": appVersion,
                      "fcmToken": fcmToken,
                      "isUAEPass": true,
                      // "uaePassCode": passCode,
                    });
                    log("Login API Response -> $result");

                    await storage.write(key: "token", value: result["token"]);
                    if (result["success"]) {
                      await storage.write(
                          key: "loggedOut", value: false.toString());
                      storageLoggedOut =
                          await storage.read(key: "loggedOut") == "true";
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
                      log("Reason Code -> ${result["reasonCode"]}");
                      if (context.mounted) {
                        switch (result["reasonCode"]) {
                          case 0:
                            navigateBack(result["message"]);
                            break;
                          case 1:
                            // promptWrongCredentials();
                            break;
                          case 2:
                            promptWrongCredentials();
                            break;
                          case 3:
                            promptWrongCredentials();
                            break;
                          case 4:
                            promptWrongCredentials();
                            break;
                          case 5:
                            promptWrongCredentials();
                            break;
                          case 6:
                            promptKycExpired();
                            break;
                          case 7:
                            promptVerifySession();
                            break;
                          case 9:
                            promptMaxRetries();
                            break;
                          default:
                        }
                      }
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

  void promptMaxRetries() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Retry Limit Reached",
          message:
              "You have exceeded maximum number of 3 retries. Please wait for 24 hours before you can try again.",
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
}
