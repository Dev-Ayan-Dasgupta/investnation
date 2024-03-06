import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:investnation/presentation/widgets/cardsAndFundManagement/index.dart';
import 'package:investnation/utils/constants/index.dart';

class PlanBenefitsCard extends StatelessWidget {
  const PlanBenefitsCard({
    Key? key,
    required this.benefitDetails,
  }) : super(key: key);

  final List benefitDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (326 / Dimensions.designWidth).w,
      height: (467 / Dimensions.designHeight).h,
      margin: EdgeInsets.symmetric(
        vertical: (10 / Dimensions.designHeight).h,
      ),
      padding: EdgeInsets.all(
        (PaddingConstants.horizontalPadding / Dimensions.designWidth).w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular((16 / Dimensions.designWidth).w),
        ),
        boxShadow: [
          BoxShadows.primary,
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Benefits",
            style: TextStyles.primaryBold.copyWith(
              color: AppColors.dark100,
              fontSize: (16 / Dimensions.designWidth).w,
            ),
          ),
          // const SizeBox(height: 20),
          // Image.asset('./assets/images/icons/image.png'),
          const SizeBox(height: 10),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return PlanBenefitsExplainerTile(
                  svgName: benefitDetails[index]["icon"],
                  text: benefitDetails[index]["benefitText"],
                );
              },
              separatorBuilder: (context, index) {
                return const SizeBox(height: 10);
              },
              itemCount: benefitDetails.length,
            ),
          ),
          // const AddFundsExplainerTile(
          //   svgName: ImageConstants.accountOpening,
          //   text: "Flat rate for any amount",
          // ),
          // const SizeBox(height: 10),
          // const AddFundsExplainerTile(
          //   svgName: ImageConstants.accountOpening,
          //   text: "3 months lock-in",
          // ),
          // const SizeBox(height: 10),
          // const AddFundsExplainerTile(
          //   svgName: ImageConstants.accountOpening,
          //   text: "No risk",
          // ),
          // const SizeBox(height: 10),
          // const AddFundsExplainerTile(
          //   svgName: ImageConstants.accountOpening,
          //   text: "0.5% management fees p.a.",
          // ),
          // const SizeBox(height: 10),
          // const AddFundsExplainerTile(
          //   svgName: ImageConstants.accountOpening,
          //   text: "No restrictions on withdrawals and transfers",
          // ),
        ],
      ),
    );
  }
}
