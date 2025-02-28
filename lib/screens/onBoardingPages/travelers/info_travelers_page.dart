import 'dart:io';

import 'package:birth_picker/birth_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:meet_pe/screens/onBoardingPages/travelers/step1Page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:widget_mask/widget_mask.dart';

import '../../../services/app_service.dart';
import 'package:meet_pe/utils/_utils.dart';
import '../../../widgets/_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Define the callback function type
typedef ImagePathCallback = void Function(String);

class InfoTravelersPage extends StatefulWidget {
  InfoTravelersPage({Key? key}) : super(key: key);

  @override
  State<InfoTravelersPage> createState() => _InfoTravelersPageState();
}

class _InfoTravelersPageState extends State<InfoTravelersPage>
    with BlocProvider<InfoTravelersPage, InfoTravelersPageBloc> {
  late List<Voyage> myList = [];
  String selectedImagePath = 'images/avatar_placeholder.png';

  String? validationMessageName = '';
  String? validationMessagePhone = '';
  String? validationMessageBirthDate = '';
  bool isFormValid = false;
  bool imageSize = false;
  DateTime selectedDate = DateTime.now().subtract(const Duration(days: 18 * 365));
  String? errorMessage;

  @override
  initBloc() => InfoTravelersPageBloc();

  @override
  void initState() {
    super.initState();
  }

  void updateFormValidity() {
    setState(() {
      isFormValid = validationMessageName == null && validationMessagePhone == null && validationMessageBirthDate == null && errorMessage == null;
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
              imageSize = true;
              selectedImagePath = imagePath;
              bloc.imagePath = imagePath;
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
            imageSize = true;
            selectedImagePath = imagePath;
            bloc.imagePath = imagePath;
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
    return Scaffold(
      body: AsyncForm(
          onValidated: () async {
            bool success = await bloc.setVoyageurProfile();
            if (success) {
              navigateTo(context, (_) => const Step1Page(totalSteps: 7, currentStep: 1,));
            } else {
              showMessage(context, AppLocalizations.of(context)!.error_upload_text);
            }
          },
          builder: (BuildContext context, void Function() validate) {
            return SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 0,
                  maxHeight: MediaQuery.of(context).size.height,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppResources.colorGray5, AppResources.colorWhite],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: ResponsiveSize.calculateHeight(120, context)),
                      Text(
                        AppLocalizations.of(context)!.info_travelers_text,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: AppResources.colorGray100),
                      ),
                      SizedBox(height: ResponsiveSize.calculateHeight(38, context)),
                      Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: ResponsiveSize.calculateWidth(168, context),
                                height: ResponsiveSize.calculateHeight(168, context),
                                child: WidgetMask(
                                  blendMode: BlendMode.srcATop,
                                  childSaveLayer: true,
                                  mask: Image.asset(
                                    selectedImagePath,
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
                                  width: ResponsiveSize.calculateWidth(44, context),
                                  height: ResponsiveSize.calculateHeight(44, context),
                                  padding: const EdgeInsets.all(4),
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(ResponsiveSize.calculateCornerRadius(40, context)),
                                    ),
                                  ),
                                  child: FloatingActionButton(
                                    backgroundColor: AppResources.colorVitamine,
                                    onPressed: () async {
                                      pickImageFromGallery(context, (imagePath) {
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
                      SizedBox(height: ResponsiveSize.calculateHeight(49, context)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(28, context)),
                        child: Column(
                          children: [
                            Container(
                              height: ResponsiveSize.calculateHeight(28, context),
                              child: TextFormField(
                                keyboardType: TextInputType.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: AppResources.colorGray100),
                                decoration: InputDecoration(
                                  filled: false,
                                  hintText: AppLocalizations.of(context)!.your_name_text,
                                  hintStyle:
                                  Theme.of(context).textTheme.bodyMedium,
                                  contentPadding: EdgeInsets.only(
                                      top: ResponsiveSize.calculateHeight(20, context), bottom: ResponsiveSize.calculateHeight(10, context)),
                                  // Adjust padding
                                  suffix: SizedBox(height: ResponsiveSize.calculateHeight(10, context)),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppResources.colorGray15),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppResources.colorGray15),
                                  ),
                                  errorBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  focusedErrorBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) => validate(),
                                validator: AppResources.validatorNotEmpty,
                                onSaved: (value) => bloc.name = value,
                                onChanged: (value) {
                                  setState(() {
                                    validationMessageName =
                                        AppResources.validatorNotEmpty(value);
                                    updateFormValidity();
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: ResponsiveSize.calculateHeight(40, context)),
                            Container(
                              height: ResponsiveSize.calculateHeight(28, context),
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: AppResources.colorGray100),
                                decoration: InputDecoration(
                                  filled: false,
                                  hintText: AppLocalizations.of(context)!.your_phone_text,
                                  hintStyle:
                                  Theme.of(context).textTheme.bodyMedium,
                                  contentPadding: EdgeInsets.only(
                                      top: ResponsiveSize.calculateHeight(20, context), bottom: ResponsiveSize.calculateHeight(10, context)),
                                  // Adjust padding
                                  suffix: SizedBox(height: ResponsiveSize.calculateHeight(10, context)),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppResources.colorGray15),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppResources.colorGray15),
                                  ),
                                  errorBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  focusedErrorBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                ),
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (value) => validate(),
                                validator: AppResources.validatorPhoneNumber,
                                onSaved: (value) => bloc.phone = value,
                                onChanged: (value) {
                                  setState(() {
                                    validationMessagePhone =
                                        AppResources.validatorPhoneNumber(value);
                                    updateFormValidity();
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: ResponsiveSize.calculateHeight(40, context)),
                            BirthPicker(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: AppResources.colorGray15,
                                    width: 1.0, // Largeur du trait
                                  ),
                                ),
                              ),
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppResources.colorGray100),
                              padding: EdgeInsets.only(left: 0),
                              onChanged: (dateTime) {
                                if (dateTime != null) {
                                  final now = DateTime.now();
                                  final minAgeDate = DateTime(now.year - 18, now.month, now.day); // 18 years ago

                                  if (dateTime.isBefore(minAgeDate)) {
                                    print('Selected Date: ${dateTime.toIso8601String()}');
                                    setState(() {
                                      selectedDate = dateTime;
                                      errorMessage = null; // Remove error message
                                    });
                                    bloc.birthDate = dateTime.toIso8601String();
                                    validationMessageBirthDate = AppResources.validatorNotEmpty(dateTime.toIso8601String());
                                    updateFormValidity();
                                  } else {
                                    print('Invalid Date: Must be at least 18 years old');
                                    setState(() {
                                      errorMessage = '⚠️ Vous devez avoir au moins 18 ans.'; // Show error message
                                    });
                                    bloc.birthDate = null;
                                    updateFormValidity();
                                  }
                                } else {
                                  print('Invalid Date');
                                }
                              },
                            ),
                            if (errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0), // Space from BirthPicker
                                child: Text(
                                  errorMessage!,
                                  style: TextStyle(color: Colors.red, fontSize: 14),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: ResponsiveSize.calculateHeight(44, context)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: ResponsiveSize.calculateWidth(183, context),
                                  height: ResponsiveSize.calculateHeight(44, context),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all<EdgeInsets>(
                                          EdgeInsets.symmetric(
                                              horizontal: ResponsiveSize.calculateWidth(24, context), vertical: ResponsiveSize.calculateHeight(10, context))),
                                      backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                          if (states
                                              .contains(MaterialState.disabled)) {
                                            return AppResources
                                                .colorGray15; // Change to your desired grey color
                                          }
                                          return AppResources
                                              .colorVitamine; // Your enabled color
                                        },
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(ResponsiveSize.calculateCornerRadius(40, context)),
                                        ),
                                      ),
                                    ),
                                    onPressed: isFormValid
                                        ? () {
                                      validate();
                                    }
                                        : null,
                                    // Disable the button if no item is selected
                                    child: Image.asset('images/arrowLongRight.png'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class InfoTravelersPageBloc with Disposable {
  String? name;
  String? phone;
  String? birthDate;
  String? imagePath;

  InfoTravelersPageBloc();

  Future<bool> setVoyageurProfile() async {
    try {
      if (name != null && phone != null && birthDate != null) {

        // Perform the API call
        final response = await AppService.api.setTravelersProfile(name!, phone!, birthDate!, imagePath?.isNotEmpty == true ? imagePath! : null);
        if (response == true) {
          return true;
        } else {
          return false;
        }
      } else {
        // Handle incomplete data when isChecked is true
        print('Incomplete data: Some fields are missing.');
        return false;
      }
    } catch (error) {
      // Handle the error appropriately
      print("Error in make Profile Guide: $error");
      return false;
    }
  }

  @override
  void dispose() {
    // Dispose of any resources if needed
    super.dispose();
  }
}

