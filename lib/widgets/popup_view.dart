import 'package:flutter/material.dart';
import 'package:info_popup/info_popup.dart';

import '../resources/resources.dart';

class PopupView extends StatelessWidget {
  final String contentTitle;

  const PopupView({super.key, required this.contentTitle});

  @override
  Widget build(BuildContext context) {
    return InfoPopupWidget(
      enableHighlight: true,
      contentTitle:contentTitle,
      contentTheme: InfoPopupContentTheme(
          infoTextAlign: TextAlign.start,
          infoTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w400,
          ),
          infoContainerBackgroundColor: AppResources.colorDark,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          contentBorderRadius: BorderRadius.circular(8)
      ),
      child: const Icon(Icons.help_outline, size: 24),
    );
  }
}
