import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:investnation/bloc/showButton/index.dart';
import 'package:investnation/data/models/index.dart';
import 'package:investnation/main.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:investnation/utils/helpers/index.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../../data/repository/authentication/index.dart';

class WebViewUaePass extends StatefulWidget {
  const WebViewUaePass({super.key});

  @override
  State<WebViewUaePass> createState() => _WebViewUaePassState();
}

String userCancelled = "User cancelled the login";

class _WebViewUaePassState extends State<WebViewUaePass> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  bool _isLoading = false;
  bool webViewControllerReady = false;

  bool isSendingOtp = false;
  bool isLoggingIn = false;

  String authorizeUrl = "";

  final String _clientId = 'fhc_Investnation_mob_stage';
  final String _responseType = 'code';
  final String _scope = 'urn:uae:digitalid:profile:general';
  final String _acrValuesAppNotInstalled =
      'urn:safelayer:tws:policies:authentication:level:low';
  final String _acrValuesAppInstalled =
      'urn:digitalid:authentication:flow:mobileondevice';
  final String redirectUri = uaePassRedirectURL;
  // dotenv.env['REDIRECT_URI'] ?? "";
  String _state = const Uuid().v4();

  static const _androidPackageName = "ae.uaepass.mainapp.stg";
  static const _iOSPackageName = "uaepassstg://";

  var successUrl, failureUrl;

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true);

  @override
  void initState() {
    super.initState();
    initUaePassAuth();
    initDeepLinks();
    isAppInstalled().then((inInstalled) {
      log('isAppInstalled -> $inInstalled');

      if (inInstalled) {
        authorizeUrl =
            'https://stg-id.uaepass.ae/idshub/authorize?response_type=$_responseType&client_id=$_clientId&scope=$_scope&state=$_state&redirect_uri=$redirectUri&acr_values=$_acrValuesAppInstalled';
      } else {
        authorizeUrl =
            'https://stg-id.uaepass.ae/idshub/authorize?response_type=$_responseType&client_id=$_clientId&scope=$_scope&state=$_state&redirect_uri=$redirectUri&acr_values=$_acrValuesAppNotInstalled';
      }
      log("authorizeUrl -> $authorizeUrl");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              InAppWebView(
                key: webViewKey,
                initialSettings: settings,
                onWebViewCreated: (controller) async {
                  webViewController = controller;
                },
                onPermissionRequest: (controller, request) async {
                  return PermissionResponse(
                    resources: request.resources,
                    action: PermissionResponseAction.GRANT,
                  );
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  final url = navigationAction.request.url;
                  log("shouldOverrideUrlLoading -> ${url.toString()}");

                  if (url
                      .toString()
                      .startsWith("https://stg-ids.uaepass.ae/commonauth")) {
                    log("shouldOverrideUrlLoading -> ${url.toString()}");

                    url?.queryParameters.forEach(
                      (key, value) {
                        if (key == 'commonAuthLogout' && value == 'true') {
                          Navigator.maybePop(context);
                        }
                      },
                    );
                  } else if (url.toString().startsWith(
                        dotenv.env['UAE_PASS_CALLBACK'] ?? "",
                      )) {
                    log("shouldOverrideUrlLoading -> ${url.toString()}");
                  } else if (url
                      .toString()
                      .startsWith(dotenv.env['REDIRECT_URI'] ?? "")) {
                    log("shouldOverrideUrlLoading -> ${url.toString()}");

                    bool cancelledOnApp = false;
                    bool hasState = false;
                    bool hasError = false;

                    url?.queryParameters.forEach(
                      (key, value) {
                        if (key == 'state') {
                          _state = value;
                          log("Received state -> ${{value}}");
                          hasState = true;
                        }
                        if (key == 'error') {
                          if (value == 'cancelledOnApp') {
                            cancelledOnApp = true;
                          } else {
                            hasError = true;
                          }
                        }
                      },
                    );

                    if (cancelledOnApp) {
                      showAdaptiveDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                            svgAssetPath: ImageConstants.warning,
                            title: "Sorry",
                            message: userCancelled,
                            actionWidget: GradientButton(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              text: "Okay",
                            ),
                          );
                        },
                      );
                    } else if (hasState && !hasError) {
                      setState(() {
                        _isLoading = true;
                      });
                    }
                  } else if (url.toString().startsWith("uaepass://")) {
                    log("shouldOverrideUrlLoading -> ${url.toString()}");

                    var newurl =
                        url.toString().replaceAll('uaepass:', 'uaepassstg:');

                    url?.queryParameters.forEach((key, value) {
                      if (key == 'successurl') {
                        successUrl = value;
                      } else if (key == 'failureurl') {
                        failureUrl = value;
                      }
                    });

                    newurl = newurl.replaceAll("https%3A%2F%2Fstg-ids",
                        "dds://uaedds.com?url=https%3A%2F%2Fstg-ids");
                    launchUrlString(newurl);
                    return NavigationActionPolicy.CANCEL;
                  }

                  return NavigationActionPolicy.ALLOW;
                },
                onLoadStart: ((controller, url) async {
                  log("Starting Url -> $url");
                }),
                onLoadStop: ((controller, url) async {
                  log("Stopping Url -> $url");
                }),
                onReceivedServerTrustAuthRequest:
                    (controller, challenge) async {
                  return ServerTrustAuthResponse(
                    action: ServerTrustAuthResponseAction.PROCEED,
                  );
                },
                onPageCommitVisible: (controller, url) async {
                  log("onPageCommitVisible -> $url");

                  if (url.toString().startsWith(
                        dotenv.env['UAE_PASS_CALLBACK'] ?? "",
                      )) {
                    postValidateUAEPass(_state);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> initUaePassAuth() async {
    log("initUaePassAuthReq -> ${{"state": _state}}");
    var initUaePassAuthRes =
        await MapInitiateUaePassAuth.mapInitiateUaePassAuth({"state": _state});
    log("initUaePassAuthRes -> $initUaePassAuthRes");

    webViewController!
        .loadUrl(urlRequest: URLRequest(url: WebUri(authorizeUrl)));
  }

  Future<bool> isAppInstalled() async {
    var isAppInstalledResult = await LaunchApp.isAppInstalled(
        iosUrlScheme: _iOSPackageName, androidPackageName: _androidPackageName);
    return isAppInstalledResult;
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    // Check initial link if app was in cold state (terminated)
    final appLink = await _appLinks.getInitialAppLink();
    if (appLink != null) {
      log('getInitialAppLink -> $appLink');
      //openAppLink(appLink);
    }

    // Handle link when app is in warm state (front or background)
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      //openAppLink(uri);
      var url = uri.toString();
      url = url.replaceAll("dds://uaedds.com?url=", "");
      log('onAppLink -> $url');
      webViewController!.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
    });
  }

  Future<void> postValidateUAEPass(String state) async {
    if (!mounted) return;
    // todo: call uaepasslogin
    uaePassLogin(state);
  }

  Future<void> uaePassLogin(String state) async {
    log("uaePassLoginReq -> ${{
      "state": state,
      "fcmToken": "string",
    }}");
    var result = await MapUaePassLogin.mapUaePassLogin({
      "state": state,
      "fcmToken": "string",
    });
    log("uaePassLoginRes -> $result");
    if (result["success"]) {
      isUserLoggedIn = true;
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
          await MyGetProfileData.getProfileData();
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
            closeWebViewWithLogout();
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
              // log("onSubmit request -> ${{
              //   "emailId": "abc@example.com",
              //   "userTypeId": storageUserTypeId,
              //   "userId": storageUserId,
              //   "companyId": storageCompanyId,
              //   "password": "Test@123",
              //   "deviceId": storageDeviceId,
              //   "registerDevice": false,
              //   "deviceName": deviceName,
              //   "deviceType": deviceType,
              //   "appVersion": appVersion,
              //   "fcmToken": fcmToken,
              // }}");

              // try {
              //   var result = await MapLogin.mapLogin({
              //     "emailId": "abc@example.com",
              //     "userTypeId": storageUserTypeId,
              //     "userId": storageUserId,
              //     "companyId": storageCompanyId,
              //     "password": "Test@123",
              //     "deviceId": storageDeviceId,
              //     "registerDevice": false,
              //     "deviceName": deviceName,
              //     "deviceType": deviceType,
              //     "appVersion": appVersion,
              //     "fcmToken": fcmToken,
              //   });
              //   log("Login API Response -> $result");

              //   await storage.write(key: "token", value: result["token"]);
              //   if (result["success"]) {
              //     await storage.write(
              //         key: "loggedOut", value: false.toString());
              //     storageLoggedOut =
              //         await storage.read(key: "loggedOut") == "true";
              //     passwordChangesToday = result["passwordChangesToday"];
              //     emailChangesToday = result["emailChangesToday"];
              //     mobileChangesToday = result["mobileChangesToday"];
              //     log("mobileChangesToday -> $mobileChangesToday");
              //     await storage.write(
              //         key: "newInstall", value: true.toString());
              //     storageIsNotNewInstall =
              //         (await storage.read(key: "newInstall")) == "true";
              //     customerName = result["customerName"];
              //     await storage.write(key: "customerName", value: customerName);
              //     storageCustomerName = await storage.read(key: "customerName");
              //     if (context.mounted) {
              //       await storage.write(
              //           key: "retailLoggedIn", value: true.toString());
              //       storageRetailLoggedIn =
              //           await storage.read(key: "retailLoggedIn") == "true";
              //       if (context.mounted) {
              //         await GetProfileData.getProfileData();
              //         await storage.write(
              //             key: "loggedOut", value: false.toString());
              //         storageLoggedOut =
              //             await storage.read(key: "loggedOut") == "true";
              //         if (context.mounted) {
              //           Navigator.pushNamedAndRemoveUntil(
              //             context,
              //             Routes.dashboard,
              //             (route) => false,
              //             arguments: DashboardArgumentModel(
              //               onboardingState: result["onboardingState"],
              //             ).toMap(),
              //           );
              //         }
              //       }
              //     }

              //     await storage.write(
              //         key: "isFirstLogin", value: true.toString());
              //     storageIsFirstLogin =
              //         (await storage.read(key: "isFirstLogin")) == "true";
              //   } else {
              //     log("Reason Code -> ${result["reasonCode"]}");
              //     if (context.mounted) {
              //       switch (result["reasonCode"]) {
              //         case 0:
              //           navigateBack(result["message"]);
              //           break;
              //         case 1:
              //           // promptWrongCredentials();
              //           break;
              //         case 2:
              //           promptWrongCredentials();
              //           break;
              //         case 3:
              //           promptWrongCredentials();
              //           break;
              //         case 4:
              //           promptWrongCredentials();
              //           break;
              //         case 5:
              //           promptWrongCredentials();
              //           break;
              //         case 6:
              //           promptKycExpired();
              //           break;
              //         case 7:
              //           promptVerifySession();
              //           break;
              //         case 9:
              //           promptMaxRetries();
              //           break;
              //         default:
              //       }
              //     }
              //   }
              // } catch (e) {
              //   if (context.mounted) {
              //     ApiException.apiException(context);
              //   }
              // }

              break;
            case 9:
              promptMaxRetries(result["reason"] ??
                  "You have exceeded maximum number of 3 retries. Please wait for 24 hours before you can try again.");
              break;
            case 12:
              promptDormantAccount(result["reason"] ?? "");
              break;
            case 19:
              promptUaePassLoginError();
              break;
            default:
          }
        }
      }
    } else {
      if (context.mounted) {
        promptUaePassLoginError();
      }
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

  void promptUaePassLoginError() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "No UAE Pass Account",
          message:
              "You do not have any account with this email in Investnation and/or UAE Pass. Please login with an existing account.",
          actionWidget: GradientButton(
              onTap: () {
                Navigator.pop(context);
                closeWebViewWithLogout();
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

  Future<void> closeWebViewWithLogout() async {
    var logoutUrl =
        'https://stg-id.uaepass.ae/idshub/logout?redirect_uri=$redirectUri';
    log('closeWebViewWithLogout -> $logoutUrl');
    webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(logoutUrl)));

    // loadRequest(Uri.parse(logoutUrl));
  }

  void promptDormantAccount(String message) {
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
    super.dispose();
  }
}
