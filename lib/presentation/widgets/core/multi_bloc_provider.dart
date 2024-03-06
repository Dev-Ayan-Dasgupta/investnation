import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investnation/bloc/index.dart';
import 'package:investnation/data/models/arguments/index.dart';
import 'package:investnation/main.dart';
import 'package:investnation/presentation/routers/app_router.dart';

import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';

class CustomMultiBlocProvider extends StatefulWidget {
  const CustomMultiBlocProvider({
    super.key,
    required this.appRouter,
  });

  final AppRouter appRouter;

  @override
  State<CustomMultiBlocProvider> createState() =>
      _CustomMultiBlocProviderState();
}

Timer? _timer;

bool isUserLoggedIn = false;

class _CustomMultiBlocProviderState extends State<CustomMultiBlocProvider> {
  @override
  void initState() {
    super.initState();

    // initEnvironment();
    _initializeTimer();
  }

  // Future<void> initEnvironment() async {
  //   try {
  //     // ? environment string
  //     String environment = const String.fromEnvironment(
  //       'ENVIRONMENT',
  //       defaultValue: Environment.dev,
  //     );

  //     // ? load environment file
  //     await dotenv.load(
  //       fileName:
  //           // '.env.development',
  //           Environment.getName(environment),
  //     );

  //     // ? initialize the config
  //     await Environment().initConfig(environment);
  //   } catch (_) {}
  // }

  void _initializeTimer() {
    _timer = Timer.periodic(Duration(seconds: appSessionTimeout), (timer) {
      log("Tick -> ${_timer?.tick}");
      _logOutUser();
    });
  }

  void _logOutUser() async {
    log("logout called - session timer cancelled");

    _timer?.cancel();

    setState(() {
      if (isUserLoggedIn) forceLogout = true;
    });

    await storage.delete(key: "token");
  }

  // You'll probably want to wrap this function in a debounce
  void _handleUserInteraction([_]) {
    log("User interaction - restarting session timer");
    _timer?.cancel();
    _initializeTimer();
  }

  void navToHomePage() {
    log("Navigation to home page called");

    showAdaptiveDialog(
      context: navigatorKey.currentState!.overlay!.context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          svgAssetPath: ImageConstants.warning,
          title: "App Session Timeout",
          message: "Your app's session has timed out.\nPlease login again.",
          actionWidget: GradientButton(
            onTap: () {
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                Routes.loginUserId,
                arguments: StoriesArgumentModel(isBiometric: persistBiometric!)
                    .toMap(),
                (Route<dynamic> route) => false,
              );
              // _initializeTimer();
              forceLogout = false;
            },
            text: labels[205]["labelText"],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (forceLogout && isUserLoggedIn) {
      forceLogout = false;
      isUserLoggedIn = false;
      navToHomePage();
      log("User was logged in and therefore asked to login again because of session timeout");
    }

    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    return MultiBlocProvider(
      providers: [
        BlocProvider<EmailValidationBloc>(
          create: (context) => EmailValidationBloc(),
        ),
        BlocProvider<ShowButtonBloc>(
          create: (context) => ShowButtonBloc(),
        ),
        BlocProvider<PinputErrorBloc>(
          create: (context) => PinputErrorBloc(),
        ),
        BlocProvider<OTPTimerBloc>(
          create: (context) => OTPTimerBloc(),
        ),
        BlocProvider<TabbarBloc>(
          create: (context) => TabbarBloc(),
        ),
        BlocProvider<ShowPasswordBloc>(
          create: (context) => ShowPasswordBloc(),
        ),
        BlocProvider<MatchPasswordBloc>(
          create: (context) => MatchPasswordBloc(),
        ),
        BlocProvider<CheckBoxBloc>(
          create: (context) => CheckBoxBloc(),
        ),
        BlocProvider<CreatePasswordBloc>(
          create: (context) => CreatePasswordBloc(),
        ),
        BlocProvider<CriteriaBloc>(
          create: (context) => CriteriaBloc(),
        ),
        BlocProvider<DropdownSelectedBloc>(
          create: (context) => DropdownSelectedBloc(),
        ),
        BlocProvider<ApplicationTaxBloc>(
          create: (context) => ApplicationTaxBloc(),
        ),
        BlocProvider<ApplicationCrsBloc>(
          create: (context) => ApplicationCrsBloc(),
        ),
        BlocProvider<ButtonFocussedBloc>(
          create: (context) => ButtonFocussedBloc(),
        ),
        BlocProvider<ScrollDirectionBloc>(
          create: (context) => ScrollDirectionBloc(),
        ),
      ],
      child: Listener(
        onPointerDown: _handleUserInteraction,
        onPointerMove: _handleUserInteraction,
        onPointerUp: _handleUserInteraction,
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            _handleUserInteraction;
          },
          behavior: HitTestBehavior.opaque,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'InvestNation',
            navigatorKey: navigatorKey,
            theme: ThemeData(
              useMaterial3: false,
              colorSchemeSeed: AppColors.primary100,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              appBarTheme: const AppBarTheme(
                color: Colors.transparent,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark,
                  statusBarBrightness: Brightness.light,
                ),
              ),
              scaffoldBackgroundColor: Colors.white,
            ),
            initialRoute: Routes.splash,
            onGenerateRoute: widget.appRouter.onGenerateRoute,
          ),
        ),
      ),
    );
  }
}
