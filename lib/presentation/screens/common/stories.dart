import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_stories/flutter_stories.dart';
import 'package:investnation/data/models/arguments/registration.dart';
import 'package:investnation/data/models/arguments/stories.dart';
import 'package:investnation/presentation/routers/routes.dart';
import 'package:investnation/presentation/widgets/core/gradient_button.dart';
import 'package:investnation/presentation/widgets/core/loader_row.dart';
import 'package:investnation/presentation/widgets/core/solid_button.dart';
import 'package:investnation/utils/constants/dimensions.dart';
import 'package:investnation/utils/constants/images.dart';
import 'package:investnation/utils/constants/local_storage.dart';
import 'package:investnation/utils/constants/padding.dart';
import 'package:investnation/utils/constants/sizebox.dart';
import 'package:investnation/utils/constants/textstyles.dart';
import 'package:investnation/utils/helpers/prompt_exit.dart';

class StoriesPage extends StatefulWidget {
  const StoriesPage({super.key});

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  List images = [
    Image.asset(ImageConstants.onboarding1, fit: BoxFit.fill),
    Image.asset(ImageConstants.onboarding2, fit: BoxFit.fill),
    Image.asset(ImageConstants.onboarding3, fit: BoxFit.fill),
  ];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //     statusBarIconBrightness: Brightness.light
    //     //color set to transperent or set your own color
    //     ));
  }

  void onGetStarted() {
    Navigator.pushNamed(
      context,
      Routes.registration,
      arguments: RegistrationArgumentModel(
        isInitial: true,
        isUpdateCorpEmail: false,
      ).toMap(),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        PromptExit.promptUser(context, true);
      },
      child: AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemStatusBarContrastEnforced: true,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            toolbarHeight: 10,
            elevation: 0,
          ),
          body: Stack(
            children: [
              CupertinoPageScaffold(
                child: Story(
                  momentCount: 3,
                  momentDurationGetter: (index) => const Duration(seconds: 5),
                  momentBuilder: (context, index) => images[index],
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top +
                    (30 / Dimensions.designHeight).h,
                child: SizedBox(
                  width: 100.w,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: (PaddingConstants.horizontalPadding /
                                Dimensions.designWidth)
                            .w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.loginUserId,
                                  arguments: StoriesArgumentModel(
                                          isBiometric: persistBiometric!)
                                      .toMap(),
                                );
                              },
                              child: Text(
                                "Login", // make this login from backend when the backend will be ready
                                style: TextStyles.primaryBold.copyWith(
                                  fontSize: (20 / Dimensions.designWidth).w,
                                ),
                              ),
                            ),
                            const SizeBox(width: 10),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: SizedBox(
                  width: 100.w,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: (PaddingConstants.horizontalPadding /
                                Dimensions.designHeight)
                            .w),
                    child: Column(
                      children: [
                        GradientButton(
                          onTap: onGetStarted,
                          text: "Get Started",
                          auxWidget:
                              isLoading ? const LoaderRow() : const SizeBox(),
                        ),
                        const SizeBox(height: 16),
                        SolidButton(
                          onTap: () async {
                            Navigator.pushNamed(
                                context, Routes.exploreDashboard);
                            // Navigator.pushNamed(
                            //     context, Routes.applicationAddress);
                            // await login();
                            // if (context.mounted) {
                            //   Navigator.pushNamed(context, Routes.riskProfiling, arguments: PreRiskProfileArgumentModel(
                            //   isInitial: true,
                            // ).toMap());
                            // }
                            // Navigator.pushNamed(
                            //   context,
                            //   Routes.verifyMobile,
                            //   arguments: VerifyMobileArgumentModel(
                            //     isBusiness: false,
                            //     isUpdate: false,
                            //     isReKyc: false,
                            //   ).toMap(),
                            // );
                          },
                          text: "Explore as a Guest",
                          color: const Color.fromARGB(51, 53, 53, 53),
                          fontColor: Colors.white,
                        ),

                        SizeBox(
                          height: MediaQuery.paddingOf(context).bottom +
                              PaddingConstants.bottomPadding,
                        ), //Make relavant change form backend with text
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
