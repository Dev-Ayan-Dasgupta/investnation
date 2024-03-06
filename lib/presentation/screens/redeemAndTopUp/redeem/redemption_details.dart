// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:investnation/data/models/index.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:investnation/utils/helpers/index.dart';
import 'package:share_plus/share_plus.dart';

class RedemptionDetailsScreen extends StatefulWidget {
  const RedemptionDetailsScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<RedemptionDetailsScreen> createState() =>
      _RedemptionDetailsScreenState();
}

class _RedemptionDetailsScreenState extends State<RedemptionDetailsScreen> {
  List<DetailsTileModel> redemptionDetails = [];

  late InvestmentDetailsArgumentModel redemptionDetailsArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    initializeDetails();
  }

  void argumentInitialization() {
    redemptionDetailsArgument = InvestmentDetailsArgumentModel.fromMap(
        widget.argument as dynamic ?? {});
  }

  void initializeDetails() {
    redemptionDetails = [
      DetailsTileModel(
        key: "Date",
        value: redemptionDetailsArgument.date,
      ),
      DetailsTileModel(
        key: "Status",
        value: redemptionDetailsArgument.status,
      ),
      DetailsTileModel(
        key: "Transaction Type",
        value: redemptionDetailsArgument.transactionType,
      ),
      DetailsTileModel(
        key: "Portfolio",
        value: redemptionDetailsArgument.portfolio,
      ),
      DetailsTileModel(
        key: "Reference Number",
        value: redemptionDetailsArgument.referenceNumber ?? "null",
      ),
      // DetailsTileModel(
      //   key: "Amount",
      //   value: redemptionDetailsArgument.amount,
      // ),
      DetailsTileModel(
        key: "Total",
        value: NumberFormatter.numberFormat(double.parse(
            redemptionDetailsArgument.amount
                .replaceAll(',', '')
                .split(' ')
                .last)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          // leading: const AppBarLeading(),
          actions: [
            InkWell(
              onTap: () {
                ShowFaqSmile.showFaqSmile(context);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: (5 / Dimensions.designWidth).w,
                  vertical: (5 / Dimensions.designWidth).w,
                ),
                child: SvgPicture.asset(ImageConstants.support),
              ),
            ),
            const SizeBox(width: PaddingConstants.horizontalPadding),
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
                      "Redemption Details",
                      style: TextStyles.primaryBold.copyWith(
                        color: AppColors.dark100,
                        fontSize: (28 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 20),
                    Text(
                      "Thank you!",
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.orange100,
                        fontSize: (20 / Dimensions.designWidth).w,
                      ),
                    ),
                    SizeBox(height: (24 / Dimensions.designHeight).h),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          DetailsTile(
                            length: redemptionDetails.length,
                            details: redemptionDetails,
                            boldIndices: const [5],
                          ),
                          const SizeBox(height: 20),
                          InkWell(
                            onTap: () {
                              Share.share(
                                  "${redemptionDetails[0].key}: ${redemptionDetails[0].value}\n${redemptionDetails[1].key}: ${redemptionDetails[1].value}\n${redemptionDetails[2].key}: ${redemptionDetails[2].value}\n${redemptionDetails[3].key}: ${redemptionDetails[3].value}\n${redemptionDetails[4].key}: ${redemptionDetails[4].value}\n${redemptionDetails[5].key}: ${redemptionDetails[5].value}");
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.share_rounded,
                                  size: (24 / Dimensions.designWidth).w,
                                ),
                                const SizeBox(width: 5),
                                Text(
                                  "Share Details",
                                  style: TextStyles.primaryMedium.copyWith(
                                    color: AppColors.black100,
                                    fontSize: (16 / Dimensions.designWidth).w,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizeBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  GradientButton(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.dashboard,
                        (route) => false,
                        arguments: DashboardArgumentModel(
                          onboardingState: 8,
                        ).toMap(),
                      );
                    },
                    text: "Go Home",
                  ),
                  SizeBox(
                    height: PaddingConstants.bottomPadding +
                        MediaQuery.paddingOf(context).bottom,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
