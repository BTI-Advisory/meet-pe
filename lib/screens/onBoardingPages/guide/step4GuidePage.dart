import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:widget_mask/widget_mask.dart';

import '../../../services/app_service.dart';
import 'package:meet_pe/utils/_utils.dart';
import '../../../widgets/_widgets.dart';
import 'loadingGuidePage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Define the callback function type
typedef ImagePathCallback = void Function(String);

class Step4GuidePage extends StatefulWidget {
  final int totalSteps;
  final int currentStep;
  Map<String, Set<Object>> myMap = {};
  final String aboutGuide;

  Step4GuidePage({
    Key? key,
    required this.totalSteps,
    required this.currentStep,
    required this.myMap,
    required this.aboutGuide,
  }) : super(key: key);

  @override
  State<Step4GuidePage> createState() => _Step4GuidePageState();
}

class _Step4GuidePageState extends State<Step4GuidePage>
    with BlocProvider<Step4GuidePage, Step4GuidePageBloc> {
  @override
  initBloc() => Step4GuidePageBloc(widget.myMap);

  @override
  void initState() {
    super.initState();
    bloc.aboutGuide = widget.aboutGuide;
    bloc.isCheck = isChecked;
  }

  late List<Voyage> myList = [];
  String selectedImagePath = 'images/avatar_placeholder.png';

  String? validationMessageName = '';
  String? validationMessagePhone = '';
  String? validationMessageEse = '';
  String? validationMessageSiren = '';
  bool isFormValid = false;
  bool isChecked = false;
  bool imageSize = false;

  double calculateProgress() {
    return widget.currentStep / widget.totalSteps;
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

  void updateFormValidity() {
    setState(() {
      if (isChecked) {
        isFormValid = validationMessageName == null &&
            validationMessagePhone == null &&
            validationMessageEse == null &&
            validationMessageSiren == null;
      } else {
        isFormValid = validationMessageName == null &&
            validationMessagePhone == null;
      }
    });
  }

  Widget displaySelectedImage(String imagePath) {
    if (imagePath.startsWith('/')) {
      // Local file path (from device)
      return Image.file(File(imagePath), fit: BoxFit.cover);
    } else {
      // Asset image
      return Image.asset(imagePath, fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = calculateProgress();
    bool result = false;

    return Scaffold(
      body: AsyncForm(
          onValidated: () async {
            bool success = await bloc.makeProfileGuide();
            if (success) {
              navigateTo(context, (_) => LoadingGuidePage());
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
                      SizedBox(height: ResponsiveSize.calculateHeight(100, context)),
                      SizedBox(
                        width: ResponsiveSize.calculateWidth(108, context),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: AppResources.colorImputStroke,
                          color: AppResources.colorVitamine,
                          borderRadius: BorderRadius.circular(3.5),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.calculateHeight(33, context)),
                      Text(
                        AppLocalizations.of(context)!.some_information_text,
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
                                  mask: displaySelectedImage(selectedImagePath),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isChecked = !isChecked;
                                      bloc.isCheck = isChecked;
                                      updateFormValidity();
                                    });
                                  },
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(4.0),
                                      color: Colors.white,
                                    ),
                                    child: isChecked
                                        ? Icon(
                                      Icons.check,
                                      size: 10.0,
                                      color: Colors.black,
                                    )
                                        : null,
                                  ),
                                ),
                                SizedBox(width: ResponsiveSize.calculateWidth(12, context)),
                                Text(
                                  AppLocalizations.of(context)!.profession_text,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppResources.colorGray45),
                                )
                              ],
                            ),
                            SizedBox(height: ResponsiveSize.calculateHeight(21, context)),
                            Container(
                              height: ResponsiveSize.calculateHeight(28, context),
                              child: TextFormField(
                                enabled: isChecked,
                                keyboardType: TextInputType.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: isChecked ? AppResources.colorGray100 : AppResources.colorGray15),
                                decoration: InputDecoration(
                                  filled: false,
                                  hintText: AppLocalizations.of(context)!.name_society_text,
                                  hintStyle: isChecked
                                      ? Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorGray60)
                                      : Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorGray15),
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
                                    borderSide: BorderSide(color: AppResources.colorGray15),
                                  ),
                                  disabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: AppResources.colorGray15),
                                  ),
                                  focusedErrorBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: AppResources.colorGray15),
                                  ),
                                ),
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (value) => validate(),
                                //validator: AppResources.validatorNotEmpty,
                                onSaved: (value) => bloc.nameOfSociety = value,
                                onChanged: (value) {
                                  setState(() {
                                    validationMessageEse=
                                        AppResources.validatorNotEmpty(value);
                                    updateFormValidity();
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: ResponsiveSize.calculateHeight(21, context)),
                            Container(
                              height: ResponsiveSize.calculateHeight(28, context),
                              child: TextFormField(
                                enabled: isChecked,
                                keyboardType: TextInputType.number,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: isChecked ? AppResources.colorGray100 : AppResources.colorGray15),
                                decoration: InputDecoration(
                                  filled: false,
                                  hintText: AppLocalizations.of(context)!.number_siren_text,
                                  hintStyle: isChecked
                                    ? Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorGray60)
                                  : Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorGray15),
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
                                    borderSide: BorderSide(color: AppResources.colorGray15),
                                  ),
                                  disabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: AppResources.colorGray15),
                                  ),
                                  focusedErrorBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: AppResources.colorGray15),
                                  ),
                                ),
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (value) => validate(),
                                //validator: AppResources.validatorSiren,
                                onSaved: (value) => bloc.siren = value,
                                onChanged: (value) {
                                  setState(() {
                                    validationMessageSiren =
                                        AppResources.validatorSiren(value);
                                    updateFormValidity();
                                  });
                                },
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

class Step4GuidePageBloc with Disposable {
  String? aboutGuide;
  String? name;
  String? phone;
  String? nameOfSociety;
  String? siren;
  String? imagePath;
  bool? isCheck;
  Map<String, Set<Object>> myMap;

  // Create a new map with lists instead of sets
  Map<String, dynamic> modifiedMap = {};

  Step4GuidePageBloc(this.myMap);

  Future<bool> makeProfileGuide() async {
    try {
      if (isCheck == false) {
        // Only send data if isChecked is false
        modifiedMap['name'] = name!;
        modifiedMap['phone_number'] = phone!;
        modifiedMap['a_propos_de_toi_fr'] = aboutGuide!;
        // Convert sets to lists
        myMap.forEach((key, value) {
          modifiedMap[key] = value.toList();
        });
        final response = await AppService.api.sendListGuide(modifiedMap, imagePath?.isNotEmpty == true ? imagePath! : null);
        if (response == true) {
          return true;
        } else {
          return false;
        }
      } else {
        // Send all data if isChecked is true
        if (name != null && phone != null && nameOfSociety != null && siren != null) {
          // Insert name, phone, nameOfSociety, siren, and imagePath into modifiedMap
          modifiedMap['name'] = name!;
          modifiedMap['phone_number'] = phone!;
          modifiedMap['name_of_company'] = nameOfSociety!;
          modifiedMap['siren_number'] = siren!;
          modifiedMap['a_propos_de_toi_fr'] = aboutGuide!;

          // Convert sets to lists
          myMap.forEach((key, value) {
            modifiedMap[key] = value.toList();
          });

          // Perform the API call
          final response = await AppService.api.sendListGuide(modifiedMap, imagePath?.isNotEmpty == true ? imagePath! : null);
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

