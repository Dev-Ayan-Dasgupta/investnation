// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_document_reader_api/document_reader.dart';
import 'package:flutter_face_api/face_api.dart' as regula;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:investnation/bloc/index.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/data/models/widgets/index.dart';
import 'package:investnation/data/repository/onboarding/index.dart';
import 'package:investnation/environment/index.dart';
import 'package:investnation/main.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/screens/common/index.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:investnation/utils/helpers/index.dart';

class ScannedDetailsScreen extends StatefulWidget {
  const ScannedDetailsScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<ScannedDetailsScreen> createState() => _ScannedDetailsScreenState();
}

class _ScannedDetailsScreenState extends State<ScannedDetailsScreen> {
  late ScannedDetailsArgumentModel scannedDetailsArgument;

  bool isChecked = false;

  regula.MatchFacesImage image1 = regula.MatchFacesImage();
  regula.MatchFacesImage image2 = regula.MatchFacesImage();

  Image img1 = Image.memory(base64Decode(
      storagePhoto != null ? cleanupBase64Image((storagePhoto)) : ""));
  Image img2 = Image.asset(ImageConstants.eidFront);

  List<DetailsTileModel> details = [];

  bool isFaceScanning = false;

  bool isDialogOpen = false;
  bool isMismatch = false;
  bool isEIDScanError = false;

  String tempFullName = "";

  late EventChannel eventChannel;

  @override
  void initState() {
    super.initState();
    initializeArgument();
    initializeDetails();
    initializeFaceSdk();

    DocumentReader.setConfig({
      "functionality": {
        "showCaptureButton": false,
        "showCaptureButtonDelayFromStart": 2,
        "showCaptureButtonDelayFromDetect": 1,
        "showCloseButton": true,
        "showTorchButton": true,
      },
      "customization": {
        "status": "Searching for document",
        "showBackgroundMask": true,
        "backgroundMaskAlpha": 0.6,
      },
      "processParams": {
        // "logs": true,
        "dateFormat": "dd/MM/yyyy",
        "scenario": ScenarioIdentifier.SCENARIO_OCR,
        "timeout": 30.0,
        "timeoutFromFirstDetect": 30.0,
        "timeoutFromFirstDocType": 30.0,
        "multipageProcessing": true,
        "licenseUpdate": true,
        "debugSaveLogs": true,
        "debugSaveCroppedImages": true,
        "debugSaveRFIDSession": true,
      }
    });
    // eventChannel =
    //     const EventChannel('flutter_document_reader_api/event/completion');

    // eventChannel.receiveBroadcastStream().listen(
    //       (jsonString) => handleEIDCompletion(
    //         DocumentReaderCompletion.fromJson(
    //           json.decode(jsonString),
    //         )!,
    //       ),
    //     );
  }

  void initializeArgument() {
    scannedDetailsArgument =
        ScannedDetailsArgumentModel.fromMap(widget.argument as dynamic ?? {});

    image1.bitmap = base64Encode(base64Decode(
        storagePhoto != null ? storagePhoto!.replaceAll("\n", "") : ""));
    image1.imageType = regula.ImageType.PRINTED;

    fullName = scannedDetailsArgument.fullName;
    log("Full Name -> $fullName");

    if (scannedDetailsArgument.isEID) {
      eiDNumber = scannedDetailsArgument.idNumber;
      log("EID Number -> $eiDNumber");
    } else {
      passportNumber = scannedDetailsArgument.idNumber;
      log("Passport Number -> $passportNumber");
    }

    nationality = scannedDetailsArgument.nationality;
    log("Nationality -> $nationality");
    nationalityCode = scannedDetailsArgument.nationalityCode;
    log("Nationality Code -> $nationalityCode");

    expiryDate = scannedDetailsArgument.expiryDate;
    log("Expiry Date -> ${DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(expiryDate ?? "00/00/0000"))}");
    dob = scannedDetailsArgument.dob;
    log("DoB -> ${DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(dob ?? "00/00/0000"))}");

    gender = scannedDetailsArgument.gender;
    log("Gender -> $gender");

    photo = scannedDetailsArgument.photo;
    log("Photo -> $photo");
    docPhoto = scannedDetailsArgument.docPhoto;
    log("DocPhoto -> $docPhoto");
  }

