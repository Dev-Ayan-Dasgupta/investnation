import 'dart:io';

import 'package:flutter/material.dart';
import 'package:investnation/utils/constants/index.dart';

class FooterPadding extends StatelessWidget {
  const FooterPadding({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return SizeBox(height: MediaQuery.paddingOf(context).bottom);
    } else {
      return SizeBox(height: 16 + MediaQuery.paddingOf(context).bottom);
    }
  }
}
