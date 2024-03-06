import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:investnation/bloc/showButton/index.dart';
import 'package:investnation/data/models/widgets/notifications_tile.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/presentation/widgets/notifications/index.dart';
import 'package:investnation/presentation/widgets/shimmers/index.dart';
import 'package:investnation/utils/constants/index.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

List<int> notificationTypes = [1, 2, 3, 6, 9, 12, 15, 18, 21, 24, 27];
List<int> checkerNotificationTypes = [3, 6, 9, 12, 15, 18, 21, 24, 27];

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationsTileModel> notifications = [];

  bool isFetchingData = false;

  Map<String, dynamic> getNotificationsApiResult = {};

  @override
  void initState() {
    super.initState();
    // getNotifications();
  }

  // Future<void> getNotifications() async {
  //   try {
  //     final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();

  //     getNotificationsApiResult = await MapGetNotifications.mapGetNotifications(
  //       token ?? "",
  //     );
  //     log("Get notificatons api response -> $getNotificationsApiResult");

  //     if (getNotificationsApiResult["success"]) {
  //       notifications.clear();
  //       for (var i = 0;
  //           i < getNotificationsApiResult["notifications"].length;
  //           i++) {
  //         notifications.add(
  //           NotificationsTileModel(
  //             title: getNotificationsApiResult["notifications"][i]["subject"],
  //             message: getNotificationsApiResult["notifications"][i]["content"],
  //             dateTime: DateFormat('EEEE, MMM dd, yyyy, hh:mm').format(
  //                 DateTime.parse(getNotificationsApiResult["notifications"][i]
  //                     ["createdOn"])),
  //             isActionable: getNotificationsApiResult["notifications"][i]
  //                 ["isActionable"],
  //             widget: notificationTypes.contains(
  //                     getNotificationsApiResult["notifications"][i]
  //                         ["notificationType"])
  //                 ? GradientButton(
  //                     width: 25.w,
  //                     height: (30 / Dimensions.designHeight).h,
  //                     fontSize: (12 / Dimensions.designWidth).w,
  //                     borderRadius: (5 / Dimensions.designWidth).w,
  //                     onTap: () {
  //                       if (checkerNotificationTypes.contains(
  //                           getNotificationsApiResult["notifications"][i]
  //                               ["notificationType"])) {
  //                         Navigator.pushNamed(
  //                           context,
  //                           Routes.workflowDetails,
  //                           arguments: WorkflowArgumentModel(
  //                             reference:
  //                                 getNotificationsApiResult["notifications"][i]
  //                                     ["additionalInformation"],
  //                             workflowType:
  //                                 getNotificationsApiResult["notifications"][i]
  //                                     ["notificationType"],
  //                           ).toMap(),
  //                         );
  //                       } else if (getNotificationsApiResult["notifications"][i]
  //                               ["notificationType"] ==
  //                           1) {
  //                         Navigator.pushNamed(
  //                           context,
  //                           Routes.verificationInitializing,
  //                           arguments: VerificationInitializationArgumentModel(
  //                             isReKyc: true,
  //                           ).toMap(),
  //                         );
  //                       }
  //                     },
  //                     text: getNotificationsApiResult["notifications"][i]
  //                                     ["notificationType"] ==
  //                                 1 ||
  //                             getNotificationsApiResult["notifications"][i]
  //                                     ["notificationType"] ==
  //                                 2
  //                         ? "Update"
  //                         : "View Request",
  //                   )
  //                 : const SizeBox(),
  //           ),
  //         );
  //       }
  //     } else {
  //       if (context.mounted) {
  //         showDialog(
  //           context: context,
  //           builder: (context) {
  //             return CustomDialog(
  //               svgAssetPath: ImageConstants.warning,
  //               title: "Error",
  //               message:
  //                   "There was an error in fetching your notifications, please try again later",
  //               actionWidget: GradientButton(
  //                 onTap: () {
  //                   Navigator.pop(context);
  //                   Navigator.pop(context);
  //                 },
  //                 text: labels[346]["labelText"],
  //               ),
  //             );
  //           },
  //         );
  //       }
  //     }

  //     isFetchingData = false;
  //     showButtonBloc.add(ShowButtonEvent(show: isFetchingData));
  //   } catch (_) {
  //     rethrow;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white100,
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
              "Notifications",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.dark100,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            BlocBuilder<ShowButtonBloc, ShowButtonState>(
              builder: (context, state) {
                return SizeBox(height: notifications.isEmpty ? 15 : 15);
              },
            ),
            BlocBuilder<ShowButtonBloc, ShowButtonState>(
              builder: (context, state) {
                return Ternary(
                  condition: isFetchingData,
                  truthy: Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return const SizeBox(height: 10);
                      },
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return const ShimmerNotificationTile();
                      },
                    ),
                  ),
                  falsy: Ternary(
                    condition: notifications.isEmpty,
                    truthy: Column(
                      children: [
                        const SizeBox(height: 225),
                        SvgPicture.asset(
                          ImageConstants.notificationsBlank,
                          width: (67.33 / Dimensions.designWidth).w,
                          height: (84.17 / Dimensions.designHeight).h,
                        ),
                        const SizeBox(height: 20),
                        Text(
                          "You're all caught up",
                          style: TextStyles.primary.copyWith(
                            color: const Color(0XFF414141),
                            fontSize: (18 / Dimensions.designWidth).w,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizeBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: (34 / Dimensions.designWidth).w),
                          child: Text(
                            "Check back later for promotions and recommendations to keep your account up to date",
                            style: TextStyles.primaryMedium.copyWith(
                              color: const Color(0XFF414141),
                              fontSize: (18 / Dimensions.designWidth).w,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    falsy: Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          NotificationsTileModel item = notifications[index];
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    index == notifications.length - 1 ? 15 : 0),
                            child: NotificationsTile(
                              title: item.title,
                              message: item.message,
                              dateTime: item.dateTime,
                              widget: item.widget,
                              isActionable: item.isActionable,
                              onPressed: (context) async {
                                // if (!isFetchingData && !(item.isActionable)) {
                                //   final ShowButtonBloc showButtonBloc =
                                //       context.read<ShowButtonBloc>();
                                //   isFetchingData = true;
                                //   showButtonBloc.add(
                                //       ShowButtonEvent(show: isFetchingData));
                                //   try {
                                //     log("Remove Notification request -> ${{
                                //       "notificationId":
                                //           getNotificationsApiResult[
                                //                   "notifications"][index]
                                //               ["notificationId"],
                                //     }}");
                                //     var remNotiApiResult =
                                //         await MapRemoveNotifications
                                //             .mapRemoveNotifications(
                                //       {
                                //         "notificationId":
                                //             getNotificationsApiResult[
                                //                     "notifications"][index]
                                //                 ["notificationId"],
                                //       },
                                //       token ?? "",
                                //     );
                                //     log("Remove Notification API response -> $remNotiApiResult");

                                //     if (remNotiApiResult["success"]) {
                                //       await getNotifications();
                                //     } else {
                                //       if (context.mounted) {
                                //         showDialog(
                                //           context: context,
                                //           builder: (context) {
                                //             return CustomDialog(
                                //               svgAssetPath:
                                //                   ImageConstants.warning,
                                //               title: "Error",
                                //               message:
                                //                   "There was an error in removing this notification, please try again later.",
                                //               actionWidget: GradientButton(
                                //                 onTap: () {
                                //                   Navigator.pop(context);
                                //                   Navigator.pop(context);
                                //                 },
                                //                 text: labels[347]["labelText"],
                                //               ),
                                //             );
                                //           },
                                //         );
                                //       }
                                //     }
                                //   } catch (_) {
                                //     showDialog(
                                //       context: context,
                                //       builder: (context) {
                                //         return CustomDialog(
                                //           svgAssetPath: ImageConstants.warning,
                                //           title: "Oops",
                                //           message:
                                //               "Something went wrong, please try again later.",
                                //           actionWidget: GradientButton(
                                //             onTap: () {
                                //               Navigator.pop(context);
                                //               Navigator.pop(context);
                                //             },
                                //             text: labels[347]["labelText"],
                                //           ),
                                //         );
                                //       },
                                //     );
                                //   }

                                //   isFetchingData = false;
                                //   showButtonBloc.add(
                                //       ShowButtonEvent(show: isFetchingData));
                                // }
                              },
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizeBox(height: 10);
                        },
                        itemCount: notifications.length,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
