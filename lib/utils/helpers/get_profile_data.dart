import 'dart:developer';

import 'package:investnation/data/repository/authentication/index.dart';
import 'package:investnation/main.dart';
import 'package:investnation/utils/constants/index.dart';

class MyGetProfileData {
  static Future<void> getProfileData() async {
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
    } catch (_) {
      rethrow;
    }
  }
}
