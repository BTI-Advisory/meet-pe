import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:widget_mask/widget_mask.dart';

import '../../../services/app_service.dart';
import 'package:meet_pe/utils/_utils.dart';
import '../../../utils/responsive_size.dart';
import '../../../widgets/async_form.dart';
import 'loadingGuidePage.dart';

class Step4GuidePage extends StatefulWidget {
  final int totalSteps;
  final int currentStep;
  Map<String, Set<Object>> myMap = {};

  Step4GuidePage({
    Key? key,
    required this.totalSteps,
    required this.currentStep,
    required this.myMap,
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
  }

  late List<Voyage> myList = [];
  String selectedImagePath = 'images/avatar_placeholder.png';

  String? validationMessageName = '';
  String? validationMessagePhone = '';
  bool isFormValid = false;
  bool isChecked = false;

  double calculateProgress() {
    return widget.currentStep / widget.totalSteps;
  }

  // Assume this is your function to pick an image.
  Future<void> pickImage() async {
    // Your logic to pick an image goes here.
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource
            .gallery); // Use source: ImageSource.camera for taking a new picture

    if (pickedFile != null) {
      // Do something with the picked image (e.g., upload or process it)
      //File imageFile = File(pickedFile.path);
      // Add your logic here to handle the selected image
    }
    // For demonstration purposes, I'm using a static image path.
    String imagePath = pickedFile?.path ?? '';

    setState(() {
      selectedImagePath = imagePath;
      bloc.imagePath = imagePath;
      updateFormValidity();
    });
  }

  void updateFormValidity() {
    setState(() {
      isFormValid = validationMessageName == null &&
          validationMessagePhone == null && selectedImagePath != 'images/avatar_placeholder.png';
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = calculateProgress();

    return Scaffold(
      body: AsyncForm(
          onValidated: bloc.makeProfileGuide,
          onSuccess: () {
            return navigateTo(context, (_) => LoadingGuidePage());
          },
          builder: (BuildContext context, void Function() validate) {
            return Container(
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
                      'Quelques informations...',
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
                                  onPressed: () {
                                    pickImage();
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
                              ),
                              autofocus: true,
                              textInputAction: TextInputAction.done,
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
                              ),
                              autofocus: true,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (value) => validate(),
                              validator: AppResources.validatorNotEmpty,
                              onSaved: (value) => bloc.phone = value,
                              onChanged: (value) {
                                setState(() {
                                  validationMessagePhone =
                                      AppResources.validatorNotEmpty(value);
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
                                  // Toggle the checkbox state on tap
                                  setState(() {
                                    isChecked = !isChecked;
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
                                'Je suis guide professionnel',
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
                                hintText: 'Numéro SIREN',
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
                              autofocus: true,
                              textInputAction: TextInputAction.done,
                              onSaved: (value) => bloc.siren = value,
                              onChanged: (value) {
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
                              Visibility(
                                visible: selectedImagePath ==
                                    'images/avatar_placeholder.png',
                                child: Text(
                                  'Veuillez ajouter une photo de profil \nafin d’accéder à la prochaine étape.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                      color: AppResources.colorVitamine,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              SizedBox(height: ResponsiveSize.calculateHeight(16, context)),
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
            );
          }),
    );
  }
}

class Voyage {
  final int id;
  final String title;

  Voyage({
    required this.id,
    required this.title,
  });
}

class Step4GuidePageBloc with Disposable {
  String? name;
  String? phone;
  String? siren;
  String? imagePath;
  Map<String, Set<Object>> myMap;

  // Create a new map with lists instead of sets
  Map<String, dynamic> modifiedMap = {};

  Step4GuidePageBloc(this.myMap);

  Future<void> makeProfileGuide() async {
    try {
      // Insert name and phone into modifiedMap
      if (name != null) {
        modifiedMap['name'] = name!;
      }
      if (phone != null) {
        modifiedMap['phone_number'] = phone!;
      }
      if (siren != null) {
        modifiedMap['siren_number'] = siren ?? '';
      }

      // Convert sets to lists
      myMap.forEach((key, value) {
        modifiedMap[key] = value.toList();
      });

      // Perform the API call
      await AppService.api.sendListGuide(modifiedMap, imagePath!);

    } catch (error) {
      // Handle the error appropriately
      print("Error in make Profile Guide: $error");
    }
  }

  @override
  void dispose() {
    // Dispose of any resources if needed
    super.dispose();
  }
}
