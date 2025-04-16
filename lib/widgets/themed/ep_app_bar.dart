import 'package:flutter/material.dart';
import 'package:meet_pe/utils/_utils.dart';
import 'package:meet_pe/utils/responsive_size.dart';

import '../../resources/resources.dart';

class EpAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EpAppBar(
      {Key? key, this.title, this.backButtonColor, this.actions = const []})
      : super(key: key);

  final String? title;
  final Color? backButtonColor;
  final List<Widget> actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final showBackButton = context.canPop;
    return SafeArea(
      child: Container(
        height: preferredSize.height,
        padding: AppResources.paddingPage.copyWith(
            left: 0, top: 0, bottom: 0, right: 5),
        child: Stack(
          children: [
            // Back button
            if (showBackButton)
              Align(
                alignment: Alignment.centerLeft,
                child: BackButton(color: backButtonColor),
              ),

            // Title
            if (title != null)
              Center(
                child: Text(
                  title!,
                  style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400, color: AppResources.colorDark),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: actions,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
