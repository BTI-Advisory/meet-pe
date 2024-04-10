import 'package:flutter/material.dart';
import 'package:info_popup/info_popup.dart';

import '../resources/resources.dart';

class PopupView extends StatelessWidget {
  final String contentTitle;
  final IconData iconData;

  const PopupView({super.key, required this.contentTitle, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return InfoPopupWidget(
      enableHighlight: true,
      contentTitle:contentTitle,
      contentTheme: InfoPopupContentTheme(
          infoTextAlign: TextAlign.start,
          infoTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w400,
          ),
          infoContainerBackgroundColor: AppResources.colorDark,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          contentBorderRadius: BorderRadius.circular(8)
      ),
      child: Icon(iconData, size: 17),
    );
  }
}
