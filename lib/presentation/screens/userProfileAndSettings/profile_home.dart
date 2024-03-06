// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:investnation/bloc/showButton/index.dart';
import 'package:investnation/data/models/arguments/dashboard.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/data/repository/authentication/index.dart';
import 'package:investnation/main.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/presentation/widgets/core/topic_tile.dart';
import 'package:investnation/presentation/widgets/profile/index.dart';
import 'package:investnation/utils/constants/index.dart';

class ProfileHomeScreen extends StatefulWidget {
  const ProfileHomeScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<ProfileHomeScreen> createState() => _ProfileHomeScreenState();
}

class _ProfileHomeScreenState extends State<ProfileHomeScreen> {
  String? version;

  bool isUploading = false;

  bool hasProfilePicUpdated = false;

  bool isLoggingOut = false;

  late DashboardArgumentModel dashboardArgumentModel;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getPackageInfo();
      setState(() {});
    });

    argumentInitialization();
  }

  Future<void> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }

  void argumentInitialization() {
    dashboardArgumentModel =
        DashboardArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        if (hasProfilePicUpdated) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.dashboard,
            (route) => false,
            arguments: DashboardArgumentModel(
              onboardingState: dashboardArgumentModel.onboardingState,
            ).toMap(),
          );
        } else {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: AppBarLeading(
            onTap: () {
              if (hasProfilePicUpdated) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.dashboard,
                  (route) => false,
                  arguments: DashboardArgumentModel(
                    onboardingState: dashboardArgumentModel.onboardingState,
                  ).toMap(),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
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
                  children: [
                    EditProfilePhoto(
                      isMemoryImage: profilePhotoBase64 != null,
                      bytes: base64Decode(profilePhotoBase64 ?? ""),
                      onTap: showImageUploadOptions,
                    ),
                    const SizeBox(height: 10),
                    Text(
                      profileName ?? "",
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.dark100,
                        fontSize: (20 / Dimensions.designWidth).w,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizeBox(height: 30),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TopicTile(
                              fontSize: 16,
                              color: AppColors.dark5,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.profileEdit,
                                  arguments: DashboardArgumentModel(
                                    onboardingState:
                                        dashboardArgumentModel.onboardingState,
                                  ).toMap(),
                                );
                              },
                              iconPath: ImageConstants.settingsAccountBox,
                              text: "Profile",
                            ),
                            const SizeBox(height: 10),
                            TopicTile(
                              fontSize: 16,
                              color: AppColors.dark5,
                              onTap: () {
                                Navigator.pushNamed(context, Routes.security);
                              },
                              iconPath: ImageConstants.security,
                              text: "Security",
                            ),
                            const SizeBox(height: 10),
                            TopicTile(
                              fontSize: 16,
                              color: AppColors.dark5,
                              onTap: () {
                                if (dashboardArgumentModel.onboardingState <
                                    8) {
                                  showAdaptiveDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomDialog(
                                        svgAssetPath: ImageConstants.warning,
                                        title: "Sorry",
                                        message:
                                            "Please complete your initial risk profiling.",
                                        actionWidget: GradientButton(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          text: "Okay",
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  Navigator.pushNamed(
                                      context, Routes.preRiskProfiling);
                                }
                              },
                              iconPath: ImageConstants.shieldCheck,
                              text: "Risk Profile",
                            ),
                            const SizeBox(height: 10),
                            TopicTile(
                              fontSize: 16,
                              color: AppColors.dark5,
                              onTap: () {
                                if (dashboardArgumentModel.onboardingState <
                                    3) {
                                  showAdaptiveDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomDialog(
                                        svgAssetPath: ImageConstants.warning,
                                        title: "Sorry",
                                        message:
                                            "Please complete your initial KYC.",
                                        actionWidget: GradientButton(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          text: "Okay",
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  Navigator.pushNamed(context, Routes.preEid);
                                }
                              },
                              iconPath: ImageConstants.creditCard,
                              text: "Emirates ID",
                            ),
                            const SizeBox(height: 10),
                            TopicTile(
                              fontSize: 16,
                              color: AppColors.dark5,
                              onTap: () {
                                if (dashboardArgumentModel.onboardingState <
                                    8) {
                                  showAdaptiveDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomDialog(
                                        svgAssetPath: ImageConstants.warning,
                                        title: "Sorry",
                                        message:
                                            "Please complete your onboarding.",
                                        actionWidget: GradientButton(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          text: "Okay",
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  Navigator.pushNamed(
                                      context, Routes.cardManagement);
                                }
                              },
                              iconPath: ImageConstants.block,
                              text: "Freeze/Unfreeze",
                            ),
                            const SizeBox(height: 10),
                            TopicTile(
                              fontSize: 16,
                              color: AppColors.dark5,
                              onTap: () {
                                Navigator.pushNamed(context, Routes.documents);
                              },
                              iconPath: ImageConstants.documents,
                              text: "Documents",
                            ),
                            const SizeBox(height: 10),
                            TopicTile(
                              fontSize: 16,
                              color: AppColors.dark5,
                              onTap: () {
                                Navigator.pushNamed(context, Routes.faq);
                              },
                              iconPath: ImageConstants.faq,
                              text: "FAQs",
                            ),
                            const SizeBox(height: 10),
                            TopicTile(
                              fontSize: 16,
                              color: AppColors.dark5,
                              onTap: () {
                                showAdaptiveDialog(
                                  context: context,
                                  builder: (context) {
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: (PaddingConstants
                                                        .horizontalPadding /
                                                    Dimensions.designWidth)
                                                .w,
                                            vertical:
                                                PaddingConstants.bottomPadding +
                                                    MediaQuery.of(context)
                                                        .padding
                                                        .bottom,
                                          ),
                                          child: Container(
                                            width: 100.w,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular((24 /
                                                        Dimensions.designWidth)
                                                    .w),
                                              ),
                                              color: AppColors.dark5,
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: (22 /
                                                            Dimensions
                                                                .designWidth)
                                                        .w,
                                                    vertical: (22 /
                                                            Dimensions
                                                                .designHeight)
                                                        .h),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      ImageConstants.smile,
                                                      width: (111 /
                                                              Dimensions
                                                                  .designHeight)
                                                          .h,
                                                      height: (111 /
                                                              Dimensions
                                                                  .designHeight)
                                                          .h,
                                                    ),
                                                    const SizeBox(height: 20),
                                                    Text(
                                                      "Hey there!",
                                                      style: TextStyles
                                                          .primaryBold
                                                          .copyWith(
                                                        color: Colors.black,
                                                        fontSize: (20 /
                                                                Dimensions
                                                                    .designWidth)
                                                            .w,
                                                      ),
                                                    ),
                                                    const SizeBox(height: 10),
                                                    Text(
                                                      "Please check FAQs.\nIf you do not find your Query,",
                                                      style: TextStyles
                                                          .primaryMedium
                                                          .copyWith(
                                                        color: AppColors.grey81,
                                                        fontSize: (16 /
                                                                Dimensions
                                                                    .designWidth)
                                                            .w,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "Contact us on our ",
                                                          style: TextStyles
                                                              .primaryMedium
                                                              .copyWith(
                                                            color: AppColors
                                                                .grey81,
                                                            fontSize: (16 /
                                                                    Dimensions
                                                                        .designWidth)
                                                                .w,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            launchUrl(
                                                              Uri.parse(
                                                                //'https://wa.me/971504596103' //you use this url also
                                                                'whatsapp://send?phone=971504596103', //put your number here
                                                              ),
                                                            );
                                                          },
                                                          child: Text(
                                                            "Whatsapp",
                                                            style: TextStyles
                                                                .primaryMedium
                                                                .copyWith(
                                                              color: AppColors
                                                                  .primary80,
                                                              fontSize: (16 /
                                                                      Dimensions
                                                                          .designWidth)
                                                                  .w,
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizeBox(height: 20),
                                                    GradientButton(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      text: "Close",
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              iconPath: ImageConstants.whatsapp,
                              text: "Contact us via Whatsapp",
                            ),
                            const SizeBox(height: 26),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        TopicTile(
                          fontSize: 16,
                          highlightColor: AppColors.red10,
                          color: AppColors.dark5,
                          onTap: promptUserLogout,
                          iconPath: ImageConstants.logout,
                          text: "Log out",
                          fontColor: AppColors.red100,
                        ),
                        const SizeBox(height: 20),
                        Text(
                          "App Version $version",
                          style: TextStyles.primaryMedium.copyWith(
                            color: AppColors.dark50,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                        ),
                        SizeBox(
                          height: PaddingConstants.bottomPadding +
                              MediaQuery.of(context).padding.bottom,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showImageUploadOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: (127 / Dimensions.designHeight).h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular((10 / Dimensions.designWidth).w),
              topRight: Radius.circular((10 / Dimensions.designWidth).w),
            ),
          ),
          child: Column(
            children: [
              const SizeBox(height: 10),
              ListTile(
                dense: true,
                onTap: () {
                  uploadImage(ImageSource.camera);
                },
                leading: Container(
                  width: (30 / Dimensions.designWidth).w,
                  height: (30 / Dimensions.designWidth).w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1,
                      color: AppColors.dark100,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: (15 / Dimensions.designWidth).w,
                    color: AppColors.dark100,
                  ),
                ),
                title: Text(
                  "Camera",
                  style: TextStyles.primaryBold.copyWith(
                    color: AppColors.dark100,
                    fontSize: (18 / Dimensions.designWidth).w,
                  ),
                ),
              ),
              ListTile(
                dense: true,
                onTap: () async {
                  uploadImage(ImageSource.gallery);
                },
                leading: Container(
                  width: (30 / Dimensions.designWidth).w,
                  height: (30 / Dimensions.designWidth).w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1,
                      color: AppColors.dark100,
                    ),
                  ),
                  child: Icon(
                    Icons.collections_rounded,
                    size: (15 / Dimensions.designWidth).w,
                    color: AppColors.dark100,
                  ),
                ),
                title: Text(
                  "Gallery",
                  style: TextStyles.primaryBold.copyWith(
                    color: AppColors.dark100,
                    fontSize: (18 / Dimensions.designWidth).w,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void promptUploadPhotoError() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Image Upload Failed",
          message: "Your attempt to upload your profile photo failed.",
          actionWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
            },
            text: labels[347]["labelText"],
          ),
        );
      },
    );
  }

  void uploadImage(ImageSource source) async {
    try {
      Navigator.pop(context);
      // isUploading = true;
      setState(() {});
      XFile? pickedImageFile = await ImagePicker().pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 40,
      );

      if (pickedImageFile != null) {
        // log("Picked photo size -> ${((await pickedImageFile.readAsBytes()).lengthInBytes) / 1024} KB");
        CroppedFile? croppedImageFile = await ImageCropper().cropImage(
            sourcePath: pickedImageFile.path,
            aspectRatioPresets: [CropAspectRatioPreset.square],
            compressQuality: 40);

        if (croppedImageFile != null) {
          log("Cropped photo size -> ${((await croppedImageFile.readAsBytes()).lengthInBytes) / 1024} KB");
          String photoBase64 =
              base64Encode(await croppedImageFile.readAsBytes());

          var compressedphotoBase64 =
              await FlutterImageCompress.compressWithList(
            base64Decode(photoBase64),
            quality: 25,
          );
          photoBase64 = base64Encode(compressedphotoBase64);

          log("Compressed Cropped photo size -> ${((base64Decode(photoBase64).lengthInBytes) / 1024)} KB");

          log("Upload profile photo request -> ${{
            "photoBase64": photoBase64
          }}");
          try {
            var uploadPPResult =
                await MapUploadProfilePhoto.mapUploadProfilePhoto(
              {"photoBase64": photoBase64},
            );
            log("Upload Profile Photo response -> $uploadPPResult");
            if (uploadPPResult["success"]) {
              try {
                var getProfileDataResult =
                    await MapProfileData.mapProfileData();
                if (getProfileDataResult["success"]) {
                  profilePhotoBase64 =
                      getProfileDataResult["profileImageBase64"];
                  await storage.write(
                      key: "profilePhotoBase64", value: profilePhotoBase64);
                  storageProfilePhotoBase64 =
                      await storage.read(key: "profilePhotoBase64");
                  hasProfilePicUpdated = true;
                }
              } catch (e) {
                log(e.toString());
              }
            } else {
              promptUploadPhotoError();
            }
          } catch (e) {
            log(e.toString());
          }

          isUploading = false;
          setState(() {});
        } else {
          isUploading = false;
          setState(() {});
        }
      } else {
        isUploading = false;
        setState(() {});
      }
    } catch (e) {
      log("Image upload error -> $e");
    }
  }

  void promptUserLogout() {
    showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Are you sure?",
          message: "If you log out you would need to re-login again",
          auxWidget: BlocBuilder<ShowButtonBloc, ShowButtonState>(
            builder: (context, state) {
              return GradientButton(
                onTap: () async {
                  if (!isLoggingOut) {
                    final ShowButtonBloc showButtonBloc =
                        context.read<ShowButtonBloc>();
                    isLoggingOut = true;
                    showButtonBloc.add(ShowButtonEvent(show: isLoggingOut));

                    token == null;
                    isUserLoggedIn = false;

                    // await storage.write(
                    //     key: "loggedOut", value: true.toString());
                    // storageLoggedOut =
                    //     await storage.read(key: "loggedOut") == "true";

                    // await storage.delete(key: "hasFirstLoggedIn");
                    // await storage.delete(key: "token");
                    // await storage.delete(key: "isFirstLogin");
                    // await storage.delete(key: "userId");
                    // await storage.delete(key: "password");
                    // await storage.delete(key: "emailAddress");
                    // await storage.delete(key: "userTypeId");
                    // await storage.delete(key: "companyId");
                    // // await storage.delete(key: "persistBiometric");
                    // await storage.delete(key: "stepsCompleted");
                    // await storage.delete(key: "isEid");
                    // await storage.delete(key: "fullName");
                    // await storage.delete(key: "eiDNumber");
                    // await storage.delete(key: "passportNumber");
                    // await storage.delete(key: "nationality");
                    // await storage.delete(key: "nationalityCode");
                    // await storage.delete(key: "issuingStateCode");
                    // await storage.delete(key: "expiryDate");
                    // await storage.delete(key: "dob");
                    // await storage.delete(key: "gender");
                    // await storage.delete(key: "photo");
                    // await storage.delete(key: "docPhoto");
                    // await storage.delete(key: "selfiePhoto");
                    // await storage.delete(key: "photoMatchScore");
                    // await storage.delete(key: "addressCountry");
                    // await storage.delete(key: "addressLine1");
                    // await storage.delete(key: "addressLine2");
                    // await storage.delete(key: "addressCity");
                    // await storage.delete(key: "addressState");
                    // await storage.delete(key: "addressEmirate");
                    // await storage.delete(key: "poBox");
                    // await storage.delete(key: "incomeSource");
                    // await storage.delete(key: "isUSFatca");
                    // await storage.delete(key: "taxCountry");
                    // await storage.delete(key: "isTinYes");
                    // await storage.delete(key: "crsTin");
                    // await storage.delete(key: "noTinReason");
                    // await storage.delete(key: "accountType");
                    // await storage.delete(key: "cif");
                    // await storage.delete(key: "isCompany");
                    // await storage.delete(key: "isCompanyRegistered");
                    // await storage.delete(key: "retailLoggedIn");
                    // await storage.delete(key: "customerName");
                    // await storage.delete(key: "chosenAccount");

                    if (context.mounted) {
                      Navigator.pop(context);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.onboarding,
                        (routes) => false,
                      );
                    }
                    isLoggingOut = false;
                    showButtonBloc.add(ShowButtonEvent(show: isLoggingOut));
                  }
                },
                text: "Yes, I am sure",
                auxWidget: isLoggingOut ? const LoaderRow() : const SizeBox(),
              );
            },
          ),
          actionWidget: SolidButton(
            boxShadow: [BoxShadows.primary],
            color: Colors.white,
            fontColor: AppColors.dark100,
            onTap: () {
              Navigator.pop(context);
            },
            text: "No, go back",
          ),
        );
      },
    );
  }
}
