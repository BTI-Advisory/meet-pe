import 'package:flutter/material.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:meet_pe/screens/guideProfilPages/main_guide_page.dart';
import 'package:meet_pe/screens/onBoardingPages/guide/welcomeGuidePage.dart';
import 'package:meet_pe/utils/responsive_size.dart';

import '../../services/secure_storage_service.dart';
import '../../utils/utils.dart';
import '../onBoardingPages/travelers/info_travelers_page.dart';
import '../travelersPages/main_travelers_page.dart';
import 'introMovePage.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen>
    with TickerProviderStateMixin {
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
    //controller.forward().whenComplete(() => navigateTo(context, (_) => const IntroMovePage()));
    redirectionState();
    super.initState();
  }

  void redirectionState() async {
    print('readAccessToken ${await SecureStorageService.readAccessToken()}');
    print('readRole ${await SecureStorageService.readRole()}');
    print('readCompleted ${await SecureStorageService.readCompleted()}');
    if (await SecureStorageService.readAccessToken() != null) {
      if (await SecureStorageService.readRole() == '1') {
        if (await SecureStorageService.readCompleted() == 'true') {
          controller.forward().whenComplete(() => navigateTo(context, (_) => MainTravelersPage(initialPage: 0,)));
        } else {
          controller.forward().whenComplete(() => navigateTo(context, (_) => InfoTravelersPage()));
        }
      } else if (await SecureStorageService.readRole() == '2')  {
        if (await SecureStorageService.readCompleted() == 'true') {
          controller.forward().whenComplete(() => navigateTo(context, (_) => MainGuidePage(initialPage: 2)));
        } else {
          controller.forward().whenComplete(() => navigateTo(context, (_) => const WelcomeGuidePage()));
        }
      } else {
        controller.forward().whenComplete(() => navigateTo(context, (_) => const IntroMovePage()));
      }
    } else {
      controller.forward().whenComplete(() => navigateTo(context, (_) => const IntroMovePage()));
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
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xffedd8be), AppResources.colorWhite],
          )
      ),
      child: Center(
        child: Container(
          width: ResponsiveSize.calculateWidth(200, context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('images/logo_color.png', width: ResponsiveSize.calculateWidth(239, context), height: ResponsiveSize.calculateHeight(219, context),),
              SizedBox(height: ResponsiveSize.calculateHeight(219, context)),
              LinearProgressIndicator(
                minHeight: 7,
                value: controller.value,
                semanticsLabel: 'Linear progress indicator',
                backgroundColor: AppResources.colorImputStroke,
                color: AppResources.colorVitamine,
                borderRadius: BorderRadius.circular(3.5),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
