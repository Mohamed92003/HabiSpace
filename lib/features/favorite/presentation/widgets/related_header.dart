import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import '../../../../core/utils/app_texts.dart';

class RelatedHeader extends StatelessWidget {
  const RelatedHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Text(
        AppTexts.moreInThisCategory.tr(),
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
