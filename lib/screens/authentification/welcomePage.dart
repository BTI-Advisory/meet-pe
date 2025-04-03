import 'package:flutter/material.dart';
import 'package:meet_pe/screens/onBoardingPages/guide/welcomeGuidePage.dart';
import 'package:meet_pe/screens/onBoardingPages/travelers/info_travelers_page.dart';
import 'package:meet_pe/utils/_utils.dart';
import '../../resources/resources.dart';
import '../../services/app_service.dart';
import '../../services/secure_storage_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        title: Center(child: Text(AppLocalizations.of(context)!.information_title_text)),
        content: Text(AppLocalizations.of(context)!.information_descr_text),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)!.ok_text),
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
            // Background Image
            Image.asset(
              'images/welcome_map.png',
              width: double.infinity,
              height: ResponsiveSize.calculateHeight(229, context),
              fit: BoxFit.cover,
            ),
            Positioned.fill(
              top: ResponsiveSize.calculateHeight(109, context),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.calculateWidth(28, context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: ResponsiveSize.calculateHeight(30, context)),
                    // Welcome Title
                    Text(
                      AppLocalizations.of(context)!.welcome_title_text,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: AppResources.colorBeigeLight,
                        fontSize: ResponsiveSize.calculateTextSize(38, context),
                        fontFamily: 'Rammetto One',
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.calculateHeight(20, context)),
                    // Welcome Description
                    Text(
                      AppLocalizations.of(context)!.welcome_descr_text,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppResources.colorBeige,
                        fontSize: ResponsiveSize.calculateTextSize(18, context),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.calculateHeight(30, context)),
                    // Guide Welcome Text
                    Text(
                      AppLocalizations.of(context)!.guide_welcome_text,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppResources.colorWhite,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.calculateHeight(26, context)),
                    // Guide Button
                    SizedBox(
                      width: double.infinity,
                      //height: ResponsiveSize.calculateHeight(44, context),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1, color: AppResources.colorWhite),
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        ),
                        onPressed: () {
                          SecureStorageService.saveRole('2');
                          AppService.api.setRole('guide').then((response) {
                            navigateTo(context, (_) => const WelcomeGuidePage());
                          }).catchError((error) {
                            print('Error: $error');
                          });
                        },
                        child: Text(
                          AppLocalizations.of(context)!.guide_welcome_button,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: AppResources.colorWhite),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.calculateHeight(30, context)),
                    // Travelers Welcome Text
                    Text(
                      AppLocalizations.of(context)!.travelers_welcome_text,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppResources.colorWhite,
                        height: 1.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    SizedBox(height: ResponsiveSize.calculateHeight(26, context)),
                    // Travelers Button
                    SizedBox(
                      width: double.infinity,
                      //height: ResponsiveSize.calculateHeight(44, context),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(AppResources.colorWhite),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(ResponsiveSize.calculateCornerRadius(40, context)),
                            ),
                          ),
                        ),
                        onPressed: () {
                          SecureStorageService.saveRole('1');
                          AppService.api.setRole('voyageur').then((response) {
                            navigateTo(context, (_) => InfoTravelersPage());
                          }).catchError((error) {
                            print('Error: $error');
                          });
                        },
                        child: Text(
                          AppLocalizations.of(context)!.travelers_welcome_button,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppResources.colorVitamine,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.calculateHeight(38, context)),
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
