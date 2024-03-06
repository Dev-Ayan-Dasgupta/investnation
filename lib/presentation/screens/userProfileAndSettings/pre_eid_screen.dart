import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';

class PreEidScreen extends StatefulWidget {
  const PreEidScreen({Key? key}) : super(key: key);

  @override
  State<PreEidScreen> createState() => _PreEidScreenState();
}

class _PreEidScreenState extends State<PreEidScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Emirates ID",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.dark100,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 20),
            Container(
              width: 100.w,
              padding: EdgeInsets.all(
                (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular((10 / Dimensions.designWidth).w)),
                color: AppColors.dark5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Emirates ID",
                        style: TextStyles.primaryBold.copyWith(
                          color: AppColors.dark100,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                      ),
                      const SizeBox(height: 8),
                      Text(
                        storageEidNumber ?? "",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark80,
                          fontSize: (12 / Dimensions.designWidth).w,
                        ),
                      ),
                    ],
                  ),
                  GradientButton(
                    fontSize: (12 / Dimensions.designWidth).w,
                    width: 20.w,
                    height: (25 / Dimensions.designHeight).h,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.verificationInit,
                        arguments: VerificationInitializationArgumentModel(
                          isReKyc: true,
                        ).toMap(),
                      );
                    },
                    text: "Update",
                    auxWidget: const Icon(
                      Icons.refresh_rounded,
                      size: 15,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
