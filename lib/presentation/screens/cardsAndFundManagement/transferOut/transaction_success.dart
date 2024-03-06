// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/utils/constants/images.dart';

class TransactionSuccessScreen extends StatefulWidget {
  const TransactionSuccessScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<TransactionSuccessScreen> createState() =>
      _TransactionSuccessScreenState();
}

class _TransactionSuccessScreenState extends State<TransactionSuccessScreen> {
  late TransactionDetailsArgumentModel transactionDetailsArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    navigate();
  }

  void argumentInitialization() {
    transactionDetailsArgument = TransactionDetailsArgumentModel.fromMap(
        widget.argument as dynamic ?? {});
  }

  Future<void> navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.transferTransactionDetails,
        (route) => false,
        arguments: TransactionDetailsArgumentModel(
          date: transactionDetailsArgument.date,
          status: transactionDetailsArgument.status,
          referenceNumber: transactionDetailsArgument.referenceNumber,
          amount: transactionDetailsArgument.amount,
          beneficiaryName: transactionDetailsArgument.beneficiaryName,
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
