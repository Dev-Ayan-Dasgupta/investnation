// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:investnation/data/models/index.dart';
import 'package:investnation/utils/helpers/index.dart';
import 'package:share_plus/share_plus.dart';

import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';

class TransactionDetails extends StatefulWidget {
  const TransactionDetails({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  List<DetailsTileModel> investmentDetails = [];

  late InvestmentDetailsArgumentModel investmentDetailsArgumentModel;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    initializeDetails();
  }

  void argumentInitialization() {
    investmentDetailsArgumentModel = InvestmentDetailsArgumentModel.fromMap(
        widget.argument as dynamic ?? {});
  }

  void initializeDetails() {
    investmentDetails = [
      DetailsTileModel(
        key: "Date",
        value: investmentDetailsArgumentModel.date,
      ),
      DetailsTileModel(
        key: "Status",
        value: investmentDetailsArgumentModel.status,
      ),
      DetailsTileModel(
        key: "Transaction Type",
        value: investmentDetailsArgumentModel.transactionType,
      ),
      DetailsTileModel(
        key: "Portfolio",
        value: investmentDetailsArgumentModel.portfolio,
      ),
      DetailsTileModel(
        key: "Reference Number",
        value: investmentDetailsArgumentModel.referenceNumber ?? "null",
      ),
      DetailsTileModel(
        key: "Amount",
        value: NumberFormatter.numberFormat(double.parse(
            investmentDetailsArgumentModel.amount
                .replaceAll(',', '')
                .split(' ')
                .last)),
      ),
      DetailsTileModel(
        key: "Total",
        value: NumberFormatter.numberFormat(double.parse(
            investmentDetailsArgumentModel.amount
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
                  horizontal: (16 / Dimensions.designWidth).w,
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
                      "Transaction Details",
                      style: TextStyles.primaryBold.copyWith(
                        color: AppColors.dark100,
                        fontSize: (28 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 20),
                    Text(
                      "Thank you!",
                      style: TextStyles.primaryMedium.copyWith(
                        color: AppColors.primary80,
                        fontSize: (20 / Dimensions.designWidth).w,
                      ),
                    ),
                    const SizeBox(height: 20),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          DetailsTile(
                            length: investmentDetails.length,
                            details: investmentDetails,
                            boldIndices: const [6],
                          ),
                          const SizeBox(height: 20),
                          InkWell(
                            onTap: () {
                              Share.share(
                                  "${investmentDetails[0].key}: ${investmentDetails[0].value}\n${investmentDetails[1].key}: ${investmentDetails[1].value}\n${investmentDetails[2].key}: ${investmentDetails[2].value}\n${investmentDetails[3].key}: ${investmentDetails[3].value}\n${investmentDetails[4].key}: ${investmentDetails[4].value}\n${investmentDetails[5].key}: ${investmentDetails[5].value}\n${investmentDetails[6].key}: ${investmentDetails[6].value}\n");
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.share_rounded,
                                  size: (16 / Dimensions.designWidth).w,
                                ),
                                const SizeBox(width: 5),
                                Text(
                                  "Share Details",
                                  style: TextStyles.primaryMedium.copyWith(
                                    color: AppColors.dark100,
                                    fontSize: (16 / Dimensions.designWidth).w,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizeBox(height: 20),
                          Text(
                            labels[159]["labelText"],
                            style:
                                TextStyles.primaryMedium.copyWith(fontSize: 14),
                          ),
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
