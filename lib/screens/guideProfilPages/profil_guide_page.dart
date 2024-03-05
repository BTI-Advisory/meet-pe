import 'package:flutter/material.dart';
import 'package:meet_pe/models/user_response.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:meet_pe/screens/guideProfilPages/profilesPages/archived_requests_page.dart';
import 'package:meet_pe/screens/guideProfilPages/profilesPages/availabilities_page.dart';
import 'package:meet_pe/screens/guideProfilPages/profilesPages/help_support_page.dart';
import 'package:meet_pe/screens/guideProfilPages/profilesPages/my_account_page.dart';
import 'package:meet_pe/screens/guideProfilPages/profilesPages/notifications_newsletters_page.dart';
import 'package:meet_pe/utils/responsive_size.dart';

import '../../services/app_service.dart';
import '../../utils/utils.dart';

class ProfileGuidePage extends StatefulWidget {
  const ProfileGuidePage({super.key});

  @override
  State<ProfileGuidePage> createState() => _ProfileGuidePageState();
}

class _ProfileGuidePageState extends State<ProfileGuidePage> {
  bool isGuide = true; // Track if it's currently "Voyageur" or "Guide"
  late Future<UserResponse> _userInfoFuture;

  @override
  void initState() {
    super.initState();
    _userInfoFuture = AppService.api.getUserInfo();
  }

