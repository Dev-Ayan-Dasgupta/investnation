// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:investnation/utils/helpers/index.dart';
import 'package:pausable_timer/pausable_timer.dart';

import 'package:investnation/utils/constants/index.dart';

class CustomFlipCard extends StatefulWidget {
  const CustomFlipCard({
    Key? key,
    required this.cardKey,
    required this.cardNumber,
    required this.iban,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvv,
    required this.currentBalance,
  }) : super(key: key);

  final GlobalKey<FlipCardState> cardKey;

  final String cardNumber;
  final String iban;
  final String expiryDate;
  final String cardHolderName;
  final String cvv;
  final double currentBalance;

  @override
  State<CustomFlipCard> createState() => _CustomFlipCardState();
}

class _CustomFlipCardState extends State<CustomFlipCard> {
  bool isTapDown = false;
  int seconds = 0;
  late final PausableTimer _timer;

  @override
  void initState() {
    super.initState();
    /*
    _timer = PausableTimer.periodic(
      const Duration(seconds: 1),
      () {
        seconds++;
        log("seconds -> $seconds");
      },
    ); */
  }

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      flipOnTouch: false,
      onFlipDone: (isFront) async {},
      key: widget.cardKey,
      front: Stack(
        children: [
          Container(
            width: (393 / Dimensions.designWidth).w,
            height: (232 / Dimensions.designHeight).h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular((20 / Dimensions.designWidth).w),
              ),
              // boxShadow: [BoxShadows.primary],
              color: Colors.white,
              image: const DecorationImage(
                image: AssetImage(ImageConstants.cardBase),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            left: (25 / Dimensions.designWidth).w,
            bottom: (20.5 / Dimensions.designHeight).h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "AED ",
                      style: TextStyles.primary.copyWith(
                        fontSize: (24 / Dimensions.designWidth).w,
                        color: AppColors.dark100,
                      ),
                    ),
                    Text(
                      NumberFormatter.numberFormat(widget.currentBalance),
                      style: TextStyles.primaryBold.copyWith(
                        fontSize: (24 / Dimensions.designWidth).w,
                        color: AppColors.dark100,
                      ),
                    ),
                    const SizeBox(width: 10),
                    InkWell(
                      onTap: () {},
                      child: SvgPicture.asset(
                        ImageConstants.refresh,
                        width: (16 / Dimensions.designWidth).w,
                        height: (22 / Dimensions.designHeight).h,
                      ),
                    ),
                  ],
                ),
                const SizeBox(height: 2.5),
                // Text(
                //   "Available Balance",
                //   style: TextStyles.primary.copyWith(
                //     fontSize: (18 / Dimensions.designWidth).w,
                //     color: AppColors.dark100,
                //   ),
                // ),
              ],
            ),
          ),
          Positioned(
            right: (28 / Dimensions.designWidth).w,
            top: (100 / Dimensions.designHeight).h,
            child: SizedBox(
              width: (32 / Dimensions.designWidth).w,
              height: (32 / Dimensions.designWidth).w,
              child: InkWell(
                onTap: () {
                  widget.cardKey.currentState?.toggleCard();
                },
                child: SvgPicture.asset(
                  ImageConstants.flip,
                ),
              ),
            ),
          ),
        ],
      ),
      back: Stack(
        children: [
          Container(
            width: (384 / Dimensions.designWidth).w,
            height: (227.26 / Dimensions.designWidth).w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular((20 / Dimensions.designWidth).w),
              ),
              // boxShadow: [BoxShadows.primary],
              color: Colors.white,
              image: const DecorationImage(
                image: AssetImage(ImageConstants.cardBaseBack),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            left: (24 / Dimensions.designWidth).w,
            top: (25 / Dimensions.designHeight).h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "IBAN",
                          style: TextStyles.primaryMedium.copyWith(
                            fontSize: (14 / Dimensions.designWidth).w,
                            color: AppColors.dark100,
                          ),
                        ),
                        const SizeBox(height: 5),
                        Text(
                          widget.iban,
                          style: TextStyles.primaryMedium.copyWith(
                            fontSize: (16 / Dimensions.designWidth).w,
                            color: AppColors.dark100,
                          ),
                        ),
                      ],
                    ),
                    const SizeBox(width: 5),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(
                            text: widget.iban,
                          ),
                        );
                        Fluttertoast.showToast(
                          msg: "Copied",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        width: 40,
                        height: 40,
                        child: SvgPicture.asset(
                          ImageConstants.clipboard,
                        ),
                      ),
                    ),

                    // const SizeBox(width: 5),
                    // QrImageView(
                    //   data: iban,
                    //   version: QrVersions.auto,
                    //   size: 50.0,
                    // ),
                  ],
                ),
                const SizeBox(height: 32.5),
                Row(
                  children: [
                    Text(
                      FormatCardNumber.formatCardNumber(widget.cardNumber),
                      style: TextStyles.primaryMedium.copyWith(
                        fontSize: (24 / Dimensions.designWidth).w,
                        color: AppColors.dark100,
                      ),
                    ),
                    // const SizeBox(width: 5),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(
                            text: widget.cardNumber,
                          ),
                        );
                        Fluttertoast.showToast(
                          msg: "Copied",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        width: 40,
                        height: 40,
                        child: SvgPicture.asset(
                          ImageConstants.clipboard,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizeBox(height: 27.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Card Holder Name",
                          style: TextStyles.primaryMedium.copyWith(
                            fontSize: (14 / Dimensions.designWidth).w,
                            color: AppColors.dark100,
                          ),
                        ),
                        const SizeBox(height: 5),
                        SizedBox(
                          width: 40.w,
                          child: Text(
                            widget.cardHolderName,
                            style: TextStyles.primaryBold.copyWith(
                              fontSize: (14 / Dimensions.designWidth).w,
                              color: AppColors.dark100,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizeBox(width: 10),
                    Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Valid Through",
                          style: TextStyles.primaryMedium.copyWith(
                            fontSize: (14 / Dimensions.designWidth).w,
                            color: AppColors.dark100,
                          ),
                        ),
                        const SizeBox(height: 5),
                        Text(
                          widget.expiryDate.isNotEmpty
                              ? "${widget.expiryDate.split('-')[1]}/${widget.expiryDate.substring(2, 4)}"
                              : "",
                          style: TextStyles.primaryBold.copyWith(
                            fontSize: (14 / Dimensions.designWidth).w,
                            color: AppColors.dark100,
                          ),
                        ),
                      ],
                    ),
                    const SizeBox(width: 40),
                    Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "CVV",
                          style: TextStyles.primaryMedium.copyWith(
                            fontSize: (14 / Dimensions.designWidth).w,
                            color: AppColors.dark100,
                          ),
                        ),
                        const SizeBox(height: 5),
                        Text(
                          widget.cvv,
                          style: TextStyles.primaryBold.copyWith(
                            fontSize: (14 / Dimensions.designWidth).w,
                            color: AppColors.dark100,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: (28 / Dimensions.designWidth).w,
            top: (32 / Dimensions.designHeight).h,
            child: SizedBox(
              width: (32 / Dimensions.designWidth).w,
              height: (32 / Dimensions.designWidth).w,
              child: InkWell(
                onTap: () {
                  widget.cardKey.currentState?.toggleCard();
                },
                child: SvgPicture.asset(
                  ImageConstants.flip,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