  void initializeDetails() {
    details = [
      DetailsTileModel(
          key: "Full Name", value: scannedDetailsArgument.fullName ?? "null"),
      DetailsTileModel(
        key: scannedDetailsArgument.isEID ? "EID No." : "Passport No.",
        value: scannedDetailsArgument.isEID
            ? scannedDetailsArgument.idNumber ?? "null"
            : scannedDetailsArgument.idNumber ?? "null",
      ),
      DetailsTileModel(
          key: "Nationality",
          value: scannedDetailsArgument.nationality ?? "null"),
      DetailsTileModel(
        key: scannedDetailsArgument.isEID
            ? "EID Expiry Date"
            : "Passport Expiry Date",
        value: DateFormat('dd MMMM yyyy').format(
          DateFormat('dd/MM/yyyy')
              .parse(scannedDetailsArgument.expiryDate ?? "00/00/0000"),
        ),
      ),
      DetailsTileModel(
        key: "Date of Birth",
        value: DateFormat('dd MMMM yyyy').format(
          DateFormat('dd/MM/yyyy')
              .parse(scannedDetailsArgument.dob ?? "00/00/0000"),
        ),
      ),
      DetailsTileModel(
        key: "Gender",
        value: scannedDetailsArgument.gender == null
            ? "null"
            : scannedDetailsArgument.gender == "M"
                ? "Male"
                : "Female",
      ),
    ];
  }

  void initializeFaceSdk() {
    regula.FaceSDK.init().then((json) {
      var response = jsonDecode(json);
      if (!response["success"]) {}
    });
    const EventChannel('flutter_face_api/event/video_encoder_completion')
        .receiveBroadcastStream()
        .listen((event) {
      var response = jsonDecode(event);
      String transactionId = response["transactionId"];
      bool success = response["success"];
      log("video_encoder_completion:");
      log("success: $success");
      log("transactionId: $transactionId");
    });
  }

