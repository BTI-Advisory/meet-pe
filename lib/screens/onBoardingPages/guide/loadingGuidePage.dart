import 'package:flutter/material.dart';
import 'package:meet_pe/screens/onBoardingPages/guide/create_experience/create_exp_step1.dart';
import '../../../resources/resources.dart';
import '../../../utils/responsive_size.dart';
import '../../../utils/utils.dart';
import '../../guideProfilPages/main_guide_page.dart';

class LoadingGuidePage extends StatefulWidget {
  const LoadingGuidePage({super.key});

  @override
  State<LoadingGuidePage> createState() => _LoadingGuidePageState();
}

class _LoadingGuidePageState extends State<LoadingGuidePage> {

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFEDD8BE), AppResources.colorWhite],
              )
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: ResponsiveSize.calculateHeight(175, context)),
                Image.asset('images/verified_guide.png', width: ResponsiveSize.calculateWidth(100, context), height: ResponsiveSize.calculateHeight(100, context),),
                SizedBox(height: ResponsiveSize.calculateHeight(40, context)),
                Text(
                  'Ton profil guide \nest créé !',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: AppResources.colorGray100, fontSize: 32),
                ),
                SizedBox(height: ResponsiveSize.calculateHeight(16, context)),
                Text(
                  'Prêt à faire vivre \ndes expériences uniques ?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Column(
                  children: [
                    SizedBox(height: ResponsiveSize.calculateHeight(175, context),),
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
                              side: BorderSide(width: 1, color: AppResources.colorVitamine),
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        ),
                        onPressed: (){
                          navigateTo(context, (_) => const MainGuidePage());
                        },
                        child: Text(
                          'PARCOURIR L’APPLICATION',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppResources.colorVitamine),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.calculateHeight(21, context),),
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
                              AppResources.colorVitamine),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(ResponsiveSize.calculateCornerRadius(40, context)),
                            ),
                          ),
                        ),
                        onPressed: (){
                          navigateTo(context, (_) => const CreateExpStep1());
                        },
                        child: Text(
                          'CRÉER UNE EXPÈRIENCE',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppResources.colorWhite),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.calculateHeight(40, context),),
                  ],
                ),
              ],
            ),
          ),
        ),
    );
  }
}
