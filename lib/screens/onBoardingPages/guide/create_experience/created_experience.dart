import 'package:flutter/material.dart';
import 'package:meet_pe/screens/guideProfilPages/main_guide_page.dart';

import '../../../../resources/resources.dart';
import '../../../../utils/_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreatedExperience extends StatefulWidget {
  const CreatedExperience({super.key});

  @override
  State<CreatedExperience> createState() => _CreatedExperienceState();
}

class _CreatedExperienceState extends State<CreatedExperience> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addListener(() {
      setState(() {});
    });
    //controller.repeat(reverse: true);
    controller.forward().whenComplete(() => navigateTo(context, (_) => MainGuidePage(initialPage: 0,)));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFEDD8BE), AppResources.colorWhite],
            )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.watch_later_outlined,
                color: AppResources.colorVitamine,
                size: 55,
              ),
              SizedBox(height: ResponsiveSize.calculateHeight(27, context)),
              Text(
                AppLocalizations.of(context)!.experience_created_text,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: AppResources.colorGray100, fontSize: 32),
              ),
              SizedBox(height: ResponsiveSize.calculateHeight(16, context)),
              Text(
                AppLocalizations.of(context)!.experience_created_desc_text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: ResponsiveSize.calculateHeight(30, context)),
              Container(
                width: ResponsiveSize.calculateWidth(108, context),
                child: LinearProgressIndicator(
                  minHeight: 7,
                  value: controller.value,
                  semanticsLabel: 'Linear progress indicator',
                  backgroundColor: AppResources.colorImputStroke,
                  color: AppResources.colorVitamine,
                  borderRadius: BorderRadius.circular(3.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

