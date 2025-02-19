import 'package:flutter/material.dart';
import '../../../resources/resources.dart';
import '../../../services/secure_storage_service.dart';
import '../../../utils/_utils.dart';
import '../../travelersPages/main_travelers_page.dart';
import '../../travelersPages/tutorial/tutorial_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
      setState(() {});
    });
    //controller.repeat(reverse: true);
    _checkFirstLaunch();
    super.initState();
  }

  Future<void> _checkFirstLaunch() async {
    if (await SecureStorageService.readIsFirstLaunch() == null) {
      SecureStorageService.saveIsFirstLaunch('true');
      navigateTo(context, (_) => TutorialPage(mainTravelersPage: MainTravelersPage(initialPage: 0)));
    } else {
      navigateTo(context, (_) => MainTravelersPage(initialPage: 0,));
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xffedd8be), AppResources.colorWhite],
          )
      ),
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.traveler_profile_created_text,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: AppResources.colorGray100),
              ),
              SizedBox(height: ResponsiveSize.calculateHeight(73, context)),
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
    );
  }
}
