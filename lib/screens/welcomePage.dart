import 'package:fetcher/fetcher.dart';
import 'package:flutter/material.dart';
import 'package:meet_pe/screens/onBoardingPages/step1Page.dart';

import '../resources/resources.dart';
import '../services/app_service.dart';
import '../utils/utils.dart';

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
                            onPressed: (){
                              AppService.api.setRole('voyageur').then((response) {
                                // If the API call is successful, navigate to a new screen
                                navigateTo(context, (_) => const Step1Page());
                              }).catchError((error) {
                                // Handle errors if the API call fails
                                print('Error: $error');
                              });
                            },
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
                            onPressed: (){
                              AppService.api.setRole('guide').then((response) {
                                // If the API call is successful, navigate to a new screen
                                // Todo: Call welcome page for guide
                                //navigateTo(context, (_) => const Step1Page());
                              }).catchError((error) {
                                // Handle errors if the API call fails
                                print('Error: $error');
                              });
                            },
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
