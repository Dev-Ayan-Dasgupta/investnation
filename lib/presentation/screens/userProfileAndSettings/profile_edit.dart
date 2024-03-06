// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/widgets/core/appBar/index.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({
    Key? key,
    this.argument,
  }) : super(key: key);

  final Object? argument;

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late DashboardArgumentModel dashboardArgumentModel;

  @override
  void initState() {
    super.initState();
    argumentInitialization();
  }

  void argumentInitialization() {
    dashboardArgumentModel =
        DashboardArgumentModel.fromMap(widget.argument as dynamic ?? {});
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
              "Profile",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.dark100,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 30),
            Text(
              "Personal Details",
              style: TextStyles.primaryMedium.copyWith(
                color: AppColors.dark80,
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 10),
            Container(
              padding: EdgeInsets.all(
                  (PaddingConstants.horizontalPadding / Dimensions.designWidth)
                      .w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular((10 / Dimensions.designWidth).w),
                ),
                color: AppColors.dark5,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Name",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark80,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      Text(
                        profileName ?? "",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark100,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                    ],
                  ),
                  const SizeBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Date of Birth",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark80,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      Text(
                        DateFormat('dd MMMM yyyy')
                            .format(DateTime.parse(profileDoB ?? "1900-01-01")),
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark100,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizeBox(height: 20),
            Text(
              "Contact Details",
              style: TextStyles.primaryMedium.copyWith(
                color: const Color.fromRGBO(9, 9, 9, 0.7),
                fontSize: (16 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 10),
            Container(
              padding: EdgeInsets.all(
                  (PaddingConstants.horizontalPadding / Dimensions.designWidth)
                      .w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular((10 / Dimensions.designWidth).w),
                ),
                color: AppColors.dark5,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Primary Email ID",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark80,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      SizedBox(
                        width: 50.w,
                        child: Text(
                          profilePrimaryEmailId ?? "",
                          style: TextStyles.primaryMedium.copyWith(
                            color: AppColors.dark100,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const SizeBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Secondary Email ID",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark80,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      storageSecondaryEmail == null ||
                              storageSecondaryEmail == ""
                          ? InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.secondaryEmail,
                                  arguments: DashboardArgumentModel(
                                    onboardingState:
                                        dashboardArgumentModel.onboardingState,
                                  ).toMap(),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(80)),
                                  border: Border.all(
                                      width: 0.5, color: AppColors.dark50),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Add",
                                      style: TextStyles.primaryBold.copyWith(
                                        fontSize: 12,
                                        color: AppColors.dark80,
                                      ),
                                    ),
                                    const SizeBox(width: 5),
                                    const Icon(
                                      Icons.add,
                                      color: AppColors.dark80,
                                      size: 12,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 40.w,
                                  child: Text(
                                    storageSecondaryEmail ?? "",
                                    style: TextStyles.primaryMedium.copyWith(
                                      color: AppColors.dark100,
                                      fontSize: (16 / Dimensions.designWidth).w,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                const SizeBox(width: 10),
                                InkWell(
                                  onTap: () async {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.secondaryEmail,
                                      arguments: DashboardArgumentModel(
                                        onboardingState: dashboardArgumentModel
                                            .onboardingState,
                                      ).toMap(),
                                    );
                                  },
                                  child: SvgPicture.asset(
                                    ImageConstants.pencil,
                                    width: (18 / Dimensions.designWidth).w,
                                    height: (18 / Dimensions.designWidth).w,
                                    colorFilter: const ColorFilter.mode(
                                      AppColors.primary100,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                  const SizeBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Mobile Number",
                        style: TextStyles.primaryMedium.copyWith(
                          color: AppColors.dark80,
                          fontSize: (16 / Dimensions.designWidth).w,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            profileMobileNumber ?? "",
                            style: TextStyles.primaryMedium.copyWith(
                              color: AppColors.dark100,
                              fontSize: (16 / Dimensions.designWidth).w,
                            ),
                          ),
                          const SizeBox(width: 10),
                          InkWell(
                            onTap: () async {
                              if (dashboardArgumentModel.onboardingState >= 2) {
                                if (mobileChangesToday > 0) {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.errorSuccess,
                                    arguments: ErrorArgumentModel(
                                      hasSecondaryButton: false,
                                      iconPath: ImageConstants.errorOutlined,
                                      title: "Limit exceeded!",
                                      message:
                                          "Mobile number cannot be changed more than once a day",
                                      buttonText: labels[347]["labelText"],
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      buttonTextSecondary: "",
                                      onTapSecondary: () {},
                                    ).toMap(),
                                  );
                                } else {
                                  if (context.mounted) {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.verifyMobile,
                                      arguments: VerifyMobileArgumentModel(
                                        isBusiness: false,
                                        isUpdate: true,
                                        isReKyc: false,
                                      ).toMap(),
                                    );
                                  }
                                }
                              }
                            },
                            child: SvgPicture.asset(
                              ImageConstants.pencil,
                              width: (18 / Dimensions.designWidth).w,
                              height: (18 / Dimensions.designWidth).w,
                              colorFilter: ColorFilter.mode(
                                dashboardArgumentModel.onboardingState >= 2
                                    ? AppColors.primary100
                                    : AppColors.dark50,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