  void toggleRole() {
    setState(() {
      isGuide = !isGuide;
    });
  }
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder<UserResponse>(
        future: _userInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final userInfo = snapshot.data!;
            return SingleChildScrollView(
              child: Container(
                width: deviceSize.width,
                height: deviceSize.height,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(20, context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: ResponsiveSize.calculateHeight(46, context)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(5, context)),
                        child: Text(
                          'Profil',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontSize: 32, color: AppResources.colorDark),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.calculateHeight(20, context)),
                      Container(
                        width: ResponsiveSize.calculateWidth(336, context),
                        height: ResponsiveSize.calculateHeight(163, context),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveSize.calculateCornerRadius(8, context))),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: ResponsiveSize.calculateWidth(72, context),
                                  height: ResponsiveSize.calculateHeight(72, context),
                                  decoration: ShapeDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(userInfo.profilePath),
                                      fit: BoxFit.cover,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(ResponsiveSize.calculateCornerRadius(162.50, context)),
                                    ),
                                  ),
                                ),
                                SizedBox(width: ResponsiveSize.calculateWidth(13, context),),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userInfo.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(color: AppResources.colorDark),
                                    ),
                                    SizedBox(width: ResponsiveSize.calculateHeight(6, context),),
                                    Text(
                                      'Modifier mon profil',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(fontSize: 12, color: AppResources.colorGray45),
                                    ),
                                  ],
                                ),
                                SizedBox(width: ResponsiveSize.calculateWidth(80, context),),
                                Image.asset('images/chevron_right.png', width: 27, height: 27, fit: BoxFit.fill),
                              ],
                            ),
                            SizedBox(height: ResponsiveSize.calculateHeight(12, context)),
                            Container(
                              width: ResponsiveSize.calculateWidth(319, context),
                              height: ResponsiveSize.calculateHeight(52, context),
                              padding: const EdgeInsets.all(4),
                              decoration: ShapeDecoration(
                                color: AppResources.colorGray5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(ResponsiveSize.calculateCornerRadius(40, context)),
                                ),
                              ),
                              child: isGuide ? buildGuideUI() : buildVoyageurUI(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.calculateHeight(24, context)),
                      /// Messages Alerts
                      Visibility(
                        visible: (userInfo.hasUpdatedHesSchedule == false && userInfo.IBAN == null),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(8, context)),
                          child: Container(
                            height: ResponsiveSize.calculateHeight(85, context),
                            padding: EdgeInsets.only(
                              top: ResponsiveSize.calculateHeight(12, context),
                              left: ResponsiveSize.calculateWidth(12, context),
                              right: ResponsiveSize.calculateWidth(12, context),
                              bottom: ResponsiveSize.calculateHeight(16, context),
                            ),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 1, color: AppResources.colorVitamine),
                                borderRadius: BorderRadius.circular(ResponsiveSize.calculateCornerRadius(8, context)),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset('images/info_icon.png'),
                                SizedBox(width: ResponsiveSize.calculateWidth(8, context)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Vous avez plusieurs informations à compléter :\n',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(fontSize: 10, fontWeight: FontWeight.w400, color: AppResources.colorVitamine, height: 0.14),
                                    ),
                                    Visibility(
                                      visible: userInfo.hasUpdatedHesSchedule == false,
                                      child: Text(
                                        '   .   Renseigner vos disponibilités',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(fontSize: 10, fontWeight: FontWeight.w400, color: AppResources.colorVitamine, height: 0.14),
                                      ),
                                    ),
                                    Visibility(
                                      visible: userInfo.IBAN == null,
                                      child: Text(
                                        '   .   Renseigner votre RIB',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(fontSize: 10, fontWeight: FontWeight.w400, color: AppResources.colorVitamine, height: 0.14),
                                      ),
                                    ),
                                    Visibility(
                                      visible: userInfo.IBAN == null,
                                      child: Text(
                                        '   .   Renseigner votre moyen de paiement',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(fontSize: 10, fontWeight: FontWeight.w400, color: AppResources.colorVitamine, height: 0.14),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(8.0, context)),
                        child: Column(
                          children: [
                            sectionProfile('Mes disponibilités', Icons.calendar_month, () {
                              navigateTo(context, (_) => const AvailabilitiesPage());
                            }),
                            sectionProfile('Mon compte', Icons.person, () {
                              navigateTo(context, (_) => MyAccountPage(iBAN: userInfo.IBAN, email: userInfo.email));
                            }),
                            sectionProfile('Demandes archivées', Icons.bookmark, () {
                              navigateTo(context, (_) => const ArchivedRequestsPage());
                            }),
                            sectionProfile('Notifications & newsletters', Icons.notifications, () {
                              navigateTo(context, (_) => const NotificationsNewslettersPage());
                            }),
                            sectionProfile('Aide & assistance', Icons.contact_support, () {
                              navigateTo(context, (_) => const HelpSupportPage());
                            }),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(24, context)),
                        child: TextButton(
                          onPressed: AppService.instance.logOut,
                          child: Text(
                            'Se déconnecter',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppResources.colorDark, decoration: TextDecoration.underline),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        },
      )
    );
  }

  Widget sectionProfile(String title, IconData icon, VoidCallback onTapCallback) {
    return GestureDetector(
      onTap: onTapCallback,
      child: Column(
        children: [
          SizedBox(height: ResponsiveSize.calculateHeight(21, context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(icon, size: 16,),
                  SizedBox(width: ResponsiveSize.calculateWidth(8, context)),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorDark),
                  )
                ],
              ),
              Image.asset('images/chevron_right.png', width: 27, height: 27, fit: BoxFit.fill),
            ],
          ),
          SizedBox(height: ResponsiveSize.calculateHeight(20, context)),
          Container(
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: AppResources.colorGray15,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildGuideUI() {
    return Row(
      children: [
        GestureDetector(
          onTap: toggleRole,
          child: Container(
            width: ResponsiveSize.calculateWidth(153.50, context),
            height: ResponsiveSize.calculateHeight(44, context),
            child: Center(
              child: Text(
                'Voyageur',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorGray45),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: toggleRole,
          child: Container(
            width: ResponsiveSize.calculateWidth(153.50, context),
            height: ResponsiveSize.calculateHeight(44, context),
            decoration: ShapeDecoration(
              color: AppResources.colorWhite,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 2, color: AppResources.colorVitamine),
                borderRadius: BorderRadius.circular(ResponsiveSize.calculateCornerRadius(40, context)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: AppResources.colorVitamine),
                SizedBox(width: ResponsiveSize.calculateWidth(6, context)),
                Text(
                  'Guide',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppResources.colorVitamine, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildVoyageurUI() {
    return Row(
      children: [
        GestureDetector(
          onTap: toggleRole,
          child: Container(
            width: ResponsiveSize.calculateWidth(153.50, context),
            height: ResponsiveSize.calculateHeight(44, context),
            decoration: ShapeDecoration(
              color: AppResources.colorWhite,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 2, color: AppResources.colorVitamine),
                borderRadius: BorderRadius.circular(ResponsiveSize.calculateCornerRadius(40, context)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: AppResources.colorVitamine),
                SizedBox(width: ResponsiveSize.calculateWidth(6, context)),
                Text(
                  'Voyageur',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppResources.colorVitamine, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: toggleRole,
          child: Container(
            width: ResponsiveSize.calculateWidth(153.50, context),
            height: ResponsiveSize.calculateHeight(44, context),
            child: Center(
              child: Text(
                'Guide',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorGray45),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
