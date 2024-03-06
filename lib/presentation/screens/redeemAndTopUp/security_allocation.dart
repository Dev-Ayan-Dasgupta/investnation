// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:investnation/data/models/index.dart';

import 'package:investnation/presentation/screens/investmentCreation/index.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:investnation/utils/helpers/index.dart';

class SecurityAllocationScreen extends StatefulWidget {
  const SecurityAllocationScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<SecurityAllocationScreen> createState() =>
      _SecurityAllocationScreenState();
}

class _SecurityAllocationScreenState extends State<SecurityAllocationScreen> {
  late SecurityAllocationArgumentModel securityAllocationArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
  }

  void argumentInitialization() {
    securityAllocationArgument = SecurityAllocationArgumentModel.fromMap(
        widget.argument as dynamic ?? {});
  }

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
              portfolioBeingInvested.toTitleCase(),
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.dark100,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 20),
            Text(
              "Security allocation",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.dark100,
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            securityAllocationArgument.securityDetails[index]
                                ["security"],
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.dark80,
                              fontSize: (14 / Dimensions.designWidth).w,
                            ),
                          ),
                          Text(
                            "${(securityAllocationArgument.securityDetails[index]["percentage"] * 100).toStringAsFixed(2)}%",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.dark80,
                              fontSize: (14 / Dimensions.designWidth).w,
                            ),
                          ),
                        ],
                      ),
                      const SizeBox(height: 5),
                      Stack(
                        children: [
                          Container(
                            width: 100.w,
                            height: (16 / Dimensions.designHeight).h,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                              color: AppColors.dark10,
                            ),
                          ),
                          Container(
                            width: MediaQuery.sizeOf(context).width *
                                0.009 *
                                (securityAllocationArgument
                                        .securityDetails[index]["percentage"] *
                                    100),
                            height: (16 / Dimensions.designHeight).h,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                              color: AppColors.primary100,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizeBox(height: 20);
                },
                itemCount: securityAllocationArgument.securityDetails.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
