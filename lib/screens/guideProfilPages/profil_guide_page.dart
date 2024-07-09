import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meet_pe/models/user_response.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:meet_pe/screens/guideProfilPages/profilesPages/archived_requests_page.dart';
import 'package:meet_pe/screens/guideProfilPages/profilesPages/availabilities_page.dart';
import 'package:meet_pe/screens/guideProfilPages/profilesPages/help_support_page.dart';
import 'package:meet_pe/screens/guideProfilPages/profilesPages/my_account_page.dart';
import 'package:meet_pe/screens/guideProfilPages/profilesPages/notifications_newsletters_page.dart';
import 'package:meet_pe/utils/responsive_size.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:widget_mask/widget_mask.dart';

import '../../services/app_service.dart';
import '../../utils/message.dart';
import '../../utils/utils.dart';

typedef ImagePathCallback = void Function(String);

class ProfileGuidePage extends StatefulWidget {
  const ProfileGuidePage({super.key});

  @override
  State<ProfileGuidePage> createState() => _ProfileGuidePageState();
}

class _ProfileGuidePageState extends State<ProfileGuidePage> {
  bool isGuide = true; // Track if it's currently "Voyageur" or "Guide"
  late Future<UserResponse> _userInfoFuture;
  late TextEditingController _textEditingControllerDescription;
  String? validationMessageDescription = '';
  bool isFormValid = false;
  String? selectedImagePath;

  @override
  void initState() {
    super.initState();
    AppService.instance.updateDeviceData();
    _userInfoFuture = AppService.api.getUserInfo();
    _textEditingControllerDescription = TextEditingController();
    _textEditingControllerDescription.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingControllerDescription.removeListener(_onTextChanged);
    _textEditingControllerDescription.dispose();
  }

  void _onTextChanged() {
    setState(() {
      //_showButton = _textEditingControllerDescription.text.isEmpty;
    });
  }

  void updateFormValidity() {
    setState(() {
      isFormValid = _textEditingControllerDescription == null;
    });
  }

  void toggleRole() {
    setState(() {
      isGuide = !isGuide;
    });
  }

