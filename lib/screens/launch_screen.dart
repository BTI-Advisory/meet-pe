import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet_pe/resources/_resources.dart';

import '../utils/utils.dart';
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
    controller.forward().whenComplete(() => navigateTo(context, (_) => const IntroMovePage()));
    super.initState();
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
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('images/logo_color.png', width: 200, height: 183,),
              SizedBox(height: 90),
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
