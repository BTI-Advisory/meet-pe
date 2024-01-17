import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:widget_mask/widget_mask.dart';

import '../../../services/app_service.dart';
import 'package:meet_pe/utils/_utils.dart';
import '../../../widgets/async_form.dart';

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
  String? validationMessageEmail = '';
  bool isFormValid = false;

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
    });
  }

  void updateFormValidity() {
    setState(() {
      isFormValid = validationMessageName == null &&
          validationMessagePhone == null &&
          validationMessageEmail == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = calculateProgress();

    return Scaffold(
      body: AsyncForm(
          onValidated: bloc.makeProfileGuide,
          onSuccess: () async {
            bool isVerified = await bloc.makeProfileGuide();
            if (isVerified) {
              //return navigateTo(context, (_) => SignInPage(email: bloc.email!));
            } else {
              //return navigateTo(context, (_) => SignUpPage(email: bloc.email!));
            }
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
                    SizedBox(
                      height: 120,
                    ),
                    SizedBox(
                      width: 108,
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: AppResources.colorImputStroke,
                        color: AppResources.colorVitamine,
                        borderRadius: BorderRadius.circular(3.5),
                      ),
                    ),
                    const SizedBox(
                      height: 33,
                    ),
                    Text(
                      'Quelques informations...',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: AppResources.colorGray100),
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 168,
                              height: 168,
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
                                width: 44,
                                height: 44,
                                //padding: const EdgeInsets.all(10),
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
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
                    const SizedBox(
                      height: 72,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        children: [
                          Container(
                            height: 28,
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
                                contentPadding: const EdgeInsets.only(
                                    top: 20.0, bottom: 10.0),
                                // Adjust padding
                                suffix: const SizedBox(height: 10),
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
                          SizedBox(height: 40),
                          Container(
                            height: 28,
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppResources.colorGray100),
                              decoration: InputDecoration(
                                filled: false,
                                hintText: 'Ton numéro de téléphone',
                                hintStyle:
                                    Theme.of(context).textTheme.bodyMedium,
                                contentPadding: const EdgeInsets.only(
                                    top: 20.0, bottom: 10.0),
                                // Adjust padding
                                suffix: const SizedBox(height: 10),
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
                          SizedBox(height: 40),
                          Container(
                            height: 28,
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppResources.colorGray100),
                              decoration: InputDecoration(
                                filled: false,
                                hintText: 'Ton email',
                                hintStyle:
                                    Theme.of(context).textTheme.bodyMedium,
                                contentPadding: const EdgeInsets.only(
                                    top: 20.0, bottom: 10.0),
                                // Adjust padding
                                suffix: const SizedBox(height: 10),
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
                              validator: AppResources.validatorEmail,
                              onSaved: (value) => bloc.email = value,
                              onChanged: (value) {
                                setState(() {
                                  validationMessageEmail =
                                      AppResources.validatorEmail(value, true);
                                  updateFormValidity();
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 86),
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
                        ],
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 44),
                          child: Container(
                            margin: const EdgeInsets.only(left: 96, right: 96),
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 10)),
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
                                    borderRadius: BorderRadius.circular(40),
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
  String? email;
  Map<String, Set<Object>> myMap;

  // Create a new map with lists instead of sets
  Map<String, dynamic> modifiedMap = {};

  Step4GuidePageBloc(this.myMap);

  Future<bool> makeProfileGuide() async {
    try {
      // Insert name and phone into modifiedMap
      if (name != null) {
        modifiedMap['name'] = name!;
      }
      if (phone != null) {
        modifiedMap['phone_number'] = phone!;
      }

      // Convert sets to lists
      myMap.forEach((key, value) {
        modifiedMap[key] = value.toList();
      });

      // Perform the API call
      bool isVerified = await AppService.api.sendListGuide(modifiedMap);

      return isVerified;
    } catch (error) {
      // Handle the error appropriately
      print("Error in makeProfileGuide: $error");
      return false;
    }
  }

  @override
  void dispose() {
    // Dispose of any resources if needed
    super.dispose();
  }
}
