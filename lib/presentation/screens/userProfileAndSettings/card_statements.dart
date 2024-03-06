import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:investnation/bloc/showButton/index.dart';
import 'package:investnation/data/repository/accounts/index.dart';
import 'package:investnation/presentation/screens/common/index.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class StatementsScreen extends StatefulWidget {
  const StatementsScreen({super.key});

  @override
  State<StatementsScreen> createState() => _StatementsScreenState();
}

class _StatementsScreenState extends State<StatementsScreen> {
  List<String> items = ["Last Month", "Last 3 Months", "Last 6 Months"];

  bool isPeriodSelected = false;

  String? selectedValue;
  int selectedIndex = -1;

  bool isFetchingPdf = false;

  String base64String = "";

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
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Card Statements",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.dark100,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Text(
                    "You can generate a PDF statement for the selected period.",
                    style: TextStyles.primaryMedium.copyWith(
                      color: AppColors.dark80,
                      fontSize: (14 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "Period",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark100,
                          fontSize: (14 / Dimensions.designWidth).w,
                        ),
                      ),
                      const Asterisk(),
                    ],
                  ),
                  const SizeBox(height: 10),
                  // BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  //   builder: (context, state) {
                  //     return CustomDropDown(
                  //       items: items,
                  //       title: "Select from the list",
                  //       value: selectedValue,
                  //       onChanged: (value) {
                  //         final ShowButtonBloc showButtonBloc =
                  //             context.read<ShowButtonBloc>();
                  //         selectedValue = value as String;
                  //         isPeriodSelected = true;
                  //         showButtonBloc
                  //             .add(ShowButtonEvent(show: isPeriodSelected));
                  //       },
                  //     );
                  //   },
                  // ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: (16 / Dimensions.designWidth).w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizeBox(height: 15),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 50,
                                      height: 4,
                                      decoration: const BoxDecoration(
                                        color: AppColors.dark50,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                    ),
                                  ),
                                  const SizeBox(height: 15),
                                  Text(
                                    "Please select an option",
                                    style: TextStyles.primaryBold.copyWith(
                                      color: AppColors.dark100,
                                    ),
                                  ),
                                  const SizeBox(height: 15),
                                  Expanded(
                                    child: ListView.separated(
                                      separatorBuilder: (context, index) {
                                        return const SizeBox(height: 10);
                                      },
                                      itemCount: 3,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = index;
                                            });

                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: (16 /
                                                        Dimensions.designWidth)
                                                    .w),
                                            width: 100.w,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              border: Border.all(
                                                  color: AppColors.dark50,
                                                  width: 1),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  items[index],
                                                  style: TextStyles
                                                      .primaryMedium
                                                      .copyWith(
                                                    color: AppColors.dark80,
                                                  ),
                                                ),
                                                selectedIndex != index
                                                    ? Container(
                                                        width: (20 /
                                                                Dimensions
                                                                    .designWidth)
                                                            .w,
                                                        height: (20 /
                                                                Dimensions
                                                                    .designWidth)
                                                            .w,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                              color: AppColors
                                                                  .dark30,
                                                              width: 0.5),
                                                        ),
                                                      )
                                                    : SvgPicture.asset(
                                                        ImageConstants
                                                            .checkCircle,
                                                        width: (20 /
                                                                Dimensions
                                                                    .designWidth)
                                                            .w,
                                                        height: (20 /
                                                                Dimensions
                                                                    .designWidth)
                                                            .w,
                                                        colorFilter:
                                                            const ColorFilter
                                                                .mode(
                                                          AppColors.green100,
                                                          BlendMode.srcIn,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: (16 / Dimensions.designWidth).w),
                      width: 100.w,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: AppColors.dark80, width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedIndex == -1
                                ? "Please select an option"
                                : items[selectedIndex],
                            style: TextStyles.primaryMedium.copyWith(
                              color: selectedIndex == -1
                                  ? AppColors.dark80
                                  : AppColors.dark100,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_drop_down_rounded,
                            size: 30,
                            color: AppColors.dark80,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                BlocBuilder<ShowButtonBloc, ShowButtonState>(
                  builder: (context, state) {
                    if (selectedIndex != -1) {
                      return GradientButton(
                        onTap: () async {
                          if (!isFetchingPdf) {
                            setState(() {
                              isFetchingPdf = true;
                            });

                            log("getCustomerAccountPdf Req -> ${{
                              "accountNumber": cardNumber,
                              "startDate": DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now().subtract(Duration(
                                      days: selectedIndex == 0
                                          ? 30
                                          : selectedIndex == 1
                                              ? 90
                                              : 180))),
                              "endDate": DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now()),
                            }}");
                            var getCustomerAccountPdfRes =
                                await MapPDFCustomerAccountStatement
                                    .mapPDFCustomerAccountStatement({
                              "accountNumber": cardNumber,
                              "startDate": DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now().subtract(Duration(
                                      days: selectedIndex == 0
                                          ? 30
                                          : selectedIndex == 1
                                              ? 90
                                              : 180))),
                              "endDate": DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now()),
                            });
                            log("getCustomerAccountPdfRes -> $getCustomerAccountPdfRes");

                            if (getCustomerAccountPdfRes["success"]) {
                              base64String = getCustomerAccountPdfRes["data"][0]
                                      ["base64Data"] ??
                                  "";

                              if (base64String.isEmpty) {
                                if (context.mounted) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomDialog(
                                        svgAssetPath: ImageConstants.warning,
                                        title: "No Transactions",
                                        message:
                                            "You do not have any transactions for the period selected.",
                                        actionWidget: GradientButton(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          text: labels[346]["labelText"],
                                        ),
                                      );
                                    },
                                  );
                                }
                              } else {
                                openFile(base64String);
                              }
                            } else {
                              if (context.mounted) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CustomDialog(
                                      svgAssetPath: ImageConstants.warning,
                                      title: "Sorry",
                                      message:
                                          "There was an error fetching the PDF statement, please try again later.",
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
                            }

                            setState(() {
                              isFetchingPdf = false;
                            });
                          }
                        },
                        text: "Download Now",
                        auxWidget:
                            isFetchingPdf ? const LoaderRow() : const SizeBox(),
                      );
                    } else {
                      return SolidButton(onTap: () {}, text: "Download Now");
                    }
                  },
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
    );
  }

  void openFile(String base64String) async {
    Uint8List bytes = base64.decode(base64String);
    File file;

    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory() //! FOR Android
        : await getApplicationDocumentsDirectory(); //! FOR iOS

    file = File(
        "${directory?.path}/InvestNation_${cardNumber}_${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: selectedIndex == 0 ? 30 : selectedIndex == 1 ? 90 : 180)))}_${DateFormat('yyyy-MM-dd').format(DateTime.now())}.pdf");
    await file.writeAsBytes(bytes.buffer.asUint8List());
    await OpenFile.open(
        "${directory?.path}/InvestNation_${cardNumber}_${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: selectedIndex == 0 ? 30 : selectedIndex == 1 ? 90 : 180)))}_${DateFormat('yyyy-MM-dd').format(DateTime.now())}.pdf");
  }
}
