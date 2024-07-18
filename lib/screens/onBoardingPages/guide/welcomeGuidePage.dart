import 'package:flutter/material.dart';

import '../../../resources/resources.dart';
import '../../../utils/responsive_size.dart';
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
            Image.asset('images/welcome_map.png', width: double.infinity, height: ResponsiveSize.calculateHeight(229, context), fit: BoxFit.fill,),
            Positioned.fill(
              top: ResponsiveSize.calculateHeight(157, context),
              child: Container(
                margin: EdgeInsets.only(left: ResponsiveSize.calculateWidth(28, context), right: ResponsiveSize.calculateWidth(28, context),),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'PRÊT \nPOUR \nDEVENIR \nUN SUPER \nGUIDE ?',
                        style: TextStyle(
                          color: AppResources.colorBeigeLight,
                          fontSize: ResponsiveSize.calculateTextSize(40, context),
                          fontFamily: 'Rammetto One',
                          fontWeight: FontWeight.w400,
                          height: ResponsiveSize.calculateHeight(1.0, context),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.calculateHeight(50, context),),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Ta ville n’a aucun secret pour toi, tu connais des pépites qui sortent des sentiers battus et tu aimes faire découvrir tes passions ? \n \nRejoins la communauté de guides Meet People et partage des moments uniques avec des voyageurs curieux du monde entier !\n',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppResources.colorBeige, height: ResponsiveSize.calculateHeight(1.4, context)),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: ResponsiveSize.calculateHeight(44, context)),
                          child: Container(
                            width: double.infinity,
                            child: ElevatedButton(
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
                              onPressed: () {
                                navigateTo(context, (_) => const Step1GuidePage(totalSteps: 5, currentStep: 1,));
                              }, // Disable the button if no item is selected
                              child: Text(
                                'COMMENCE PAR TE PRÉSENTER',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppResources.colorVitamine),
                              ),
                            ),
                          ),
                        ),
                      ),
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
