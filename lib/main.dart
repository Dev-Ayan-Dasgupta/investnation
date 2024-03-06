import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:http_proxy/http_proxy.dart';
import 'package:investnation/data/repository/configurations/map_application_configurations.dart';
import 'package:investnation/presentation/routers/app_router.dart';

import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';

import 'package:clevertap_plugin/clevertap_plugin.dart';

@pragma('vm:entry-point')
void _onKilledStateNotificationClickedHandler(Map<String, dynamic> map) async {
  log("Notification Payload received: $map");
}

// late bool showLogs;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

const storage = FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ),
);

bool forceLogout = false;
final navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
void onKilledStateNotificationClickedHandler(Map<String, dynamic> map) async {
  log("onKilledStateNotificationClickedHandler called from headless task!");
  log("Notification Payload received: ${map.toString()}");
}

double devicePixelRatio = 0.0;

FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  devicePixelRatio = WidgetsBinding.instance.window.devicePixelRatio;
  log("devicePixelRatio -> $devicePixelRatio");

  HttpProxy httpProxy = await HttpProxy.createHttpProxy();
  HttpOverrides.global = httpProxy;
  if (appFlavor == "dev") {
    await DotEnv().load(fileName: ".env.development");
  } else if (appFlavor == "sit") {
    await DotEnv().load(fileName: ".env.sit");
  } else if (appFlavor == "uat") {
    await DotEnv().load(fileName: ".env.uat");
  } else if (appFlavor == "prod") {
    await DotEnv().load(fileName: ".env.prod");
  }
  await Firebase.initializeApp();
  await getApplicationConfigurations();

  storageIsNotNewInstall = (await storage.read(key: "newInstall")) == "true";
  log("storageIsNotNewInstall -> $storageIsNotNewInstall");

  CleverTapPlugin.onKilledStateNotificationClicked(
      _onKilledStateNotificationClickedHandler);
  checkPushPermission();

  // ! Firebase Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  HttpOverrides.global = MyHttpOverrides();
  runApp(
    MyApp(
      appRouter: AppRouter(),
    ),
  );
}

void checkPushPermission() async {
  bool? isPushPermissionEnabled =
      await CleverTapPlugin.getPushNotificationPermissionStatus();
  log("isPushPermissionEnabled -> $isPushPermissionEnabled");
  if (isPushPermissionEnabled == null) return;

  if (!isPushPermissionEnabled && storageIsNotNewInstall == false) {
    var pushPrimerJSON = {
      'inAppType': 'alert',
      'titleText': 'Get Notified',
      'messageText': 'Enable Notification permission',
      'followDeviceOrientation': true,
      'positiveBtnText': 'Allow',
      'negativeBtnText': 'Cancel',
      'fallbackToSettings': true
    };
    await CleverTapPlugin.promptPushPrimer(pushPrimerJSON);
  } else {
    log("Push Permission is already enabled.");
  }
}

