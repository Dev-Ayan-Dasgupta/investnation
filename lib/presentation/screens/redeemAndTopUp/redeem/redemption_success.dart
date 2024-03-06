import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/utils/constants/index.dart';

class RedemptionSuccessScreen extends StatefulWidget {
  const RedemptionSuccessScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<RedemptionSuccessScreen> createState() =>
      _RedemptionSuccessScreenState();
}

class _RedemptionSuccessScreenState extends State<RedemptionSuccessScreen> {
  late InvestmentDetailsArgumentModel investmentDetailsArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    navigate();
  }

  void argumentInitialization() {
    investmentDetailsArgument = InvestmentDetailsArgumentModel.fromMap(
        widget.argument as dynamic ?? {});
  }

  Future<void> navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.redemptionDetails,
        (route) => false,
        arguments: InvestmentDetailsArgumentModel(
          date: investmentDetailsArgument.date,
          status: investmentDetailsArgument.status,
          referenceNumber: investmentDetailsArgument.referenceNumber ?? "null",
          transactionType: investmentDetailsArgument.transactionType,
          portfolio: investmentDetailsArgument.portfolio,
          amount: investmentDetailsArgument.amount,
        ).toMap(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(ImageConstants.checkCircleOutlined),
      ),
    );
  }
}
