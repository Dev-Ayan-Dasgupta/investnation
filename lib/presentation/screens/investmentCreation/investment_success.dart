import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:investnation/data/models/arguments/investment_details.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/utils/constants/images.dart';

class InvestmentSuccessScreen extends StatefulWidget {
  const InvestmentSuccessScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<InvestmentSuccessScreen> createState() =>
      _InvestmentSuccessScreenState();
}

class _InvestmentSuccessScreenState extends State<InvestmentSuccessScreen> {
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
        Routes.transactionDetails,
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
