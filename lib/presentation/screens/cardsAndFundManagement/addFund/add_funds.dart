import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:investnation/presentation/screens/common/index.dart';
import 'package:investnation/presentation/widgets/cardsAndFundManagement/index.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddFundsScreen extends StatefulWidget {
  const AddFundsScreen({super.key});

  @override
  State<AddFundsScreen> createState() => _AddFundsScreenState();
}

class _AddFundsScreenState extends State<AddFundsScreen> {
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
              "Add Funds",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.dark100,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 20),
            Text(
              "Here is your one time AED transfer instructions using the bank of your choice",
              style: TextStyles.primaryMedium.copyWith(
                color: AppColors.dark80,
                fontSize: (14 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 20),
            const AddFundsExplainer(),
            const SizeBox(height: 20),
            Text(
              "Instructions",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.dark100,
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 20),
            Row(
              children: [
                Text(
                  "Step 1:",
                  style: TextStyles.primaryBold.copyWith(
                    color: AppColors.dark100,
                    fontSize: (16 / Dimensions.designWidth).w,
                  ),
                ),
                const SizeBox(width: 10),
                Text(
                  "Log into your bank account",
                  style: TextStyles.primaryMedium.copyWith(
                    color: AppColors.dark80,
                    fontSize: (16 / Dimensions.designWidth).w,
                  ),
                ),
              ],
            ),
            SizeBox(height: (25 / Dimensions.designHeight).h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Step 2:",
                  style: TextStyles.primaryBold.copyWith(
                    color: AppColors.dark100,
                    fontSize: (16 / Dimensions.designWidth).w,
                  ),
                ),
                const SizeBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: "Add ",
                                style: TextStyles.primary.copyWith(
                                  color: AppColors.dark80,
                                  fontSize: (16 / Dimensions.designWidth).w,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "InvestNation ",
                                    style: TextStyles.primaryBold.copyWith(
                                      color: AppColors.dark100,
                                      fontSize: (16 / Dimensions.designWidth).w,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        'as a beneficiary using the information below',
                                    style: TextStyles.primary.copyWith(
                                      color: AppColors.dark80,
                                      fontSize: (16 / Dimensions.designWidth).w,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // const SizeBox(width: 10),
                          // SvgPicture.asset(
                          //   ImageConstants.contentCopy,
                          //   width: (20 / Dimensions.designWidth).w,
                          //   height: (20 / Dimensions.designWidth).w,
                          // ),
                        ],
                      ),
                      SizeBox(height: (20 / Dimensions.designHeight).h),
                      Row(
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: "Beneficiary Name ",
                                style: TextStyles.primaryBold.copyWith(
                                  color: AppColors.dark100,
                                  fontSize: (16 / Dimensions.designWidth).w,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "- InvestNation",
                                    style: TextStyles.primaryMedium.copyWith(
                                      color: AppColors.dark80,
                                      fontSize: (16 / Dimensions.designWidth).w,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizeBox(width: 8),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(
                                const ClipboardData(
                                  text: "InvestNation",
                                ),
                              );
                              Fluttertoast.showToast(
                                msg: "Copied",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );
                            },
                            child: SvgPicture.asset(
                              ImageConstants.contentCopy,
                              width: (20 / Dimensions.designWidth).w,
                              height: (20 / Dimensions.designWidth).w,
                            ),
                          ),
                        ],
                      ),
                      SizeBox(height: (20 / Dimensions.designHeight).h),
                      Row(
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: "Beneficiary IBAN ",
                                style: TextStyles.primaryBold.copyWith(
                                  color: AppColors.dark100,
                                  fontSize: (16 / Dimensions.designWidth).w,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "- $iban",
                                    style: TextStyles.primaryMedium.copyWith(
                                      color: AppColors.dark80,
                                      fontSize: (16 / Dimensions.designWidth).w,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizeBox(width: 8),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: (iban).replaceAll(" ", ""),
                                ),
                              );
                              Fluttertoast.showToast(
                                msg: "Copied",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );
                            },
                            child: SvgPicture.asset(
                              ImageConstants.contentCopy,
                              width: (20 / Dimensions.designWidth).w,
                              height: (20 / Dimensions.designWidth).w,
                            ),
                          ),
                        ],
                      ),
                      SizeBox(height: (20 / Dimensions.designHeight).h),
                      Row(
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: "Beneficiary Address ",
                                style: TextStyles.primaryBold.copyWith(
                                  color: AppColors.dark100,
                                  fontSize: (16 / Dimensions.designWidth).w,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        "- FH Cube,\n842 Hazza Bin Zayed,\nAl Nahyan - Abu Dhabi",
                                    style: TextStyles.primaryMedium.copyWith(
                                      color: AppColors.dark80,
                                      fontSize: (16 / Dimensions.designWidth).w,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizeBox(width: 8),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(
                                const ClipboardData(
                                  text:
                                      "FH Cube, 842 Hazza Bin Zayed, Al Nahyan - Abu Dhabi",
                                ),
                              );
                              Fluttertoast.showToast(
                                msg: "Copied",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );
                            },
                            child: SvgPicture.asset(
                              ImageConstants.contentCopy,
                              width: (20 / Dimensions.designWidth).w,
                              height: (20 / Dimensions.designWidth).w,
                            ),
                          ),
                        ],
                      ),
                      SizeBox(height: (20 / Dimensions.designHeight).h),
                      Row(
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: "Reason for Transfer ",
                                style: TextStyles.primaryBold.copyWith(
                                  color: AppColors.dark100,
                                  fontSize: (16 / Dimensions.designWidth).w,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "- Investments",
                                    style: TextStyles.primaryMedium.copyWith(
                                      color: AppColors.dark80,
                                      fontSize: (16 / Dimensions.designWidth).w,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizeBox(width: 8),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(
                                const ClipboardData(
                                  text: "Investments",
                                ),
                              );
                              Fluttertoast.showToast(
                                msg: "Copied",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );
                            },
                            child: SvgPicture.asset(
                              ImageConstants.contentCopy,
                              width: (20 / Dimensions.designWidth).w,
                              height: (20 / Dimensions.designWidth).w,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizeBox(height: (20 / Dimensions.designHeight).h),
            Text(
              "That's it!",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.dark100,
                fontSize: (14 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 8),
            Text(
              "Once we have received your deposit, we will notify you and invest it in approximately 1-3 business days",
              style: TextStyles.primaryMedium.copyWith(
                color: AppColors.dark80,
                fontSize: (14 / Dimensions.designWidth).w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
