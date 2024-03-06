import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:investnation/bloc/showButton/index.dart';
import 'package:investnation/data/models/widgets/index.dart';
import 'package:investnation/presentation/screens/common/index.dart';
import 'package:investnation/presentation/widgets/core/appBar/index.dart';
import 'package:investnation/presentation/widgets/profile/index.dart';
import 'package:investnation/utils/constants/index.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  List<CustomExpansionTileModel> faqList = [];

  @override
  void initState() {
    super.initState();
    populateFaqs();
  }

  void populateFaqs() {
    faqList.clear();
    for (var faq in faqs) {
      faqList.add(
        CustomExpansionTileModel(
          isExpanded: false,
          titleText: faq["question"],
          childrenText: faq["answer"],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ShowButtonBloc showButtonBloc = context.read<ShowButtonBloc>();
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
              "FAQs",
              style: TextStyles.primaryBold.copyWith(
                color: AppColors.dark100,
                fontSize: (28 / Dimensions.designWidth).w,
              ),
            ),
            const SizeBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: faqList.length,
                itemBuilder: (context, index) {
                  CustomExpansionTileModel item = faqList[index];
                  return BlocBuilder<ShowButtonBloc, ShowButtonState>(
                    builder: (context, state) {
                      return CustomExpansionTile(
                        index: index,
                        isExpanded: item.isExpanded,
                        titleText: item.titleText,
                        childrenText: item.childrenText,
                        onExpansionChanged: (val) {
                          item.isExpanded = val;
                          showButtonBloc.add(
                            ShowButtonEvent(show: item.isExpanded),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
