import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/main.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/screens/common/index.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';

class InvestNationInterceptor implements InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    request.headers.addAll({'Content-Type': 'application/json; charset=UTF-8'});
    request.headers.addAll(
        {'Authorization': 'Bearer ${await storage.read(key: "token")}'});
    request.headers.addAll({
      'Device-Type': deviceType,
      'App-Version': appVersion,
      'Device-Id': deviceId ?? "",
      'Device-Name': deviceName.replaceAll("’", ""),
      'Build-Number': buildNumber,
    });

    return request;
  }

  @override
  Future<BaseResponse> interceptResponse(
      {required BaseResponse response}) async {
    if (response.statusCode == 401) {
      isUserLoggedIn = false;
      // Show session timeout message
      showAdaptiveDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return CustomDialog(
            svgAssetPath: ImageConstants.warning,
            title: "Session Timeout",
            message:
                "Your current session has timed out, please login again to continue.",
            actionWidget: GradientButton(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.loginUserId,
                  (route) => false,
                  arguments: StoriesArgumentModel(
                    isBiometric: persistBiometric!,
                  ).toMap(),
                );
              },
              text: "Login",
            ),
          );
        },
      );
      // And take the customer to the login screen
    } else if (response.statusCode == 500) {
      showAdaptiveDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return CustomDialog(
            svgAssetPath: ImageConstants.warning,
            title: "Status code 500",
            message: "System failure, something went wrong.",
            actionWidget: GradientButton(
              onTap: () {
                Navigator.pop(context);
              },
              text: "Okay",
            ),
          );
        },
      );
    } else if (response.statusCode != 200 && response.statusCode != 401) {
      // Something went wrong from the API system
      showAdaptiveDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return CustomDialog(
            svgAssetPath: ImageConstants.warning,
            title: "System Failure",
            message: "System failure, something went wrong.",
            actionWidget: GradientButton(
              onTap: () {
                Navigator.pop(context);
              },
              text: "Login",
            ),
          );
        },
      );
      // Show System Error message
    }
    return response;
  }

  @override
  Future<bool> shouldInterceptRequest() async {
    return true;
  }

  @override
  Future<bool> shouldInterceptResponse() async {
    return true;
  }
}