Future<void> getApplicationConfigurations() async {
  try {
    var result =
        await MapApplicationConfigurations.mapApplicationConfigurations();
    log("Application Config API response -> $result");

    selfieScoreMatch = result["selfieScoreMatch"];
    log("selfieScoreMatch -> $selfieScoreMatch");
    otpExpiryTime = result["otpExpiryTime"];
    log("otpExpiryTime -> $otpExpiryTime");
    appSessionTimeout = result["appSessionTimeout"];
    log("appSessionTimeout -> $appSessionTimeout");
    customerCarePhone = result["customerCarePhone"];
    log("customerCarePhone -> $customerCarePhone");
    customerCareEmail = result["customerCareEmail"];
    log("customerCareEmail -> $customerCareEmail");
    uaePassRedirectURL = result["uaePassRedirectURL"];
    log("uaePassRedirectURL -> $uaePassRedirectURL");
  } catch (e) {
    log("getApplicationConfigurations exception -> $e");
  }
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.appRouter,
  });

  final AppRouter appRouter;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late CleverTapPlugin _clevertapPlugin;

  var inboxInitialized = false;
  var optOut = false;
  var offLine = false;
  var firstMsgId = "";

  void _handleKilledStateNotificationInteraction() async {
    CleverTapAppLaunchNotification appLaunchNotification =
        await CleverTapPlugin.getAppLaunchNotification();
    log("_handleKilledStateNotificationInteraction => $appLaunchNotification");

    if (appLaunchNotification.didNotificationLaunchApp) {
      Map<String, dynamic> notificationPayload = appLaunchNotification.payload!;
      handleDeeplink(notificationPayload);
    }
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();

    activateCleverTapFlutterPluginHandlers();
    CleverTapPlugin.setDebugLevel(3);

    if (Platform.isAndroid) {
      _handleKilledStateNotificationInteraction();
    }
    CleverTapPlugin.createNotificationChannel(
      "InvestNation",
      "InvestNation",
      "Default Investnation Channel",
      3,
      true,
    );
    CleverTapPlugin.initializeInbox();
    CleverTapPlugin.registerForPush(); //only for iOS

    // Will opt in the user to send Device Network data to CleverTap
    CleverTapPlugin.enableDeviceNetworkInfoReporting(true);
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  void activateCleverTapFlutterPluginHandlers() {
    _clevertapPlugin = CleverTapPlugin();
    _clevertapPlugin
        .setCleverTapPushAmpPayloadReceivedHandler(pushAmpPayloadReceived);
    _clevertapPlugin.setCleverTapPushClickedPayloadReceivedHandler(
        pushClickedPayloadReceived);
    _clevertapPlugin.setCleverTapInAppNotificationDismissedHandler(
        inAppNotificationDismissed);
    _clevertapPlugin
        .setCleverTapInAppNotificationShowHandler(inAppNotificationShow);
    _clevertapPlugin
        .setCleverTapProfileDidInitializeHandler(profileDidInitialize);
    _clevertapPlugin.setCleverTapProfileSyncHandler(profileDidUpdate);
    _clevertapPlugin.setCleverTapInboxDidInitializeHandler(inboxDidInitialize);
    _clevertapPlugin
        .setCleverTapInboxMessagesDidUpdateHandler(inboxMessagesDidUpdate);
    _clevertapPlugin
        .setCleverTapDisplayUnitsLoadedHandler(onDisplayUnitsLoaded);
    _clevertapPlugin.setCleverTapInAppNotificationButtonClickedHandler(
        inAppNotificationButtonClicked);
    _clevertapPlugin.setCleverTapInboxNotificationButtonClickedHandler(
        inboxNotificationButtonClicked);
    _clevertapPlugin.setCleverTapInboxNotificationMessageClickedHandler(
        inboxNotificationMessageClicked);
    _clevertapPlugin.setCleverTapFeatureFlagUpdatedHandler(featureFlagsUpdated);
    _clevertapPlugin
        .setCleverTapProductConfigInitializedHandler(productConfigInitialized);
    _clevertapPlugin
        .setCleverTapProductConfigFetchedHandler(productConfigFetched);
    _clevertapPlugin
        .setCleverTapProductConfigActivatedHandler(productConfigActivated);
    _clevertapPlugin.setCleverTapPushPermissionResponseReceivedHandler(
        pushPermissionResponseReceived);
  }

  void inAppNotificationDismissed(Map<String, dynamic> map) {
    setState(() {
      log("inAppNotificationDismissed called");
      // Uncomment to print payload.
      printInAppNotificationDismissedPayload(map);
    });
  }

  void printInAppNotificationDismissedPayload(Map<String, dynamic>? map) {
    if (map != null) {
      var extras = map['extras'];
      var actionExtras = map['actionExtras'];
      log("InApp -> dismissed with extras map: ${extras.toString()}");
      log("InApp -> dismissed with actionExtras map: ${actionExtras.toString()}");
      actionExtras.forEach((key, value) {
        log("Value for key: ${key.toString()} is: ${value.toString()}");
      });
    }
  }

  void inAppNotificationShow(Map<String, dynamic> map) {
    setState(() {
      log("inAppNotificationShow called = ${map.toString()}");
    });
  }

  void inAppNotificationButtonClicked(Map<String, dynamic>? map) {
    setState(() {
      log("inAppNotificationButtonClicked called = ${map.toString()}");
      // Uncomment to print payload.
      printInAppButtonClickedPayload(map);
    });
  }

  void printInAppButtonClickedPayload(Map<String, dynamic>? map) {
    if (map != null) {
      log("InApp -> button clicked with map: ${map.toString()}");
      map.forEach((key, value) {
        log("Value for key: ${key.toString()} is: ${value.toString()}");
      });
    }
  }

  void inboxNotificationButtonClicked(Map<String, dynamic>? map) {
    setState(() {
      log("inboxNotificationButtonClicked called = ${map.toString()}");
      // Uncomment to print payload.
      printInboxMessageButtonClickedPayload(map);
    });
  }

  void printInboxMessageButtonClickedPayload(Map<String, dynamic>? map) {
    if (map != null) {
      log("App Inbox -> message button tapped with customExtras key/value:");
      map.forEach((key, value) {
        log("Value for key: ${key.toString()} is: ${value.toString()}");
      });
    }
  }

  void inboxNotificationMessageClicked(
      Map<String, dynamic>? data, int contentPageIndex, int buttonIndex) {
    setState(() {
      log("App Inbox -> inboxNotificationMessageClicked called = InboxItemClicked at page-index $contentPageIndex with button-index $buttonIndex $data");
      var inboxMessageClicked = data?["msg"];
      if (inboxMessageClicked == null) {
        return;
      }

      //The contentPageIndex corresponds to the page index of the content, which ranges from 0 to the total number of pages for carousel templates. For non-carousel templates, the value is always 0, as they only have one page of content.
      var messageContentObject =
          inboxMessageClicked["content"][contentPageIndex];

      //The buttonIndex corresponds to the CTA button clicked (0, 1, or 2). A value of -1 indicates the app inbox body/message clicked.
      if (buttonIndex != -1) {
        //button is clicked
        var buttonObject = messageContentObject["action"]["links"][buttonIndex];
        var buttonType = buttonObject?["type"];
        switch (buttonType) {
          case "copy":
            //this type copies the associated text to the clipboard
            var copiedText = buttonObject["copyText"]?["text"];
            log("App Inbox -> copied text to Clipboard: $copiedText");
            //dismissAppInbox();
            break;
          case "url":
            //this type fires the deeplink
            var firedDeepLinkUrl = buttonObject["url"]?["android"]?["text"];
            log("App Inbox -> fired deeplink url: $firedDeepLinkUrl");
            //dismissAppInbox();
            break;
          case "kv":
            //this type contains the custom key-value pairs
            var kvPair = buttonObject["kv"];
            log("App Inbox -> custom key-value pair: $kvPair");
            //dismissAppInbox();
            break;
        }
      } else {
        //Item's body is clicked
        log("App Inbox -> type/template of App Inbox item: ${inboxMessageClicked["type"]}");
        //dismissAppInbox();
      }
    });
  }

  void dismissAppInbox() {
    CleverTapPlugin.dismissInbox();
  }

  void profileDidInitialize() {
    setState(() {
      log("profileDidInitialize called");
    });
  }

  void profileDidUpdate(Map<String, dynamic>? map) {
    setState(() {
      log("profileDidUpdate called");
    });
  }

  void inboxDidInitialize() {
    setState(() {
      log("inboxDidInitialize called");
      inboxInitialized = true;
    });
  }

  void inboxMessagesDidUpdate() {
    setState(() async {
      log("inboxMessagesDidUpdate called");
      int? unread = await CleverTapPlugin.getInboxMessageUnreadCount();
      int? total = await CleverTapPlugin.getInboxMessageCount();
      log("Unread count = $unread");
      log("Total count = $total");
    });
  }

  void onDisplayUnitsLoaded(List<dynamic>? displayUnits) {
    setState(() {
      log("Display Units = $displayUnits");
      // Uncomment to print payload.
      printDisplayUnitPayload(displayUnits);
    });
  }

  void printDisplayUnitPayload(List<dynamic>? displayUnits) {
    if (displayUnits != null) {
      log("Total Display unit count = ${displayUnits.length}");
      for (var element in displayUnits) {
        printDisplayUnit(element);
      }
    }
  }

  void printDisplayUnit(Map<dynamic, dynamic> displayUnit) {
    var content = displayUnit['content'];
    content.forEach((contentElement) {
      log("Title text of display unit is ${contentElement['title']['text']}");
      log("Message text of display unit is ${contentElement['message']['text']}");
    });
    var customKV = displayUnit['custom_kv'];
    if (customKV != null) {
      log("Display units custom key-values:");
      customKV.forEach((key, value) {
        log("Value for key: ${key.toString()} is: ${value.toString()}");
      });
    }
  }

  void featureFlagsUpdated() {
    log("Feature Flags Updated");
    setState(() async {
      bool? booleanVar = await CleverTapPlugin.getFeatureFlag("BoolKey", false);
      log("Feature flag = $booleanVar");
    });
  }

  void productConfigInitialized() {
    log("Product Config Initialized");
    setState(() async {
      await CleverTapPlugin.fetch();
    });
  }

  void productConfigFetched() {
    log("Product Config Fetched");
    setState(() async {
      await CleverTapPlugin.activate();
    });
  }

  void productConfigActivated() {
    log("Product Config Activated");
    setState(() async {
      String? stringvar =
          await CleverTapPlugin.getProductConfigString("StringKey");
      log("PC String = $stringvar");
      int? intvar = await CleverTapPlugin.getProductConfigLong("IntKey");
      log("PC int = $intvar");
      double? doublevar =
          await CleverTapPlugin.getProductConfigDouble("DoubleKey");
      log("PC double = $doublevar");
    });
  }

  void pushAmpPayloadReceived(Map<String, dynamic> map) {
    log("pushAmpPayloadReceived called");
    setState(() async {
      var data = jsonEncode(map);
      log("Push Amp Payload = $data");
      CleverTapPlugin.createNotification(data);
    });
  }

  void pushClickedPayloadReceived(Map<String, dynamic> notificationPayload) {
    log("pushClickedPayloadReceived called");
    log("on Push Click Payload = $notificationPayload");
    handleDeeplink(notificationPayload);
  }

  void pushPermissionResponseReceived(bool accepted) {
    log("Push Permission response called ---> accepted = ${accepted ? "true" : "false"}");
  }

  void handleDeeplink(Map<String, dynamic> notificationPayload) {
    var type = notificationPayload["type"];
    var title = notificationPayload["nt"];
    var message = notificationPayload["nm"];

    if (type != null) {
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) =>
      //             DeepLinkPage(type: type, title: title, message: message)));
    }

    log("_handleKilledStateNotificationInteraction => Type: $type, Title: $title, Message: $message ");
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return FlutterSizer(
      builder: (context, orientation, screenType) {
        return CustomMultiBlocProvider(appRouter: widget.appRouter);
      },
    );
  }
}
