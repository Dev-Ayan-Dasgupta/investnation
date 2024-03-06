import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:investnation/presentation/widgets/core/index.dart';
import 'package:investnation/utils/constants/index.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowFaqSmile {
  static void showFaqSmile(BuildContext context) {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (PaddingConstants.horizontalPadding /
                        Dimensions.designWidth)
                    .w,
                vertical: PaddingConstants.bottomPadding +
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Container(
                width: 100.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular((24 / Dimensions.designWidth).w),
                  ),
                  color: AppColors.dark5,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: (22 / Dimensions.designWidth).w,
                        vertical: (22 / Dimensions.designHeight).h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          ImageConstants.smile,
                          width: (111 / Dimensions.designHeight).h,
                          height: (111 / Dimensions.designHeight).h,
                        ),
                        const SizeBox(height: 20),
                        Text(
                          "Hey there!",
                          style: TextStyles.primaryBold.copyWith(
                            color: Colors.black,
                            fontSize: (20 / Dimensions.designWidth).w,
                          ),
                        ),
                        const SizeBox(height: 10),
                        Text(
                          "Please check FAQs.\nIf you do not find your Query,",
                          style: TextStyles.primaryMedium.copyWith(
                            color: AppColors.grey81,
                            fontSize: (16 / Dimensions.designWidth).w,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Contact us on our ",
                              style: TextStyles.primaryMedium.copyWith(
                                color: AppColors.grey81,
                                fontSize: (16 / Dimensions.designWidth).w,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            InkWell(
                              onTap: () {
                                launchUrl(
                                  Uri.parse(
                                    //'https://wa.me/971504596103' //you use this url also
                                    'whatsapp://send?phone=971504596103', //put your number here
                                  ),
                                );
                              },
                              child: Text(
                                "Whatsapp",
                                style: TextStyles.primaryMedium.copyWith(
                                  color: AppColors.primary80,
                                  fontSize: (16 / Dimensions.designWidth).w,
                                  decoration: TextDecoration.underline,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        const SizeBox(height: 20),
                        GradientButton(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          text: "Close",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
