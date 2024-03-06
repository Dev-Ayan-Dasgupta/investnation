import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/screens/common/index.dart';
import 'package:investnation/presentation/widgets/core/appBar/index.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/presentation/widgets/core/topic_tile.dart';
import 'package:investnation/utils/constants/index.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
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
              "Documents",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.dark100,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 20),
            Text(
              "Statements",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.dark80,
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 10),
            TopicTile(
              onTap: () {
                Navigator.pushNamed(context, Routes.statements);
              },
              iconPath: ImageConstants.add,
              text: "Card Statements",
              leading: const SizeBox(),
              fontSize: 14,
            ),
            const SizeBox(height: 10),
            TopicTile(
              onTap: () {
                if (accountInvestments.isNotEmpty) {
                  Navigator.pushNamed(context, Routes.portfolioStatements);
                } else {
                  showAdaptiveDialog(
                    context: context,
                    builder: (context) {
                      return CustomDialog(
                        svgAssetPath: ImageConstants.warning,
                        title: "Sorry",
                        message: "You currently do not have any investments.",
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
              },
              iconPath: ImageConstants.add,
              text: "Portfolio Statements",
              leading: const SizeBox(),
              fontSize: 14,
            ),
            const SizeBox(height: 20),
            Text(
              "Agreements",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.dark80,
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 10),
            TopicTile(
              onTap: () {
                Navigator.pushNamed(context, Routes.termsAndConditions);
              },
              iconPath: ImageConstants.add,
              text: "Agreements and Terms & Conditions",
              leading: const SizeBox(),
              fontSize: 14,
              trailingIcon: ImageConstants.download,
            ),
          ],
        ),
      ),
    );
  }
}
