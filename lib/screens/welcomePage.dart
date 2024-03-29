import 'package:flutter/material.dart';
import 'package:meet_pe/screens/onBoardingPages/guide/welcomeGuidePage.dart';
import 'package:meet_pe/screens/onBoardingPages/voyageur/step1Page.dart';
import 'package:meet_pe/utils/responsive_size.dart';
import '../resources/resources.dart';
import '../services/app_service.dart';
import '../services/secure_storage_service.dart';
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
            Image.asset('images/welcome_map.png', width: double.infinity, height: ResponsiveSize.calculateHeight(229, context), fit: BoxFit.fill,),
            Positioned.fill(
              top: ResponsiveSize.calculateHeight(109, context),
              child: Container(
                margin: EdgeInsets.only(left: ResponsiveSize.calculateWidth(28, context), right: ResponsiveSize.calculateWidth(28, context),),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'MEETPE,\nL’APP QUI \nTE FAIT \nVOYAGER \nAUTREMENT',
                        style: TextStyle(
                          color: AppResources.colorBeigeLight,
                          fontSize: ResponsiveSize.calculateTextSize(40, context),
                          fontFamily: 'Rammetto One',
                          fontWeight: FontWeight.w400,
                          height: ResponsiveSize.calculateHeight(1.4, context),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.calculateHeight(30, context),),
                    SizedBox(
                      width: ResponsiveSize.calculateWidth(double.infinity, context),
                      child: Text(
                        'Avec notre système de matching, rencontre \ndes locaux passionnés et vis des expériences \nfaites pour toi !\n',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorBeige,),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.calculateHeight(30, context),),
                    //const Spacer(),
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Tu veux partager tes passions ?',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppResources.colorWhite, height: 1.5),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: ResponsiveSize.calculateHeight(26, context),),
                        SizedBox(
                          width: ResponsiveSize.calculateWidth(319, context),
                          height: ResponsiveSize.calculateHeight(44, context),
                          child: TextButton(
                            style: ButtonStyle(
                              padding:
                              MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.symmetric(
                                      horizontal: ResponsiveSize.calculateWidth(24, context), vertical: ResponsiveSize.calculateHeight(12, context))),
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
                              SecureStorageService.saveRole('2');
                              AppService.api.setRole('guide').then((response) {
                                // If the API call is successful, navigate to a new screen
                                navigateTo(context, (_) => const WelcomeGuidePage());
                              }).catchError((error) {
                                // Handle errors if the API call fails
                                print('Error: $error');
                              });
                            },
                            child: Text(
                              'DEVIENS GUIDE MEETPE',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppResources.colorWhite),
                            ),
                          ),
                        ),
                        SizedBox(height: ResponsiveSize.calculateHeight(30, context),),
                        SizedBox(
                          width: ResponsiveSize.calculateWidth(327, context),
                          child: Text(
                            'Tu veux rencontrer des locaux passionnés ?',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppResources.colorWhite, fontSize: ResponsiveSize.calculateTextSize(16, context)),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: ResponsiveSize.calculateHeight(26, context),),
                        SizedBox(
                          width: ResponsiveSize.calculateWidth(319, context),
                          height: ResponsiveSize.calculateHeight(44, context),
                          child: TextButton(
                            style: ButtonStyle(
                              padding:
                              MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.symmetric(
                                      horizontal: ResponsiveSize.calculateWidth(24, context), vertical: ResponsiveSize.calculateHeight(12, context))),
                              backgroundColor: MaterialStateProperty.all(
                                  AppResources.colorWhite),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(ResponsiveSize.calculateCornerRadius(40, context)),
                                ),
                              ),
                            ),
                            onPressed: (){
                              SecureStorageService.saveRole('1');
                              AppService.api.setRole('voyageur').then((response) {
                                // If the API call is successful, navigate to a new screen
                                navigateTo(context, (_) => const Step1Page(totalSteps: 7, currentStep: 1,));
                              }).catchError((error) {
                                // Handle errors if the API call fails
                                print('Error: $error');
                              });
                            },
                            child: Text(
                              'VOYAGE AVEC MEETPE',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppResources.colorVitamine),
                            ),
                          ),
                        ),
                        SizedBox(height: ResponsiveSize.calculateHeight(38, context),),
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
