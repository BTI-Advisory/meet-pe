import 'package:flutter/material.dart';
import 'package:meet_pe/screens/onBoardingPages/guide/welcomeGuidePage.dart';
import 'package:meet_pe/screens/onBoardingPages/voyageur/step1Page.dart';
import 'package:meet_pe/utils/_utils.dart';
import '../../resources/resources.dart';
import '../../services/app_service.dart';
import '../../services/secure_storage_service.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key, required this.fromCode});

  final bool fromCode;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  void initState() {
    super.initState();

    if(widget.fromCode == false) {
      displayInfo();
    }
  }

  Future<void> displayInfo() async {
    await Future.delayed(const Duration(seconds: 1));
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Center(child: Text('Information')),
        content: const Text(
            'Et oui, même pour Meet People alors que notre mission est de rendre ce monde encore plus merveilleux grâce à toi cela nous arrive de nous perdre dans tes SPAM ! Mais avec un bon check de ta part nous serons plus fort que le côté obscur de la force 💪🏼'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

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
                        'Avec notre système de matching, rencontre des locaux passionnés et vis des expériences faites pour toi !\n',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppResources.colorBeige,),
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
                              ///Todo: when voyageur is ready
                              /*SecureStorageService.saveRole('1');
                              AppService.api.setRole('voyageur').then((response) {
                                // If the API call is successful, navigate to a new screen
                                navigateTo(context, (_) => const Step1Page(totalSteps: 7, currentStep: 1,));
                              }).catchError((error) {
                                // Handle errors if the API call fails
                                print('Error: $error');
                              });*/
                              showMessage(context, 'Coming soon');
                            },
                            child: Text(
                              'VOYAGE AVEC MEETPE',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppResources.colorVitamine),
                            ),
                          ),
                        ),
                        //SizedBox(height: ResponsiveSize.calculateHeight(38, context),),
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
