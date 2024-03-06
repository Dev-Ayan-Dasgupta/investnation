import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_document_reader_api/document_reader.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class VerificationInitializingScreen extends StatefulWidget {
  const VerificationInitializingScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<VerificationInitializingScreen> createState() =>
      _VerificationInitializingScreenState();
}

class _VerificationInitializingScreenState
    extends State<VerificationInitializingScreen> {
  String status = "Downloading Database";

  String progressValue = "0";

  late VerificationInitializationArgumentModel
      verificationInitializationArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    initPlatformState();

    const EventChannel('flutter_document_reader_api/event/database_progress')
        .receiveBroadcastStream()
        .listen(
      (progress) {
        log("DB Progress -> $progress");
        setState(
          () {
            progressValue = progress;
          },
        );
      },
    );
  }

  void argumentInitialization() {
    verificationInitializationArgument =
        VerificationInitializationArgumentModel.fromMap(
            widget.argument as dynamic ?? {});
  }

  Future<void> initPlatformState() async {
    var prepareDatabase = await DocumentReader.prepareDatabase("ARE");
    log("prepareDatabase -> $prepareDatabase");
    setState(() {
      status = "Initializing";
    });
    ByteData byteData = await rootBundle.load("assets/regula.license");
    var documentReaderInitialization = await DocumentReader.initializeReader({
      "license": base64.encode(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes)),
      "delayedNNLoad": true,
    });
    log("documentReaderInitialization -> $documentReaderInitialization");
    setState(() {
      status = "Ready";
    });

    if (context.mounted) {
      Navigator.pushReplacementNamed(
        context,
        Routes.eidExplanation,
        arguments: VerificationInitializationArgumentModel(
          isReKyc: verificationInitializationArgument.isReKyc,
        ).toMap(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: (50 / Dimensions.designWidth).w,
              percent: double.parse(progressValue) / 100,
              lineWidth: 5,
              backgroundColor: AppColors.dark30,
              progressColor: AppColors.primary100,
              circularStrokeCap: CircularStrokeCap.round,
              center: Text(
                "$progressValue%",
                style: TextStyles.primaryMedium.copyWith(
                  fontSize: (14 / Dimensions.designWidth).w,
                  color: AppColors.dark80,
                ),
              ),
            ),
            const SizeBox(height: 20),
            Text(
              double.parse(progressValue) < 25
                  ? "Hang tight..."
                  : double.parse(progressValue) < 50
                      ? "Just a few seconds..."
                      : double.parse(progressValue) < 75
                          ? "Getting things ready..."
                          : "Almost there...",
              style: TextStyles.primaryMedium.copyWith(
                fontSize: (14 / Dimensions.designWidth).w,
                color: AppColors.dark80,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
