import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/data/models/widgets/index.dart';
import 'package:investnation/data/repository/accounts/map_app_banner.dart';
import 'package:investnation/data/repository/authentication/index.dart';
import 'package:investnation/data/repository/configurations/index.dart';
import 'package:investnation/data/repository/investment/index.dart';
import 'package:investnation/data/repository/referral/index.dart';
import 'package:investnation/main.dart';

import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:investnation/utils/constants/legal.dart';
import 'package:investnation/utils/helpers/index.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:platform_device_id/platform_device_id.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

String fcmToken = "";

List banners = [];

String? deviceId;
String deviceName = "";
String deviceType = "";
String appVersion = "";
String buildNumber = "";

List availableBiometrics = [];

List faqs = [];

List portfolios = [];

int uaeIndex = 0;
int emptyCountries = 0;

double refVal = 0;

class _SplashScreenState extends State<SplashScreen> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getBiometricCapability();
      await getDeviceId();
      await getPackageInfo();
      // await getTransferCapabilities();
      await initPlatformState();
      await initConfigurations();
      await initLocalStorageData();
      await getAvailableBiometrics();
      await getBanner();
      addNewDevice();
      // await initFirebaseNotifications();
      if (context.mounted) {
        navigate(context);
      }
    });
  }

  Future<void> getBanner() async {
    log("appBannerApi Req -> ${{"screenName": "home"}}");
    try {
      var appBannerApiRes = await MapAppBanner.mapAppBanner(
        {"screenName": "home"},
      );
      log("appBannerApiRes -> $appBannerApiRes");
      if (appBannerApiRes["success"]) {
        banners = appBannerApiRes["data"];
        log("banners length -> ${banners.length}");
      } else {}
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getDeviceId() async {
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }

    if (!mounted) return;
  }

  Future<void> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (kIsWeb) {
        deviceData = DeviceInfoHelper.readWebBrowserInfo(
            await deviceInfoPlugin.webBrowserInfo);
      } else {
        if (Platform.isAndroid) {
          deviceData = DeviceInfoHelper.readAndroidBuildData(
              await deviceInfoPlugin.androidInfo);
        } else if (Platform.isIOS) {
          deviceData = DeviceInfoHelper.readIosDeviceInfo(
              await deviceInfoPlugin.iosInfo);
        }
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    _deviceData = deviceData;

    if (Platform.isAndroid) {
      deviceType = "Android";
    } else if (Platform.isIOS) {
      deviceType = "iOS";
      deviceName = _deviceData['name'];
    }

    await storage.write(key: "deviceId", value: deviceId);
    storageDeviceId = await storage.read(key: "deviceId");

    log("deviceId -> $deviceId");
    log("deviceName -> $deviceName");
    log("deviceType -> $deviceType");
    log("appVersion -> $appVersion");
    log("buildNumber -> $buildNumber");
  }

  Future<void> initLocalStorageData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('first_run') ?? true) {
      await storage.delete(key: "newInstall");
      await storage.delete(key: "hasFirstLoggedIn");
      await storage.delete(key: "isFirstLogin");
      await storage.delete(key: "userId");
      await storage.delete(key: "password");
      await storage.delete(key: "emailAddress");
      await storage.delete(key: "userTypeId");
      await storage.delete(key: "companyId");
      await storage.delete(key: "persistBiometric");
      await storage.delete(key: "stepsCompleted");
      await storage.delete(key: "isEid");
      await storage.delete(key: "fullName");
      await storage.delete(key: "eiDNumber");
      await storage.delete(key: "passportNumber");
      await storage.delete(key: "nationality");
      await storage.delete(key: "nationalityCode");
      await storage.delete(key: "issuingStateCode");
      await storage.delete(key: "expiryDate");
      await storage.delete(key: "dob");
      await storage.delete(key: "gender");
      await storage.delete(key: "photo");
      await storage.delete(key: "docPhoto");
      await storage.delete(key: "selfiePhoto");
      await storage.delete(key: "photoMatchScore");
      await storage.delete(key: "addressCountry");
      await storage.delete(key: "addressLine1");
      await storage.delete(key: "addressLine2");
      await storage.delete(key: "addressCity");
      await storage.delete(key: "addressState");
      await storage.delete(key: "addressEmirate");
      await storage.delete(key: "poBox");
      await storage.delete(key: "incomeSource");
      await storage.delete(key: "isUSFatca");
      await storage.delete(key: "taxCountry");
      await storage.delete(key: "isTinYes");
      await storage.delete(key: "crsTin");
      await storage.delete(key: "noTinReason");
      await storage.delete(key: "accountType");
      await storage.delete(key: "cif");
      await storage.delete(key: "isCompany");
      await storage.delete(key: "isCompanyRegistered");
      await storage.delete(key: "retailLoggedIn");
      await storage.delete(key: "customerName");
      await storage.delete(key: "chosenAccount");
      await storage.delete(key: "loggedOut");
      await storage.delete(key: "chosenAccountForCreateFD");
      await storage.delete(key: "chosenprofilePhotoBase64Account");
      await storage.delete(key: "hasSingleCif");
      prefs.setBool('first_run', false);
    }

    try {
      await storage.write(key: "newInstall", value: true.toString());

      storageDeviceId = await storage.read(key: "deviceId");
      log("storageDeviceId -> $storageDeviceId");

      storageHasFirstLoggedIn =
          (await storage.read(key: "hasFirstLoggedIn")) == "true";
      log("storageHasFirstLoggedIn -> $storageHasFirstLoggedIn");
      storageIsFirstLogin = (await storage.read(key: "isFirstLogin")) == "true";
      log("storageIsFirstLogin -> $storageIsFirstLogin");

      storageHasSingleCif = (await storage.read(key: "hasSingleCif")) == "true";
      log("storageHasSingleCif -> $storageHasSingleCif");

      storageEmail = await storage.read(key: "emailAddress");
      log("storageEmail -> $storageEmail");
      storageSecondaryEmail = await storage.read(key: "secondaryEmailAddress");
      log("secondaryEmailAddress -> $storageSecondaryEmail");
      storageMobileNumber = await storage.read(key: "mobileNumber");
      log("storageMobileNumber -> $storageMobileNumber");
      storagePassword = await storage.read(key: "password");
      log("storagePassword -> $storagePassword");
      storageUserId = int.parse(await storage.read(key: "userId") ?? "0");
      log("storageUserId -> $storageUserId");
      storageUserTypeId =
          int.parse(await storage.read(key: "userTypeId") ?? "1");
      log("storageUserTypeId -> $storageUserTypeId");
      storageCompanyId = int.parse(await storage.read(key: "companyId") ?? "0");
      log("storageCompanyId -> $storageCompanyId");

      persistBiometric = await storage.read(key: "persistBiometric") == "true";
      log("persistBiometric -> $persistBiometric");

      storageStepsCompleted =
          int.parse(await storage.read(key: "stepsCompleted") ?? "0");
      log("storageStepsCompleted -> $storageStepsCompleted");

      storageIsEid = (await storage.read(key: "isEid") ?? "") == "true";
      log("storageIsEid -> $storageIsEid");
      storageFullName = await storage.read(key: "fullName");
      log("storageFullName -> $storageFullName");
      storageEidNumber = await storage.read(key: "eiDNumber");
      log("storageEidNumber -> $storageEidNumber");
      storagePassportNumber = await storage.read(key: "passportNumber");
      log("storagePassportNumber -> $storagePassportNumber");
      storageNationality = await storage.read(key: "nationality");
      log("storageNationality -> $storageNationality");
      storageNationalityCode = await storage.read(key: "nationalityCode");
      log("storageNationalityCode -> $storageNationalityCode");
      storageIssuingStateCode = await storage.read(key: "issuingStateCode");
      log("storageIssuingStateCode -> $storageIssuingStateCode");
      storageExpiryDate = await storage.read(key: "expiryDate");
      log("storageExpiryDate -> $storageExpiryDate");
      storageDob = await storage.read(key: "dob");
      log("storageDob -> $storageDob");
      storageGender = await storage.read(key: "gender");
      log("storageGender -> $storageGender");
      storagePhoto = await storage.read(key: "photo");
      log("storagePhoto -> $storagePhoto");
      storageDocPhoto = await storage.read(key: "docPhoto");
      log("storageDocPhoto -> $storageDocPhoto");
      storageSelfiePhoto = await storage.read(key: "selfiePhoto");
      log("storageSelfiePhoto -> $storageSelfiePhoto");
      storagePhotoMatchScore =
          double.parse(await storage.read(key: "photoMatchScore") ?? "0");
      log("storagePhotoMatchScore -> $storagePhotoMatchScore");

      storageAddressCountry = await storage.read(key: "addressCountry");
      log("storageAddressCountry -> $storageAddressCountry");
      storageAddressLine1 = await storage.read(key: "addressLine1");
      log("storageAddressLine1 -> $storageAddressLine1");
      storageAddressLine2 = await storage.read(key: "addressLine2");
      log("storageAddressLine2 -> $storageAddressLine2");
      storageAddressCity = await storage.read(key: "addressCity");
      log("storageAddressCity -> $storageAddressCity");
      storageAddressState = await storage.read(key: "addressState");
      log("storageAddressState -> $storageAddressState");
      storageAddressEmirate = await storage.read(key: "addressEmirate");
      log("storageAddressEmirate -> $storageAddressEmirate");
      storageAddressPoBox = await storage.read(key: "poBox");
      log("storageAddressPoBox -> $storageAddressPoBox");

      storageIncomeSource = await storage.read(key: "incomeSource");
      log("storageIncomeSource -> $storageIncomeSource");

      storageIsUSFATCA = await storage.read(key: "isUSFatca") == "true";
      log("storageIsUSFATCA -> $storageIsUSFATCA");
      storageUsTin = await storage.read(key: "usTin");
      log("storageUsTin -> $storageUsTin");

      storageTaxCountry = await storage.read(key: "taxCountry");
      log("storageTaxCountry -> $storageTaxCountry");
      storageIsTinYes = await storage.read(key: "isTinYes") == "true";
      log("storageIsTinYes -> $storageIsTinYes");
      storageCrsTin = await storage.read(key: "crsTin");
      log("storageCrsTin -> $storageCrsTin");
      storageNoTinReason = await storage.read(key: "noTinReason");
      log("storageNoTinReason -> $storageNoTinReason");

      storageAccountType =
          int.parse(await storage.read(key: "accountType") ?? "1");
      log("storageAccountType -> $storageAccountType");

      storageRiskProfile = await storage.read(key: "riskProfile") ?? "";
      log("storageRiskProfile -> $storageRiskProfile");

      storageCif = await storage.read(key: "cif");
      log("storageCif -> $storageCif");
      storageIsCompany = await storage.read(key: "isCompany") == "true";
      log("storageIsCompany -> $storageIsCompany");
      storageisCompanyRegistered =
          await storage.read(key: "isCompanyRegistered") == "true";
      log("storageisCompanyRegistered -> $storageisCompanyRegistered");

      storageRetailLoggedIn =
          await storage.read(key: "retailLoggedIn") == "true";
      log("storageRetailLoggedIn -> $storageRetailLoggedIn");

      storageCustomerName = await storage.read(key: "customerName");
      log("storageCustomerName -> $storageCustomerName");

      storageChosenAccount =
          int.parse(await storage.read(key: "chosenAccount") ?? "0");
      log("storageChosenAccount -> $storageChosenAccount");
      storageChosenAccountForCreateFD = int.parse(
        await storage.read(key: "chosenAccountForCreateFD") ?? "0",
      );

      storageProfilePhotoBase64 = await storage.read(key: "profilePhotoBase64");
      log("storageProfilePhotoBase64 -> $storageProfilePhotoBase64");

      storageLoggedOut = await storage.read(key: "loggedOut") == "true";
      log("storageLoggedOut -> $storageLoggedOut");
    } catch (_) {
      rethrow;
    }
  }

  Future<void> getAvailableBiometrics() async {
    availableBiometrics = await LocalAuthentication().getAvailableBiometrics();
  }

  void addNewDevice() {
    if (storageIsNotNewInstall == false) {
      try {
        MapAddNewDevice.mapAddNewDevice({
          "deviceId": deviceId,
          "deviceName": deviceName,
          "deviceType": deviceType,
          "appVersion": appVersion,
        });
      } catch (e) {
        log(e.toString());
      }
    }
  }

  Future<void> getBiometricCapability() async {
    isBioCapable = await LocalAuthentication().canCheckBiometrics;
    log("isBioCapable -> $isBioCapable");
  }

  Future<void> initConfigurations() async {
    log("Init conf started");
    // getApplicationConfigurations();

    try {
      labels = await MapAppLabels.mapAppLabels({"languageCode": "en"});
    } catch (e) {
      log(e.toString());
    }
    try {
      messages = await MapAppMessages.mapAppMessages({"languageCode": "en"});
    } catch (e) {
      log(e.toString());
    }
    try {
      dhabiCountries = await MapAllCountries.mapAllCountries();
    } catch (e) {
      log(e.toString());
    }
    try {
      dhabiCities = await MapAllCities.mapAllCities();
    } catch (e) {
      log(e.toString());
    }
    try {
      banks = await MapBankDetails.mapBankDetails();
    } catch (e) {
      log(e.toString());
    }

    getReferralConfig();
    getDhabiCountriesFlagsAndCodes();
    getDhabiCountryNames();
    getDhabiCityNames();
    calculateUaeIndex();
    getAvailablePortfolios();
    try {
      allDDs = await MapDropdownLists.mapDropdownLists({"languageCode": "en"});
    } catch (e) {
      log(e.toString());
    }

    populateDD(serviceRequestDDs, 0);
    populateDD(statementFileDDs, 1);
    populateDD(moneyTransferReasonDDs, 2);
    populateDD(typeOfAccountDDs, 3);
    populateDD(bearerDetailDDs, 4);
    populateDD(sourceOfIncomeDDs, 5);
    populateDD(noTinReasonDDs, 6);
    populateDD(statementDurationDDs, 7);
    populateDD(payoutDurationDDs, 8);
    populateDD(reasonOfSending, 9);
    populateDD(loanServiceRequest, 10);
    // populateEmirates();
    getPolicies();
    // banks = await MapBankDetails.mapBankDetails();
    try {
      var faqData = await MapFaqs.mapFaqs();
      if (faqData["err"] != null) {
        if (context.mounted) {
          ApiException.apiException(context);
        }
      } else {
        faqs = faqData["fAQDatas"];
      }

      log("Init conf ended");
    } catch (e) {
      log(e.toString());
    }
  }

  void calculateUaeIndex() {
    for (var i = 0; i < dhabiCountries.length; i++) {
      if (dhabiCountries[i]["shortCode"] == "AE") {
        uaeIndex = i;
        break;
      }
    }
    uaeIndex = uaeIndex - emptyCountries;
    log("uaeIndex -> $uaeIndex");
  }

  void getAvailablePortfolios() async {
    try {
      var availablePortfolios =
          await MapAvailablePortfolios.mapAvailablePortfolios();
      if (availablePortfolios["success"]) {
        portfolios = availablePortfolios["data"];
      }
      log("portfolios -> $portfolios");
    } catch (e) {
      // if (context.mounted) {
      //   showDialog(
      //     context: context,
      //     builder: (context) {
      //       return CustomDialog(
      //         svgAssetPath: ImageConstants.warning,
      //         title: "Catch block",
      //         message: "From catch block",
      //         actionWidget: GradientButton(
      //           onTap: () {
      //             Navigator.pop(context);
      //           },
      //           text: "Okay",
      //         ),
      //       );
      //     },
      //   );
      // }
      log("getAvbportfolios exception -> ${e.toString()}");
    }
  }

  void getReferralConfig() async {
    var refConfig = await MapReferralConfig.mapReferralConfig();
    if (refConfig["success"]) {
      refVal = refConfig["data"][0]["value"];
    }
    log("refVal -> $refVal");
  }

  void getPolicies() async {
    try {
      terms = await MapTermsAndConditions.mapTermsAndConditions(
          {"languageCode": "en"});
    } catch (e) {
      log(e.toString());
    }

    try {
      statement =
          await MapPrivacyStatement.mapPrivacyStatement({"languageCode": "en"});
    } catch (e) {
      log(e.toString());
    }
  }

  void getDhabiCountriesFlagsAndCodes() {
    dhabiCountriesWithFlags.clear();
    dhabiCountryCodesWithFlags.clear();

    for (var country in dhabiCountries) {
      if (country["countryFlagBase64"] == null ||
          country["countryFlagBase64"] == "" ||
          country["dialCode"] == null ||
          country["dialCode"] == "" ||
          country["countryName"] == null ||
          country["countryName"] == "") {
        emptyCountries++;
      } else {
        dhabiCountriesWithFlags.add(
          DropDownCountriesModel(
            countryFlagBase64: country["countryFlagBase64"],
            countrynameOrCode: country["countryName"],
          ),
        );
        dhabiCountryCodesWithFlags.add(
          DropDownCountriesModel(
            countryFlagBase64: country["countryFlagBase64"],
            countrynameOrCode: "+${country["dialCode"]}",
          ),
        );
      }
    }
    log("emptyCountries -> $emptyCountries");
  }

  void populateDD(List dropdownList, int dropdownIndex) {
    dropdownList.clear();
    for (Map<String, dynamic> item in allDDs[dropdownIndex]["items"]) {
      dropdownList.add(item["value"]);
    }
  }

  void getDhabiCountryNames() {
    dhabiCountryNames.clear();
    countryLongCodes.clear();
    for (var country in dhabiCountries) {
      if (country["countryFlagBase64"] != null &&
          country["dialCode"] != null &&
          country["countryName"] != null) {
        dhabiCountryNames.add(country["countryName"]);
        countryLongCodes.add(country["longCode"]);
      }
    }
  }

  void getDhabiCityNames() {
    cityNames.clear();
    for (var city in dhabiCities) {
      cityNames.add(city["name"]);
    }
    log("cityNames -> $cityNames");
  }

  void navigate(BuildContext context) async {
    if (storageIsNotNewInstall! == false) {
      if (context.mounted) {
        Navigator.pushReplacementNamed(
          context,
          Routes.onboarding,
        );
      }
    } else {
      if (storageLoggedOut! == true) {
        if (context.mounted) {
          Navigator.pushReplacementNamed(
            context,
            Routes.onboarding,
          );
        }
      } else {
        if (context.mounted) {
          Navigator.pushReplacementNamed(
            context,
            Routes.loginUserId,
            arguments: StoriesArgumentModel(
              isBiometric: persistBiometric!,
            ).toMap(),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              './assets/images/icons/splash_icon.png',
            ),
          )
        ],
      ),
    );
  }
}
