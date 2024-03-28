import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:meet_pe/screens/guideProfilPages/main_guide_page.dart';
import 'package:meet_pe/utils/responsive_size.dart';

import '../services/secure_storage_service.dart';
import '../utils/utils.dart';
import 'homePage.dart';
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
    print('SDJFSJDFJ ${await SecureStorageService.readAccessToken()}');
    print('SDJFSJDFJ ${await SecureStorageService.readRole()}');
    if (await SecureStorageService.readAccessToken() != null && await SecureStorageService.readIsVerified() == 'true') {
      if (await SecureStorageService.readRole() == '1') {
        controller.forward().whenComplete(() => navigateTo(context, (_) => const HomePage()));
      } else if (await SecureStorageService.readRole() == '2')  {
        controller.forward().whenComplete(() => navigateTo(context, (_) => const MainGuidePage()));
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
