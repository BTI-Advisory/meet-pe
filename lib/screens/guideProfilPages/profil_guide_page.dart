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
import 'package:package_info_plus/package_info_plus.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:widget_mask/widget_mask.dart';

import '../../services/app_service.dart';
import '../../utils/_utils.dart';
import '../onBoardingPages/guide/step1GuidePage.dart';
import '../onBoardingPages/travelers/step1Page.dart';
import '../travelersPages/main_travelers_page.dart';
import 'main_guide_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  String fullVersion = '';

  @override
  void initState() {
    super.initState();
    AppService.instance.updateDeviceData();
    _userInfoFuture = AppService.api.getUserInfo();
    _textEditingControllerDescription = TextEditingController();
    _textEditingControllerDescription.addListener(_onTextChanged);
    getFullVersion();
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

  void toggleRole(String selectedRole, bool userVerified) {
    bool newRoleIsGuide = (selectedRole == "Guide"); // Store desired role change

    // Show confirmation dialog before updating isGuide
    PanaraConfirmDialog.showAnimatedGrow(
      context,
      title: AppLocalizations.of(context)!.information_title_text,
      message: newRoleIsGuide
          ? (userVerified
          ? AppLocalizations.of(context)!.switch_guide_text
          : AppLocalizations.of(context)!.switch_guide_inscription_text)
          : (userVerified
          ? AppLocalizations.of(context)!.switch_traveler_text
          : AppLocalizations.of(context)!.switch_traveler_inscription_text),
      confirmButtonText: AppLocalizations.of(context)!.confirmation_text,
      cancelButtonText: AppLocalizations.of(context)!.cancel_text,
      onTapCancel: () {
        Navigator.pop(context); // Close dialog without changing state
      },
      onTapConfirm: () {
        Navigator.pop(context); // Close dialog first
        setState(() {
          isGuide = newRoleIsGuide; // Apply change only after confirmation
        });

        // Navigate to appropriate page
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (newRoleIsGuide) {
            navigateTo(
                context,
                    (_) => userVerified
                    ? MainGuidePage(initialPage: 2)
                    : const Step1GuidePage(totalSteps: 4, currentStep: 1));
          } else {
            navigateTo(
                context,
                    (_) => userVerified
                    ? MainTravelersPage(initialPage: 3)
                    : const Step1Page(totalSteps: 7, currentStep: 1));
          }
        });
      },
      panaraDialogType: PanaraDialogType.normal,
    );
  }

  Future<void> getFullVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final version = packageInfo.version;
    final buildNumber = packageInfo.buildNumber;
    fullVersion = '$version($buildNumber)';
    print('Full version with build number: $fullVersion');
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
          showMessage(context, AppLocalizations.of(context)!.access_refuse_text);
          return;
        }
      }

      if (statuses[Permission.photos]!.isPermanentlyDenied) {
        showMessage(context, AppLocalizations.of(context)!.access_refuse_all_text);
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
            showMessage(context, AppLocalizations.of(context)!.image_size_text);
          } else {
            String imagePath = pickedFile?.path ?? '';

            setState(() {
              selectedImagePath = imagePath;
              updateFormValidity();
              callback(imagePath);
            });
          }
        } else {
          showMessage(context, AppLocalizations.of(context)!.no_image_selected_text);
        }
      } else {
        showMessage(context, AppLocalizations.of(context)!.impossible_access_text);
      }
    } else if (Platform.isAndroid) {
      // If permission is granted, proceed to pick the image
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        // Check the size of the picked image
        if ((await pickedFile.readAsBytes()).lengthInBytes > 8388608) {
          showMessage(context, AppLocalizations.of(context)!.image_size_text);
        } else {
          String imagePath = pickedFile?.path ?? '';

          setState(() {
            selectedImagePath = imagePath;
            updateFormValidity();
            callback(imagePath);
          });
        }
      } else {
        showMessage(context, AppLocalizations.of(context)!.no_image_selected_text);
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
          return Center(child: Text(AppLocalizations.of(context)!.problem_server_text));
        } else {
          final userInfo = snapshot.data!;
          final initialImagePath = selectedImagePath ?? userInfo.profilePath ?? 'images/avatar_placeholder.png';
          return SingleChildScrollView(
            child: Container(
              width: deviceSize.width,
              height: deviceSize.height+65,
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
                        AppLocalizations.of(context)!.profile_text,
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
                                              AppLocalizations.of(context)!.my_profile_text,
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
                                                  AppLocalizations.of(context)!.enregister_text,
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
                                                    showMessage(context, AppLocalizations.of(context)!.photo_ok_text);
                                                    await Future.delayed(const Duration(seconds: 1));
                                                    setState(() {
                                                      _userInfoFuture = AppService.api.getUserInfo();
                                                    });
                                                    //widget.onFetchUserInfo();
                                                  } else {
                                                    Navigator.pop(context);
                                                    showMessage(context, AppLocalizations.of(context)!.problem_server_text);
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
                              child: Row(
                                children: [
                                  buildRoleButton("Voyageur", userInfo.voyageurVerified, isActive: !isGuide),
                                  buildRoleButton("Guide", userInfo.guideVerified, isActive: isGuide),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                        height: ResponsiveSize.calculateHeight(24, context)),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              ResponsiveSize.calculateWidth(8.0, context)),
                      child: Column(
                        children: [
                          sectionProfile('Mes absences', Icons.calendar_month, true,
                                  () {
                                navigateTo(context, (_) => const AvailabilitiesPage());
                              }),
                          sectionProfile('Mon compte', Icons.person, (userInfo.kbisFile != null && userInfo.pieceIdentite != null), () {
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
                    Row(
                      children: [
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
                        ),
                        TextButton(
                          onPressed: () async {
                            await AppService.api.deleteUser();
                            AppService.instance.logOut;
                          },
                          child: Text(
                              'Supprimer mon compte',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                color: AppResources.colorDark,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Center(
                      child: Text(
                        fullVersion,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                            color: AppResources.colorDark,
                            decoration: TextDecoration.underline),
                      ),
                    ),
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

  Widget buildRoleButton(String role, bool userVerified, {required bool isActive}) {
    return GestureDetector(
      onTap: () {
        // Call toggleRole with the selected role name
        if ((role == "Guide" && !isGuide) || (role == "Voyageur" && isGuide)) {
          toggleRole(role, userVerified);
        }
      },
      child: Container(
        width: ResponsiveSize.calculateWidth(153.50, context),
        height: ResponsiveSize.calculateHeight(44, context),
        decoration: ShapeDecoration(
          color: isActive ? AppResources.colorWhite : Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2, color: isActive ? AppResources.colorVitamine : Colors.transparent),
            borderRadius: BorderRadius.circular(
                ResponsiveSize.calculateCornerRadius(40, context)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isActive) Icon(Icons.check_circle, color: AppResources.colorVitamine),
            if (isActive) SizedBox(width: ResponsiveSize.calculateWidth(6, context)),
            Text(
              role == "Guide" ? AppLocalizations.of(context)!.guide_text : AppLocalizations.of(context)!.traveler_text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isActive ? AppResources.colorVitamine : AppResources.colorGray45,
                fontSize: isActive ? 14 : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
