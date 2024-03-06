// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/data/models/widgets/index.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:investnation/utils/helpers/index.dart';
import 'package:share_plus/share_plus.dart';

class TransferTransactionDetailsScreen extends StatefulWidget {
  const TransferTransactionDetailsScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<TransferTransactionDetailsScreen> createState() =>
      _TransferTransactionDetailsScreenState();
}

class _TransferTransactionDetailsScreenState
    extends State<TransferTransactionDetailsScreen> {
  List<DetailsTileModel> details = [];

  late TransactionDetailsArgumentModel transactionDetailsArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    initializeDetails();
  }

  void argumentInitialization() {
    transactionDetailsArgument = TransactionDetailsArgumentModel.fromMap(
        widget.argument as dynamic ?? {});
  }

  void initializeDetails() {
    details = [
      DetailsTileModel(
        key: "Date",
        value: transactionDetailsArgument.date,
      ),
      DetailsTileModel(
        key: "Status",
        value: transactionDetailsArgument.status,
      ),
      DetailsTileModel(
        key: "Reference Number",
        value: transactionDetailsArgument.referenceNumber,
      ),
      DetailsTileModel(
        key: "Amount",
        value: NumberFormatter.numberFormat(double.parse(
            transactionDetailsArgument.amount
                .replaceAll(',', '')
                .split(' ')
                .last)),
      ),
      DetailsTileModel(
        key: "Transferred to",
        value: transactionDetailsArgument.beneficiaryName,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                      color: AppColors.primary100,
                      fontSize: (18 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        DetailsTile(
                          length: details.length,
                          details: details,
                          boldIndices: const [],
                        ),
                        const SizeBox(height: 20),
                        InkWell(
                          onTap: () {
                            Share.share(
                                "${details[0].key}: ${details[0].value}\n${details[1].key}: ${details[1].value}\n${details[2].key}: ${details[2].value}\n${details[3].key}: ${details[3].value}\n${details[4].key}: ${details[4].value}");
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.share_rounded,
                                size: (14 / Dimensions.designWidth).w,
                                color: AppColors.dark100,
                              ),
                              const SizeBox(width: 5),
                              Text(
                                "Share Details",
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.dark100,
                                  fontSize: (14 / Dimensions.designWidth).w,
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
            )
          ],
        ),
      ),
    );
  }
}
