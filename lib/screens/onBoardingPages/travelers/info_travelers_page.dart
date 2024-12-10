import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:meet_pe/screens/onBoardingPages/travelers/step1Page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:widget_mask/widget_mask.dart';

import '../../../services/app_service.dart';
import 'package:meet_pe/utils/_utils.dart';
import '../../../widgets/_widgets.dart';

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
  bool isFormValid = false;
  bool imageSize = false;

  @override
  initBloc() => InfoTravelersPageBloc();

  @override
  void initState() {
    super.initState();
  }

  void updateFormValidity() {
    setState(() {
      isFormValid = validationMessageName == null &&
          validationMessagePhone == null;
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
              imageSize = true;
              selectedImagePath = imagePath;
              bloc.imagePath = imagePath;
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
            imageSize = true;
            selectedImagePath = imagePath;
            bloc.imagePath = imagePath;
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
    return Scaffold(
      body: AsyncForm(
          onValidated: () async {
            bool success = await bloc.setVoyageurProfile();
            if (success) {
              navigateTo(context, (_) => const Step1Page(totalSteps: 7, currentStep: 1,));
            } else {
              showMessage(context, "Échec du téléchargement de l'image. Veuillez réessayer.");
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
                        'On m’a dit que les prénoms cool commencaient par la première lettre de ton prénom...',
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
                                  hintText: 'Ton prénom',
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
                                  hintText: 'Ton numéro de téléphone',
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
  String? imagePath;

  InfoTravelersPageBloc();

  Future<bool> setVoyageurProfile() async {
    try {
      if (name != null && phone != null) {

        // Perform the API call
        final response = await AppService.api.setTravelersProfile(name!, phone!, imagePath?.isNotEmpty == true ? imagePath! : null);
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

