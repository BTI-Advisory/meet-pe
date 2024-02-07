import 'package:flutter/material.dart';

import '../../../resources/resources.dart';
import '../../../utils/utils.dart';
import 'step1GuidePage.dart';

class WelcomeGuidePage extends StatefulWidget {
  const WelcomeGuidePage({super.key});

  @override
  State<WelcomeGuidePage> createState() => _WelcomeGuidePageState();
}

class _WelcomeGuidePageState extends State<WelcomeGuidePage> {
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
              top: 157,
              child: Container(
                margin: const EdgeInsets.only(left: 28, right: 28,),
                child: Column(
                  children: [
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        'PRÊT \nPOUR \nDEVENIR \nUN SUPER \nGUIDE ?',
                        style: TextStyle(
                          color: AppResources.colorBeigeLight,
                          fontSize: 52,
                          fontFamily: 'Rammetto One',
                          fontWeight: FontWeight.w400,
                          height: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50,),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Ta ville n’a aucun secret pour toi, tu connais des pépites qui sortent des sentiers battus et tu aimes faire découvrir tes passions ? \n \nRejoins la communauté de guides Meet Pe et partage des moments uniques avec des voyageurs curieux du monde entier !\n',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppResources.colorBeige, height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 40,),
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
                              navigateTo(context, (_) => const Step1GuidePage(totalSteps: 5, currentStep: 1,));
                            },
                            child: Text(
                              'COMMENCE PAR TE PRÉSENTER',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppResources.colorVitamine),
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
