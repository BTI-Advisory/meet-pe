import 'package:flutter/material.dart';

import '../resources/resources.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppResources.colorOrangeLight,
              AppResources.colorVitamine
            ],
          ),
        ),
        child: Stack(
          children: [
            Image.asset('images/welcome_map.png', width: double.infinity, height: 229, fit: BoxFit.fill,),
            Positioned.fill(
              top: 153,
              child: Container(
                margin: const EdgeInsets.only(left: 28, right: 28,),
                child: Column(
                  children: [
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        'MEETPE,\nL’APP QUI \nTE FAIT \nVOYAGER \nAUTREMENT',
                        style: TextStyle(
                          color: AppResources.colorBeigeLight,
                          fontSize: 40,
                          fontFamily: 'Rammetto One',
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40,),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Grâce à notre système de matching, \nrencontre des locaux passionnés et vis des \nexpériences faites pour toi… tout en te \nlaissant surprendre !',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppResources.colorBeige, height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 57,),
                    const Spacer(),
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            style: ButtonStyle(
                              padding:
                              MaterialStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12)),
                              backgroundColor: MaterialStateProperty.all(
                                  AppResources.colorWhite),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                            ),
                            onPressed: (){},
                            child: Text(
                              'C’EST PARTI !!',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppResources.colorVitamine),
                            ),
                          ),
                        ),
                        const SizedBox(height: 21,),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            style: ButtonStyle(
                              padding:
                              MaterialStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12)),
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.transparent),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  side: BorderSide(width: 1, color: AppResources.colorWhite),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                            ),
                            onPressed: (){},
                            child: Text(
                              'DEVENIR GUIDE MEETPE',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppResources.colorWhite),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40,),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