  Future<void> pickImageFromGallery(BuildContext context, Function(String) callback) async {
    final picker = ImagePicker();

    if (Platform.isIOS) {
      // Request permissions for photos and access only photos added in future
      Map<Permission, PermissionStatus> statuses = await [
        Permission.photos,
        Permission.photosAddOnly,
      ].request();

      // Check the status of the photos permission
      if (statuses[Permission.photos]!.isDenied) {
        // Permission was denied, so request again
        statuses[Permission.photos] = await Permission.photos.request();

        if (statuses[Permission.photos]!.isDenied) {
          showMessage(context, "L'autorisation d'accéder aux photos est refusée. Veuillez l'activer à partir des paramètres.");
          return;
        }
      }

      if (statuses[Permission.photos]!.isPermanentlyDenied) {
        showMessage(context, "L'autorisation d'accéder aux photos est définitivement refusée. Veuillez l'activer à partir des paramètres.");
        // Optionally, you could navigate the user to the app settings:
        // openAppSettings();
        return;
      }

      if (statuses[Permission.photos]!.isGranted) {
        // If permission is granted, proceed to pick the image
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);

        if (pickedFile != null) {
          // Check the size of the picked image
          if ((await pickedFile.readAsBytes()).lengthInBytes > 8388608) {
            showMessage(context, 'Oups, ta 📸 est top, mais trop lourde pour nous, 8MO max stp 🙏🏻');
          } else {
            String imagePath = pickedFile?.path ?? '';

            setState(() {
              selectedImagePath = imagePath;
              updateFormValidity();
              callback(imagePath);
            });
          }
        } else {
          showMessage(context, 'Aucune image sélectionnée.');
        }
      } else {
        showMessage(context, "Impossible d'accéder aux photos. Veuillez vérifier vos paramètres d'autorisation.");
      }
    } else if (Platform.isAndroid) {
      // If permission is granted, proceed to pick the image
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        // Check the size of the picked image
        if ((await pickedFile.readAsBytes()).lengthInBytes > 8388608) {
          showMessage(context, 'Oups, ta 📸 est top, mais trop lourde pour nous, 8MO max stp 🙏🏻');
        } else {
          String imagePath = pickedFile?.path ?? '';

          setState(() {
            selectedImagePath = imagePath;
            updateFormValidity();
            callback(imagePath);
          });
        }
      } else {
        showMessage(context, 'Aucune image sélectionnée.');
      }
    }
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
          //return Center(child: Text('Error: ${snapshot.error}'));
          return Center(child: Text('Problème de connexion avec le serveur, veuillez réessayer ultérieurement'));
        } else {
          final userInfo = snapshot.data!;
          final initialImagePath = selectedImagePath ?? userInfo.profilePath ?? 'images/avatar_placeholder.png';
          return SingleChildScrollView(
            child: Container(
              width: deviceSize.width,
              height: deviceSize.height,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.calculateWidth(20, context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: ResponsiveSize.calculateHeight(46, context)),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              ResponsiveSize.calculateWidth(5, context)),
                      child: Text(
                        'Profil',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                fontSize: 32, color: AppResources.colorDark),
                      ),
                    ),
                    SizedBox(
                        height: ResponsiveSize.calculateHeight(20, context)),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return Container(
                                      width: double.infinity,
                                      height: 357,
                                      color: AppResources.colorWhite,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 28),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            const SizedBox(height: 39),
                                            Text(
                                              'Mon Profil',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium,
                                            ),
                                            Column(
                                              children: [
                                                Stack(
                                                  children: [
                                                    Container(
                                                      width: ResponsiveSize.calculateWidth(144, context),
                                                      height: ResponsiveSize.calculateHeight(140, context),
                                                      child: WidgetMask(
                                                        blendMode: BlendMode.srcATop,
                                                        childSaveLayer: true,
                                                        mask: selectedImagePath != null
                                                            ? Image.file(
                                                          File(selectedImagePath!),
                                                          fit: BoxFit.cover,
                                                        )
                                                            : Image.network(
                                                          initialImagePath,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        child: Image.asset(
                                                          'images/image_frame.png',
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: 0,
                                                      right: 0,
                                                      child: Container(
                                                        width: ResponsiveSize.calculateWidth(34, context),
                                                        height: ResponsiveSize.calculateHeight(34, context),
                                                        padding: const EdgeInsets.all(4),
                                                        decoration: ShapeDecoration(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(ResponsiveSize.calculateCornerRadius(40, context)),
                                                          ),
                                                        ),
                                                        child: FloatingActionButton(
                                                          backgroundColor: AppResources.colorVitamine,
                                                          onPressed: () async {
                                                            await pickImageFromGallery(context, (imagePath) {
                                                              setState(() {
                                                                selectedImagePath = imagePath;
                                                              });
                                                            });
                                                          },
                                                          child: Icon(Icons.add, color: Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 53),
                                            Container(
                                              width:
                                                  ResponsiveSize.calculateWidth(
                                                      319, context),
                                              height: ResponsiveSize
                                                  .calculateHeight(44, context),
                                              child: TextButton(
                                                style: ButtonStyle(
                                                  padding: MaterialStateProperty.all<
                                                          EdgeInsets>(
                                                      EdgeInsets.symmetric(
                                                          horizontal:
                                                              ResponsiveSize
                                                                  .calculateWidth(
                                                                      24,
                                                                      context),
                                                          vertical: ResponsiveSize
                                                              .calculateHeight(
                                                                  12,
                                                                  context))),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.transparent),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          width: 1,
                                                          color: AppResources
                                                              .colorDark),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                    ),
                                                  ),
                                                ),
                                                child: Text(
                                                  'ENREGISTRER',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.copyWith(
                                                          color: AppResources
                                                              .colorDark),
                                                ),
                                                onPressed: () async {
                                                  final result = AppService.api.updatePhoto(selectedImagePath!);
                                                  if (await result) {
                                                    Navigator.pop(context);
                                                    showMessage(context, 'Photo ✅');
                                                    await Future.delayed(const Duration(seconds: 1));
                                                    setState(() {
                                                      _userInfoFuture = AppService.api.getUserInfo();
                                                    });
                                                    //widget.onFetchUserInfo();
                                                  } else {
                                                    Navigator.pop(context);
                                                    showMessage(context, 'Problème de connexion avec le serveur, veuillez réessayer ultérieurement');
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            })
                            .whenComplete(() {
                          // Refresh the state when the modal is dismissed
                          setState(() {
                            _userInfoFuture = AppService.api.getUserInfo();
                          });
                        });;
                      },
                      child: Container(
                        width: ResponsiveSize.calculateWidth(336, context),
                        height: ResponsiveSize.calculateHeight(163, context),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  ResponsiveSize.calculateCornerRadius(
                                      8, context))),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(width: ResponsiveSize.calculateWidth(12, context)),
                                    Container(
                                      width: ResponsiveSize.calculateWidth(
                                          72, context),
                                      height: ResponsiveSize.calculateHeight(
                                          72, context),
                                      decoration: ShapeDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(userInfo.profilePath),
                                          fit: BoxFit.cover,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              ResponsiveSize.calculateCornerRadius(
                                                  162.50, context)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: ResponsiveSize.calculateWidth(
                                          13, context),
                                    ),
                                    Text(
                                      userInfo.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                          color: AppResources.colorDark),
                                    ),
                                  ],
                                ),
                                Image.asset('images/chevron_right.png',
                                    width: 27, height: 27, fit: BoxFit.fill),
                              ],
                            ),
                            SizedBox(
                                height: ResponsiveSize.calculateHeight(
                                    12, context)),
                            Container(
                              width:
                                  ResponsiveSize.calculateWidth(319, context),
                              height:
                                  ResponsiveSize.calculateHeight(52, context),
                              padding: const EdgeInsets.all(4),
                              decoration: ShapeDecoration(
                                color: AppResources.colorGray5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      ResponsiveSize.calculateCornerRadius(
                                          40, context)),
                                ),
                              ),
                              child:
                                  isGuide ? buildGuideUI() : buildVoyageurUI(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                        height: ResponsiveSize.calculateHeight(24, context)),

                    /// Messages Alerts
                    Visibility(
                      visible: (userInfo.hasUpdatedHesSchedule == false &&
                          userInfo.IBAN == null),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                ResponsiveSize.calculateWidth(8, context)),
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
                              side: const BorderSide(
                                  width: 1, color: AppResources.colorVitamine),
                              borderRadius: BorderRadius.circular(
                                  ResponsiveSize.calculateCornerRadius(
                                      8, context)),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset('images/info_icon.svg'),
                              SizedBox(
                                  width: ResponsiveSize.calculateWidth(
                                      8, context)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Tu as plusieurs informations à compléter :\n',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                            color: AppResources.colorVitamine,
                                            height: 0.14),
                                  ),
                                  Visibility(
                                    visible:
                                        userInfo.hasUpdatedHesSchedule == false,
                                    child: Text(
                                      '   .   Renseigne tes disponibilités',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                              color: AppResources.colorVitamine,
                                              height: 0.14),
                                    ),
                                  ),
                                  Visibility(
                                    visible: userInfo.IBAN == null,
                                    child: Text(
                                      '   .   Renseigne ton RIB',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                              color: AppResources.colorVitamine,
                                              height: 0.14),
                                    ),
                                  ),
                                  Visibility(
                                    visible: userInfo.IBAN == null,
                                    child: Text(
                                      '   .   Renseigne tes infos (Mon compte)',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                              color: AppResources.colorVitamine,
                                              height: 0.14),
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
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              ResponsiveSize.calculateWidth(8.0, context)),
                      child: Column(
                        children: [
                          sectionProfile(
                              'Mes disponibilités', Icons.calendar_month, userInfo.hasUpdatedHesSchedule, () {
                            navigateTo(
                                context, (_) => const AvailabilitiesPage());
                          }),
                          sectionProfile('Mon compte', Icons.person, (userInfo.IBAN != null && userInfo.pieceIdentite != null), () {
                            //navigateTo(context, (_) => MyAccountPage());
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                  builder: (_) => const MyAccountPage()),
                            )
                                .then((_) {
                              // This code runs after returning from MyAccountPage
                              _userInfoFuture = AppService.api
                                  .getUserInfo(); // Refresh user info
                              setState(
                                  () {}); // Trigger a rebuild to reflect changes
                            });
                          }),
                          sectionProfile('Demandes archivées', Icons.bookmark, true,
                              () {
                            navigateTo(
                                context, (_) => const ArchivedRequestsPage());
                          }),
                          sectionProfile('Notifications & newsletters',
                              Icons.notifications, true, () {
                            navigateTo(context,
                                (_) => const NotificationsNewslettersPage());
                          }),
                          sectionProfile(
                              'FAQ & assistance', Icons.contact_support, true, () {
                            navigateTo(context, (_) => const HelpSupportPage());
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              ResponsiveSize.calculateWidth(24, context)),
                      child: TextButton(
                        onPressed: AppService.instance.logOut,
                        child: Text(
                          'Se déconnecter',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: AppResources.colorDark,
                                  decoration: TextDecoration.underline),
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
    ));
  }

  Widget sectionProfile(
      String title, IconData icon, bool completed, VoidCallback onTapCallback) {
    return InkWell(
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
                  Icon(
                    icon,
                    size: 16,
                  ),
                  SizedBox(width: ResponsiveSize.calculateWidth(8, context)),
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppResources.colorDark),
                  )
                ],
              ),
              Row(
                children: [
                  Visibility(
                    visible: completed == false,
                    child: Container(
                      width: 73,
                      height: 21,
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        color: Color(0xFFFFECAB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'à compléter',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 10, fontWeight: FontWeight.w400, color: const Color(0xFFC89C00)),
                      ),
                    ),
                  ),
                  Image.asset('images/chevron_right.png',
                      width: 27, height: 27, fit: BoxFit.fill),
                ],
              ),
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
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppResources.colorGray45),
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
                borderRadius: BorderRadius.circular(
                    ResponsiveSize.calculateCornerRadius(40, context)),
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
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppResources.colorVitamine, fontSize: 14),
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
                borderRadius: BorderRadius.circular(
                    ResponsiveSize.calculateCornerRadius(40, context)),
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
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppResources.colorVitamine, fontSize: 14),
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
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppResources.colorGray45),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