  void handleEIDCompletion(DocumentReaderCompletion completion) async {
    isEIDScanError = false;

    if (completion.action == DocReaderAction.COMPLETE) {
      DocumentReaderResultsStatus? status = completion.results?.status;

      log("Overall Status -> ${status?.detailsOptical?.overallStatus}");

      DocumentReaderResults? results = completion.results;

      // ! Check that both the sides are scanned for an EID
      if (results?.documentType.length != 2) {
        promptScanBothSides();
        isEIDScanError = true;
        return;
      }

      // ! Check that only Emirates ID is used for scanning
      if (!isEIDScanError &&
          (results?.documentType[0]?.dType != DiDocType.dtResidentIdCard ||
              results?.documentType[1]?.dType != DiDocType.dtResidentIdCard) &&
          (results?.documentType[0]?.dType != DiDocType.dtIdentityCard ||
              results?.documentType[1]?.dType != DiDocType.dtIdentityCard)) {
        promptWrongIDType();
        isEIDScanError = true;
        return;
      }

      // ! Check that the side one is scanned first
      if (!isEIDScanError && results?.documentType[0]?.pageIndex != 0) {
        promptWrongSideScan();
        isEIDScanError = true;
        return;
      }

      // ! Now check that same EID is used for both front and back
      if (!isEIDScanError) {
        results?.textResult?.fields.forEach((element) {
          if (element!.fieldType == EVisualFieldType.FT_IDENTITY_CARD_NUMBER) {
            if (element.values.length < 2) {
              promptEIDScanFault();
              isEIDScanError = true;
              return;
            } else {
              if (element.values[0]?.value != null) {
                if (element.values[0]?.value?.replaceAll('-', '') !=
                    element.values[1]?.value?.replaceAll('-', '')) {
                  promptEIDSidesDifferent();
                  isEIDScanError = true;
                  return;
                }
              } else {
                promptEIDScanFault();
                isEIDScanError = true;
                return;
              }
            }
          }

          if (element.fieldType ==
                  EVisualFieldType.FT_SURNAME_AND_GIVEN_NAMES &&
              element.lcid == 0 &&
              element.values.length > 1) {
            tempFullName = element.values[1]!.value!;
            log("tempFullName -> $tempFullName");
          }
        });
      }

      if (!isEIDScanError) {
        fullName = tempFullName;
        log("fullName -> $fullName");
        // await results?.textFieldValueByTypeLcid(
        //   EVisualFieldType.FT_SURNAME_AND_GIVEN_NAMES,
        //   LCID.LATIN,
        // );
        await storage.write(key: "fullName", value: fullName);
        storageFullName = await storage.read(key: "fullName");

        eiDNumber = await results?.textFieldValueByTypeLcidSource(
          EVisualFieldType.FT_IDENTITY_CARD_NUMBER,
          LCID.LATIN,
          ERPRMResultType.RPRM_RESULT_TYPE_VISUAL_OCR_EXTENDED,
        );
        await storage.write(key: "eiDNumber", value: eiDNumber);
        storageEidNumber = await storage.read(key: "eiDNumber");

        nationality = await results?.textFieldValueByTypeLcid(
          EVisualFieldType.FT_NATIONALITY,
          LCID.LATIN,
        );
        await storage.write(key: "nationality", value: nationality);
        storageNationality = await storage.read(key: "nationality");

        nationalityCode = await results?.textFieldValueByTypeLcidSource(
            EVisualFieldType.FT_NATIONALITY_CODE,
            LCID.LATIN,
            ERPRMResultType.RPRM_RESULT_TYPE_MRZ_OCR_EXTENDED);
        String? nationalityUpper = nationality?.toUpperCase();
        for (var country in dhabiCountries) {
          if (nationalityUpper == country["countryName"]) {
            nationalityCode = country["shortCode"];
            break;
          }
        }
        await storage.write(key: "nationalityCode", value: nationalityCode);
        storageNationalityCode = await storage.read(key: "nationalityCode");
        log("storageNationalityCode -> $storageNationalityCode");

        expiryDate = await results
            ?.textFieldValueByType(EVisualFieldType.FT_DATE_OF_EXPIRY);
        await storage.write(key: "expiryDate", value: expiryDate);
        storageExpiryDate = await storage.read(key: "expiryDate");

        dob = await results
            ?.textFieldValueByType(EVisualFieldType.FT_DATE_OF_BIRTH);
        await storage.write(key: "dob", value: dob);
        storageDob = await storage.read(key: "dob");

        gender = await results?.textFieldValueByTypeLcidSource(
            EVisualFieldType.FT_SEX,
            LCID.LATIN,
            ERPRMResultType.RPRM_RESULT_TYPE_VISUAL_OCR_EXTENDED);
        await storage.write(key: "gender", value: gender);
        storageGender = await storage.read(key: "gender");

        Uri? photoUri = await results
            ?.graphicFieldImageByType(EGraphicFieldType.GF_PORTRAIT);
        photo = photoUri?.path;
        if (photo != null) {
          log("photoString before -> $photo");
          image1.bitmap = base64Encode(base64Decode(cleanupBase64Image(photo)));
          image1.imageType = regula.ImageType.PRINTED;
          img1 = Image.memory(base64Decode(cleanupBase64Image(photo)));

          log("User photo Size before compress -> ${base64Decode(cleanupBase64Image(photo)).lengthInBytes}");
          var compressedPhoto = await FlutterImageCompress.compressWithList(
            base64Decode(cleanupBase64Image(photo)),
            quality: 30,
          );

          photo = base64Encode(compressedPhoto);

          log("User photo Size after compress -> ${compressedPhoto.lengthInBytes / 1024} KB");
          img1 = Image.memory(compressedPhoto);

          log("photoString after -> $photo");
        }
        await storage.write(key: "photo", value: photo);
        storagePhoto = await storage.read(key: "photo");

        Uri? docPhotoUri = await results
            ?.graphicFieldImageByType(EGraphicFieldType.GF_DOCUMENT_IMAGE);
        docPhoto = docPhotoUri?.path;
        docPhoto = cleanupBase64Image(docPhoto);

        var compressedDocPhoto = await FlutterImageCompress.compressWithList(
          base64Decode(docPhoto ?? ""),
          quality: 30,
        );
        docPhoto = base64Encode(compressedDocPhoto);

        log("Size after compress doc photo -> ${compressedDocPhoto.lengthInBytes / 1024} KB");

        await storage.write(key: "docPhoto", value: docPhoto);
        storageDocPhoto = await storage.read(key: "docPhoto");

        log("Request -> ${{"eidNumber": eiDNumber}}");

        if (eiDNumber != null &&
            // storageNationalityCode != null &&
            storageFullName != null &&
            storageNationality != null &&
            storageExpiryDate != null &&
            storageDob != null &&
            storageGender != null &&
            storagePhoto != null &&
            storageDocPhoto != null) {
          log("If EID Exists Req -> ${{"eidNumber": eiDNumber}}");

          try {
            bool result = await MapIfEidExists.mapIfEidExists(
              {"eidNumber": eiDNumber},
            );

            log("If EID Exists API response -> $result");
            log("Doc Expired check -> ${DateTime.parse(DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(expiryDate ?? "00/00/0000"))).difference(DateTime.now()).inDays}");
            log("Age check -> ${DateTime.now().difference(DateTime.parse(DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(dob ?? "00/00/0000")))).inDays}");

            // ? Check for expired
            if (DateTime.parse(DateFormat('yyyy-MM-dd').format(
                        DateFormat('dd/MM/yyyy')
                            .parse(expiryDate ?? "1900-01-01")))
                    .difference(DateTime.now())
                    .inDays <
                0) {
              if (context.mounted) {
                Navigator.pushNamed(
                  context,
                  Routes.errorSuccess,
                  arguments: ErrorArgumentModel(
                    hasSecondaryButton: false,
                    iconPath: ImageConstants.errorOutlined,
                    title: messages[81]["messageText"],
                    message: messages[29]["messageText"],
                    buttonText: "Go Home",
                    // labels[1]["labelText"],
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.dashboard,
                        (route) => false,
                        arguments: DashboardArgumentModel(
                          onboardingState: 2,
                        ).toMap(),
                      );
                    },
                    buttonTextSecondary: "",
                    onTapSecondary: () {},
                  ).toMap(),
                );
              }
            }
            // ? Check for age
            else if (DateTime.now()
                    .difference(DateTime.parse(DateFormat('yyyy-MM-dd').format(
                        DateFormat('dd/MM/yyyy').parse(dob ?? "00/00/0000"))))
                    .inDays <
                ((18 * 365) + 4)) {
              if (context.mounted) {
                Navigator.pushNamed(
                  context,
                  Routes.errorSuccess,
                  arguments: ErrorArgumentModel(
                    hasSecondaryButton: false,
                    iconPath: ImageConstants.errorOutlined,
                    title: messages[80]["messageText"],
                    message: messages[33]["messageText"],
                    buttonText: "Go Home",
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.dashboard,
                        (route) => false,
                        arguments: DashboardArgumentModel(
                          onboardingState: 2,
                        ).toMap(),
                      );
                    },
                    buttonTextSecondary: "",
                    onTapSecondary: () {},
                  ).toMap(),
                );
              }
            }

            // ? Check for previous existence
            else if (!(scannedDetailsArgument.isReKyc)) {
              if (result) {
                if (context.mounted) {
                  Navigator.pushNamed(context, Routes.errorSuccess,
                      arguments: ErrorArgumentModel(
                        hasSecondaryButton: false,
                        iconPath: ImageConstants.errorOutlined,
                        title: messages[76]["messageText"],
                        message: messages[23]["messageText"],
                        buttonText: "Go Back",
                        onTap: () {
                          Navigator.pop(context);
                        },
                        buttonTextSecondary: "",
                        onTapSecondary: () {},
                      ).toMap());
                }
              } else {
                await storage.write(key: "isEid", value: true.toString());
                // storageIsEid = bool.parse(await storage.read(key: "isEid") ?? "");
                storageIsEid =
                    (await storage.read(key: "isEid") ?? "") == "true";
                if (!(scannedDetailsArgument.isReKyc)) {
                  await storage.write(
                      key: "stepsCompleted", value: 3.toString());
                  storageStepsCompleted = int.parse(
                      await storage.read(key: "stepsCompleted") ?? "0");
                }

                if (context.mounted) {
                  Navigator.pushReplacementNamed(
                    context,
                    Routes.scannedDetails,
                    arguments: ScannedDetailsArgumentModel(
                      isEID: true,
                      fullName: storageFullName,
                      // fullName,
                      idNumber: eiDNumber,
                      nationality: nationality,
                      nationalityCode: nationalityCode,
                      expiryDate: expiryDate,
                      dob: dob,
                      gender: gender,
                      photo: photo,
                      docPhoto: docPhoto,
                      isReKyc: scannedDetailsArgument.isReKyc,
                    ).toMap(),
                  );
                }
              }
            } else {
              await storage.write(key: "isEid", value: true.toString());
              // storageIsEid = bool.parse(await storage.read(key: "isEid") ?? "");
              storageIsEid = (await storage.read(key: "isEid") ?? "") == "true";
              if (!(scannedDetailsArgument.isReKyc)) {
                await storage.write(key: "stepsCompleted", value: 3.toString());
                storageStepsCompleted =
                    int.parse(await storage.read(key: "stepsCompleted") ?? "0");
              }

              if (context.mounted) {
                Navigator.pushReplacementNamed(
                  context,
                  Routes.scannedDetails,
                  arguments: ScannedDetailsArgumentModel(
                    isEID: true,
                    fullName: fullName,
                    idNumber: eiDNumber,
                    nationality: nationality,
                    nationalityCode: nationalityCode,
                    expiryDate: expiryDate,
                    dob: dob,
                    gender: gender,
                    photo: photo,
                    docPhoto: docPhoto,
                    isReKyc: scannedDetailsArgument.isReKyc,
                  ).toMap(),
                );
              }
            }
          } catch (e) {
            log(e.toString());
          }
        } else {
          if (context.mounted) {
            promptScanError("Emirates ID");
          }
        }
      }
    } else if (completion.action == DocReaderAction.TIMEOUT) {
      if (context.mounted) {
        Navigator.pushNamed(
          context,
          Routes.errorSuccess,
          arguments: ErrorArgumentModel(
            hasSecondaryButton: false,
            iconPath: ImageConstants.errorOutlined,
            title: messages[73]["messageText"],
            message: "Your time has run out. Please try again.",
            // messages[35]["messageText"],
            buttonText: labels[88]["labelText"],
            // labels[1]["labelText"],
            onTap: () {
              Navigator.pop(context);
            },
            buttonTextSecondary: "",
            onTapSecondary: () {},
          ).toMap(),
        );
      }
    } else if (completion.action == DocReaderAction.ERROR) {
      log("Error from regula -> ${completion.error?.toJson()}");
      if (context.mounted) {
        promptScanError("Emirates ID");
      }
    } else if (completion.action == DocReaderAction.CANCEL ||
        completion.action == DocReaderAction.MORE_PAGES_AVAILABLE ||
        completion.action == DocReaderAction.NOTIFICATION ||
        completion.action == DocReaderAction.PROCESS ||
        completion.action == DocReaderAction.PROCESSING_ON_SERVICE ||
        completion.action == DocReaderAction.PROCESS_IR_FRAME ||
        completion.action == DocReaderAction.PROCESS_WHITE_FLASHLIGHT ||
        completion.action == DocReaderAction.PROCESS_WHITE_UV_IMAGES) {
      log("Something else has happened");
      // ! Don't do anthing for now
    } else {
      log("Big else executing");
      log("Error from regula -> ${completion.toJson()}");
      if (context.mounted) {
        promptScanError("Emirates ID");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        actions: [
          InkWell(
            onTap: () {
              ShowFaqSmile.showFaqSmile(context);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (16 / Dimensions.designWidth).w,
                vertical: (5 / Dimensions.designWidth).w,
              ),
              child: SvgPicture.asset(
                ImageConstants.support,
                width: (50 / Dimensions.designWidth).w,
                height: (50 / Dimensions.designWidth).w,
              ),
            ),
          )
        ],
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Emirates ID Details",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.dark100,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 15),
                  Text(
                    "Review the details of your scanned Emirates ID",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark80,
                      fontSize: (16 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 25),
                  Expanded(
                    child: DetailsTile(
                      length: details.length,
                      details: details,
                      boldIndices: const [],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<CheckBoxBloc, CheckBoxState>(
                      builder: buildTC,
                    ),
                    const SizeBox(width: 5),
                    Expanded(
                      child: Text(
                        "I confirm the above-mentioned information is the same as on my Emirates ID card",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.grey81,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizeBox(height: 36),
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: buildSubmitButton,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSubmitButton(BuildContext context, ShowButtonState state) {
    if (isChecked) {
      return Column(
        children: [
          GradientButton(
            onTap: () {
              if (!isFaceScanning) {
                liveliness();
              }
            },
            text: "Proceed and take selfie",
            auxWidget: isFaceScanning ? const LoaderRow() : const SizeBox(),
          ),
          const SizeBox(height: 15),
          SolidButton(
            onTap: () {
              /*
              setState(() {
                isDialogOpen = false;
              });
              if (!isFaceScanning) {
                isEidChosen = true;
                DocumentReader.showScanner();
              } */
              Navigator.pop(context, true);
            },
            text: "Re-scan Emirates ID",
            color: Colors.white,
            boxShadow: [BoxShadows.primary],
            fontColor: AppColors.dark100,
          ),
          const SizeBox(height: PaddingConstants.bottomPadding),
        ],
      );
    } else {
      return Column(
        children: [
          SolidButton(
            onTap: () {},
            text: "Proceed and take selfie",
          ),
          const SizeBox(height: 15),
          SolidButton(
            onTap: () {
              if (!isFaceScanning) {
                isEidChosen = true;
                DocumentReader.showScanner();
              }
            },
            text: "Re-scan Emirates ID",
            color: Colors.white,
            boxShadow: [BoxShadows.primary],
            fontColor: AppColors.dark100,
          ),
          const SizeBox(height: PaddingConstants.bottomPadding),
        ],
      );
    }
  }

  Widget buildTC(BuildContext context, CheckBoxState state) {
    if (isChecked) {
      return InkWell(
        onTap: () {
          isChecked = false;
          triggerCheckBoxEvent(isChecked);
          triggerAllTrueEvent();
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
          triggerAllTrueEvent();
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

  void triggerCheckBoxEvent(bool isChecked) {
    final CheckBoxBloc checkBoxBloc = context.read<CheckBoxBloc>();
    checkBoxBloc.add(CheckBoxEvent(isChecked: isChecked));
  }

  void triggerAllTrueEvent() {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
    showButtonBloc.add(ShowButtonEvent(show: isChecked));
  }

  void liveliness() async {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();

    isFaceScanning = true;
    showButtonBloc.add(ShowButtonEvent(show: isFaceScanning));

    var value = await regula.FaceSDK.startLiveness();
    var result = regula.LivenessResponse.fromJson(json.decode(value));
    selfiePhoto = result!.bitmap!.replaceAll("\n", "");
    selfiePhoto = cleanupBase64Image(selfiePhoto);

    log("Selfie Photo before -> $selfiePhoto");
    log("Selfie size before compress -> ${base64Decode(selfiePhoto).lengthInBytes}");
    var compressedSelfie = await FlutterImageCompress.compressWithList(
      base64Decode(selfiePhoto),
      quality: 30,
    );
    selfiePhoto = base64Encode(compressedSelfie);

    // while (compressedSelfie.lengthInBytes / 1024 > 100) {
    //   compressedSelfie = await FlutterImageCompress.compressWithList(
    //     base64Decode(selfiePhoto),
    //     quality: math.Random.secure().nextInt(10) + 85,
    //     // 95 - i,
    //   );
    //   selfiePhoto = base64Encode(compressedSelfie);
    // }
    // i = 5;

    log("Selfie size after compress -> ${compressedSelfie.lengthInBytes / 1024} KB");

    log("Selfie photo after -> $selfiePhoto");

    await storage.write(key: "selfiePhoto", value: selfiePhoto);
    storageSelfiePhoto = await storage.read(key: "selfiePhoto");
    log("storageSelfiePhoto -> $storageSelfiePhoto");
    image2.bitmap = base64Encode(base64Decode(selfiePhoto));
    image2.imageType = regula.ImageType.LIVE;

    img2 = Image.memory(base64Decode(selfiePhoto));
    log("Selfie -> $selfiePhoto");

    await matchfaces();

    if (photoMatchScore >= double.parse(Environment.selfieMatchScore)) {
      // if (context.mounted) {
      //   Navigator.pushNamed(context, Routes.applicationAddress);
      // }

      Map<String, dynamic> response = {};
      log("Upload eid v2 request -> ${{
        "eidDocumentImage": storageDocPhoto ?? "",
        "eidUserPhoto": storagePhoto ?? "",
        "selfiePhoto": storageSelfiePhoto ?? "",
        "photoMatchScore": storagePhotoMatchScore ?? 0.0,
        "eidNumber": storageEidNumber ?? "",
        "fullName": storageFullName ?? "",
        "dateOfBirth": DateFormat('yyyy-MM-dd')
            .format(DateFormat('dd/MM/yyyy').parse(storageDob ?? "00/00/0000")),
        "nationalityCountryCode": storageNationalityCode ?? "",
        "genderId": storageGender == 'M' ? 1 : 2,
        "expiresOn": DateFormat('yyyy-MM-dd').format(
            DateFormat('dd/MM/yyyy').parse(storageExpiryDate ?? "00/00/0000")),
        "isReKYC": scannedDetailsArgument.isReKyc,
      }}");
      try {
        response = await MapUploadEid.mapUploadEid(
          {
            "eidDocumentImage": storageDocPhoto ?? "",
            "eidUserPhoto": storagePhoto ?? "",
            "selfiePhoto": storageSelfiePhoto ?? "",
            "photoMatchScore": storagePhotoMatchScore ?? 0.0,
            "eidNumber": storageEidNumber ?? "",
            "fullName": storageFullName ?? "",
            "dateOfBirth": DateFormat('yyyy-MM-dd').format(
                DateFormat('dd/MM/yyyy').parse(storageDob ?? "00/00/0000")),
            "nationalityCountryCode": storageNationalityCode ?? "",
            "genderId": storageGender == 'M' ? 1 : 2,
            "expiresOn": DateFormat('yyyy-MM-dd').format(
                DateFormat('dd/MM/yyyy')
                    .parse(storageExpiryDate ?? "00/00/0000")),
            "isReKYC": scannedDetailsArgument.isReKyc,
          },
        );

        log("UploadEid API response -> $response");
      } catch (e) {
        log(e.toString());
      }

      if (response["success"]) {
        // ! Clevertap
        Map<String, dynamic> eidKycEventData = {
          'isEidScanSuccess': true,
          'fullName': storageFullName ?? "",
          'genderId': storageGender ?? "",
          'dob': DateFormat('yyyy-MM-dd').format(
              DateFormat('dd/MM/yyyy').parse(storageDob ?? "00/00/0000")),
          'country': storageNationalityCode ?? "",
          'registrationStatus': 4,
          'deviceId': deviceId,
        };
        CleverTapPlugin.recordEvent(
          "EID Scanned",
          eidKycEventData,
        );

        if (!scannedDetailsArgument.isReKyc) {
          MyGetProfileData.getProfileData();
        }
        if (context.mounted) {
          if (scannedDetailsArgument.isReKyc) {
            Navigator.pushNamed(
              context,
              Routes.errorSuccess,
              // (routes) => false,
              arguments: ErrorArgumentModel(
                hasSecondaryButton: false,
                iconPath: ImageConstants.checkCircleOutlined,
                title: "Your Scan is Complete",
                message: scannedDetailsArgument.isReKyc
                    ? "Great job! You've completed your ReKYC. Please login to continue."
                    : "Great job! You have successfully completed your Re-KYC.",
                buttonText:
                    scannedDetailsArgument.isReKyc ? "Login" : "Continue",
                onTap: () {
                  if (scannedDetailsArgument.isReKyc) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.loginUserId,
                      (route) => false,
                      arguments: StoriesArgumentModel(
                        isBiometric: persistBiometric!,
                      ).toMap(),
                    );
                  } else {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.dashboard,
                      (routes) => false,
                      arguments: DashboardArgumentModel(
                        onboardingState: scannedDetailsArgument.isReKyc
                            ? onboardingState
                            : 8,
                      ).toMap(),
                    );
                  }
                },
                buttonTextSecondary: "",
                onTapSecondary: () {},
              ).toMap(),
            );
          } else {
            await storage.write(key: "stepsCompleted", value: 4.toString());
            storageStepsCompleted =
                int.parse(await storage.read(key: "stepsCompleted") ?? "0");

            if (context.mounted) {
              Navigator.pushNamed(
                context,
                Routes.errorSuccess,
                arguments: ErrorArgumentModel(
                  hasSecondaryButton: false,
                  iconPath: ImageConstants.checkCircleOutlined,
                  title: "Your verification process is complete!",
                  message:
                      "Please proceed to continue",
                  buttonText: "Proceed",
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, Routes.applicationAddress);
                  },
                  buttonTextSecondary: "",
                  onTapSecondary: () {},
                ).toMap(),
              );
            }
          }
        }
      } else {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return CustomDialog(
                svgAssetPath: ImageConstants.warning,
                title: "Error",
                message: response["message"],
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
        log("Upload EID API error -> ${response["message"]}");
      }

      isFaceScanning = false;
      showButtonBloc.add(ShowButtonEvent(show: isFaceScanning));
    } else {
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return CustomDialog(
              svgAssetPath: ImageConstants.warning,
              title: "Selfie Match Failed",
              message:
                  "Your selfie does not match with the photo from your scanned document",
              auxWidget: SolidButton(
                onTap: () {
                  isFaceScanning = false;
                  showButtonBloc.add(ShowButtonEvent(show: isFaceScanning));
                  Navigator.pop(context);
                },
                text: "Go back",
                color: Colors.white,
                fontColor: AppColors.dark100,
                boxShadow: [BoxShadows.primary],
              ),
              actionWidget: GradientButton(
                onTap: () {
                  Navigator.pop(context);
                  liveliness();
                },
                text: "Retake Selfie",
              ),
            );
          },
        );
      }
    }
  }

  matchfaces() async {
    // log("matchfaces executing");
    regula.MatchFacesRequest request = regula.MatchFacesRequest();
    request.images = [image1, image2];
    var value = await regula.FaceSDK.matchFaces(jsonEncode(request));
    var response = regula.MatchFacesResponse.fromJson(json.decode(value));
    var str = await regula.FaceSDK.matchFacesSimilarityThresholdSplit(
        jsonEncode(response!.results), 0.8);
    regula.MatchFacesSimilarityThresholdSplit? split =
        regula.MatchFacesSimilarityThresholdSplit.fromJson(json.decode(str));
    // log("matched faces -> ${split!.matchedFaces}");
    photoMatchScore = split!.matchedFaces.isNotEmpty
        ? (split.matchedFaces[0]!.similarity! * 100)
        : 0;
    await storage.write(
        key: "photoMatchScore", value: photoMatchScore.toString());
    storagePhotoMatchScore =
        double.parse(await storage.read(key: "photoMatchScore") ?? "");

    log("photoMatchScore -> $photoMatchScore");
    log("storagePhotoMatchScore -> $storagePhotoMatchScore");
  }

  void promptWrongSideScan() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Scanning Error",
          message: "Please scan the front side first.",
          actionWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
            },
            text: "Try Again",
          ),
        );
      },
    );
  }

  void promptScanError(String docType) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Scanning Error",
          message:
              "There was an error while scanning your $docType. Please try again.",
          actionWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
            },
            text: "Try Again",
          ),
        );
      },
    );
  }

  static String cleanupBase64Image(String? base64Image) {
    base64Image = base64Image?.replaceAll("image/png;", "");
    base64Image = base64Image?.replaceAll("base64", "");
    base64Image = base64Image?.replaceAll(",;", "");
    base64Image = base64Image?.replaceAll(",", "");
    base64Image = base64Image?.replaceAll("\n", "");

    return base64Image ?? "";
  }

  void promptEIDScanFault() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Scanning Error",
          message: "Unable to scan the two sides properly",
          actionWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
            },
            text: "Try Again",
          ),
        );
      },
    );
  }

  void promptEIDSidesDifferent() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Scanning Error",
          message:
              "It appears that you are trying to scan two different EIDs. Please use the same EID for front and back side.",
          actionWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
            },
            text: "Try Again",
          ),
        );
      },
    );
  }

  void promptScanBothSides() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Scanning Error",
          message: "Please scan both the sides of your EID.",
          actionWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
            },
            text: "Try Again",
          ),
        );
      },
    );
  }

  void promptWrongIDType() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Scanning Error",
          message: "Wrong ID type used. Please use your Emirates ID only.",
          actionWidget: GradientButton(
            onTap: () {
              Navigator.pop(context);
            },
            text: "Try Again",
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    eventChannel
        .receiveBroadcastStream()
        .listen(
          (jsonString) => handleEIDCompletion(
            DocumentReaderCompletion.fromJson(
              json.decode(jsonString),
            )!,
          ),
        )
        .cancel();
    super.dispose();
  }
}
