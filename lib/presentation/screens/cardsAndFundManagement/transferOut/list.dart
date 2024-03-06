// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:investnation/bloc/index.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/data/repository/accounts/index.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/screens/common/index.dart';
import 'package:investnation/presentation/widgets/cardsAndFundManagement/index.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/presentation/widgets/shimmers/index.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:investnation/utils/helpers/index.dart';

class TransferOutListScreen extends StatefulWidget {
  const TransferOutListScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<TransferOutListScreen> createState() => _TransferOutListScreenState();
}

class _TransferOutListScreenState extends State<TransferOutListScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool isShowAll = true;

  List recipients = [];
  List filteredRecipients = [];

  Map<String, dynamic> getBeneficiariesApiResult = {};
  bool isFetchingBeneficiaries = false;

  bool isDeleteingBeneficiary = false;

  bool showCancel = false;

  late BeneficiaryListArgumentModel beneficaryListArgument;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
    getBeneficiaries();
  }

  void argumentInitialization() {
    beneficaryListArgument =
        BeneficiaryListArgumentModel.fromMap(widget.argument as dynamic ?? {});
  }

  Future<void> getBeneficiaries() async {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();

    isFetchingBeneficiaries = true;
    showButtonBloc.add(ShowButtonEvent(show: isFetchingBeneficiaries));

    try {
      getBeneficiariesApiResult = await MapBeneficiaries.mapBeneficiaries();
    } catch (e) {
      log(e.toString());
    }

    log("getBeneficiariesApiResult -> $getBeneficiariesApiResult");

    if (getBeneficiariesApiResult["timeout"] != null) {
      if (context.mounted) {
        ApiException.apiException(context);
      }
    } else {
      if (getBeneficiariesApiResult["success"]) {
        recipients.clear();
        for (var beneficiary in getBeneficiariesApiResult["data"]) {
          recipients.add(beneficiary);
        }
      } else {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return CustomDialog(
                svgAssetPath: ImageConstants.warning,
                title: "Sorry!",
                message: getBeneficiariesApiResult["message"] ??
                    "There was an error fetching your beneficiary details, please try again after some time.",
                actionWidget: GradientButton(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  text: labels[346]["labelText"],
                ),
              );
            },
          );
        }
      }
    }

    isFetchingBeneficiaries = false;
    showButtonBloc.add(ShowButtonEvent(show: isFetchingBeneficiaries));
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
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    beneficaryListArgument.isBeneficiary
                        ? "My Beneficiaries"
                        : "Transfer Out",
                    style: TextStyles.primaryBold.copyWith(
                      color: AppColors.dark100,
                      fontSize: (28 / Dimensions.designWidth).w,
                    ),
                  ),
                  const SizeBox(height: 20),
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                      return CustomSearchBox(
                        hintText: "Search",
                        controller: _searchController,
                        onChanged: onSearchChanged,
                        onSearchCancelled: () {
                          onSearchCancelled(_searchController.text);
                          _searchController.clear();
                        },
                        showCancel: showCancel,
                      );
                    },
                  ),
                  const SizeBox(height: 20),
                  BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                      return Ternary(
                        condition: isFetchingBeneficiaries,
                        truthy: Expanded(
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              return const ShimmerSelectRecipientTile();
                            },
                            separatorBuilder: (context, index) {
                              return const SizeBox(height: 10);
                            },
                            itemCount: 12,
                          ),
                        ),
                        falsy: Expanded(
                          child: ListView.separated(
                            itemCount: isShowAll
                                ? recipients.length
                                : filteredRecipients.length,
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                            itemBuilder: (context, index) {
                              return TransferListTile(
                                onTap: () {},
                                onDelete: (context) {
                                  deleteBeneficiary(isShowAll
                                      ? recipients[index]["accountNumber"]
                                      : filteredRecipients[index]
                                          ["accountNumber"]);
                                },
                                onTransfer: (context) {
                                  benBankName = isShowAll
                                      ? recipients[index]["benBankName"]
                                      : filteredRecipients[index]
                                          ["benBankName"];
                                  benCustomerName = isShowAll
                                      ? recipients[index]["name"]
                                      : filteredRecipients[index]["name"];
                                  benSwiftCodeRef = isShowAll
                                      ? recipients[index]["swiftReference"]
                                      : filteredRecipients[index]
                                          ["swiftReference"];
                                  benBankCode = isShowAll
                                      ? recipients[index]["benBankCode"]
                                      : filteredRecipients[index]
                                          ["benBankCode"];
                                  benIdExpiryDate = isShowAll
                                      ? recipients[index]["benIdExpiryDate"]
                                      : filteredRecipients[index]
                                          ["benIdExpiryDate"];
                                  benSwiftCode = isShowAll
                                      ? recipients[index]["benSwiftCodeText"]
                                      : filteredRecipients[index]
                                          ["benSwiftCodeText"];
                                  Navigator.pushNamed(
                                    context,
                                    Routes.transferOutDetails,
                                    arguments: TransferOutArgumentModel(
                                      recipientname: isShowAll
                                          ? recipients[index]["name"]
                                          : filteredRecipients[index]["name"],
                                      iban: isShowAll
                                          ? recipients[index]["accountNumber"]
                                          : filteredRecipients[index]
                                              ["accountNumber"],
                                    ).toMap(),
                                  );
                                },
                                name: isShowAll
                                    ? recipients[index]["name"]
                                    : filteredRecipients[index]["name"],
                                ibanNumber: isShowAll
                                    ? recipients[index]["accountNumber"]
                                    : filteredRecipients[index]
                                        ["accountNumber"],
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Column(
              children: [
                GradientButton(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.transferOutBeneficiary);
                  },
                  text: "Add New",
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

  void onSearchChanged(String p0) {
    final ShowButtonBloc recipientListBloc = context.read<ShowButtonBloc>();
    searchRecipient(recipients, p0);
    if (p0.isEmpty) {
      isShowAll = true;
      showCancel = false;
    } else {
      isShowAll = false;
      showCancel = true;
    }
    recipientListBloc.add(ShowButtonEvent(show: isShowAll));
  }

  void onSearchCancelled(String p0) {
    final ShowButtonBloc recipientListBloc = context.read<ShowButtonBloc>();
    // searchRecipient(recipients, p0);
    p0 = "";
    if (p0.isEmpty) {
      isShowAll = true;
      showCancel = false;
    } else {
      isShowAll = false;
      showCancel = true;
    }
    recipientListBloc.add(ShowButtonEvent(show: isShowAll));
  }

  void searchRecipient(List recipients, String matcher) {
    filteredRecipients.clear();
    for (var recipient in recipients) {
      if (recipient["name"].toLowerCase().contains(matcher.toLowerCase())) {
        filteredRecipients.add(recipient);
      }
    }
  }

  void deleteBeneficiary(String accNo) {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "Are you sure?",
          message: "You are about to permanently delete this beneficiary",
          auxWidget: GradientButton(
            onTap: () async {
              if (!isDeleteingBeneficiary) {
                final ShowButtonBloc showButtonBloc =
                    context.read<ShowButtonBloc>();
                isDeleteingBeneficiary = true;
                showButtonBloc
                    .add(ShowButtonEvent(show: isDeleteingBeneficiary));

                log("Delete Beneficiary Api req -> ${{}}");
                try {
                  var deleteBenApiResult =
                      await MapDeleteBeneficiary.mapDeleteBeneficiary(
                    {
                      "AccountNumber": accNo,
                    },
                  );
                  log("deleteBenApiResult -> $deleteBenApiResult");
                  if (deleteBenApiResult["success"]) {
                    // ! Clevertap Event

                    Map<String, dynamic> deleteBeneficiaryEventData = {
                      'email': profilePrimaryEmailId,
                      'beneficiaryDeleted': true,
                      'iban': accNo,
                      'deviceId': deviceId,
                    };
                    CleverTapPlugin.recordEvent(
                      "Beneficiary Deleted",
                      deleteBeneficiaryEventData,
                    );
                    if (context.mounted) {
                      Navigator.pop(context);
                      getBeneficiaries();
                    }
                  } else {
                    if (context.mounted) {
                      showAdaptiveDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                            svgAssetPath: ImageConstants.warning,
                            title: "Sorry",
                            message: deleteBenApiResult["message"] ??
                                "There was an error in deleting the beneficiary, please try again later.",
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
                } catch (e) {
                  log(e.toString());
                }

                isDeleteingBeneficiary = false;
                showButtonBloc
                    .add(ShowButtonEvent(show: isDeleteingBeneficiary));
              }
            },
            text: "Yes, Proceed",
            auxWidget:
                isDeleteingBeneficiary ? const LoaderRow() : const SizeBox(),
          ),
          actionWidget: SolidButton(
            color: Colors.white,
            boxShadow: [BoxShadows.primary],
            fontColor: AppColors.dark100,
            onTap: () {
              Navigator.pop(context);
            },
            text: "No, Cancel",
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
