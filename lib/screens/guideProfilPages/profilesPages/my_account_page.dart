import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meet_pe/utils/message.dart';

import '../../../resources/resources.dart';
import '../../../services/app_service.dart';
import '../../../utils/responsive_size.dart';
import '../../../widgets/themed/ep_app_bar.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key, required this.iBAN, required this.email});
  final String? iBAN;
  final String email;

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  late TextEditingController _textEditingControllerFirstName;
  late TextEditingController _textEditingControllerLastName;
  late TextEditingController _textEditingControllerCurrentPassword;
  late TextEditingController _textEditingControllerNewPassword;
  late TextEditingController _textEditingControllerIBAN;
  late TextEditingController _textEditingControllerBIC;
  late TextEditingController _textEditingControllerNameTitulaire;
  late TextEditingController _textEditingControllerRue;
  late TextEditingController _textEditingControllerVille;
  late TextEditingController _textEditingControllerZip;
  String? validationMessageFirstName = '';
  String? validationMessageLastName = '';
  String? validationMessageCurrentPassword = '';
  String? validationMessageNewPassword = '';
  String? validationMessageIBAN = '';
  String? validationMessageBIC = '';
  String? validationMessageNameTitulaire = '';
  String? validationMessageRue = '';
  String? validationMessageVille = '';
  String? validationMessageZip = '';
  bool isFormValid = false;
  String selectedImagePath = 'Ajouter un document';

  @override
  void initState() {
    super.initState();
    _textEditingControllerFirstName = TextEditingController();
    _textEditingControllerFirstName.addListener(_onTextChanged);
    _textEditingControllerLastName = TextEditingController();
    _textEditingControllerLastName.addListener(_onTextChanged);
    _textEditingControllerCurrentPassword = TextEditingController();
    _textEditingControllerCurrentPassword.addListener(_onTextChanged);
    _textEditingControllerNewPassword = TextEditingController();
    _textEditingControllerNewPassword.addListener(_onTextChanged);
    _textEditingControllerIBAN = TextEditingController();
    _textEditingControllerIBAN.addListener(_onTextChanged);
    _textEditingControllerBIC = TextEditingController();
    _textEditingControllerBIC.addListener(_onTextChanged);
    _textEditingControllerNameTitulaire = TextEditingController();
    _textEditingControllerNameTitulaire.addListener(_onTextChanged);
    _textEditingControllerRue = TextEditingController();
    _textEditingControllerRue.addListener(_onTextChanged);
    _textEditingControllerVille = TextEditingController();
    _textEditingControllerVille.addListener(_onTextChanged);
    _textEditingControllerZip = TextEditingController();
    _textEditingControllerZip.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textEditingControllerFirstName.removeListener(_onTextChanged);
    _textEditingControllerFirstName.dispose();
    _textEditingControllerLastName.removeListener(_onTextChanged);
    _textEditingControllerLastName.dispose();
    _textEditingControllerCurrentPassword.removeListener(_onTextChanged);
    _textEditingControllerCurrentPassword.dispose();
    _textEditingControllerNewPassword.removeListener(_onTextChanged);
    _textEditingControllerNewPassword.dispose();
    _textEditingControllerIBAN.removeListener(_onTextChanged);
    _textEditingControllerIBAN.dispose();
    _textEditingControllerBIC.removeListener(_onTextChanged);
    _textEditingControllerBIC.dispose();
    _textEditingControllerNameTitulaire.removeListener(_onTextChanged);
    _textEditingControllerNameTitulaire.dispose();
    _textEditingControllerRue.removeListener(_onTextChanged);
    _textEditingControllerRue.dispose();
    _textEditingControllerVille.removeListener(_onTextChanged);
    _textEditingControllerVille.dispose();
    _textEditingControllerZip.removeListener(_onTextChanged);
    _textEditingControllerZip.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      //_showButton = _textEditingControllerName.text.isEmpty;
    });
  }

  void updateFormValidity() {
    setState(() {
      isFormValid =
          validationMessageFirstName == null && validationMessageLastName == null;
    });
  }

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
      updateFormValidity();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EpAppBar(
        title: 'Mon Compte',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.calculateWidth(31, context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informations de connexion',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                        fontSize: 20, color: AppResources.colorDark),
                  ),
                  const SizedBox(height: 17),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppResources.colorGray30),
                  ),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return Container(
                                    width: double.infinity,
                                    height: 357,
                                    color: AppResources.colorWhite,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 28),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const SizedBox(height: 39),
                                          Text(
                                            'Nom & Prénom',
                                            style: Theme.of(context).textTheme.headlineMedium,
                                          ),
                                          Column(
                                            children: [
                                              TextFormField(
                                                controller: _textEditingControllerFirstName,
                                                keyboardType: TextInputType.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(color: AppResources.colorDark),
                                                decoration: InputDecoration(
                                                  filled: false,
                                                  hintText: 'Ton prénom',
                                                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                                                  contentPadding: EdgeInsets.only(
                                                      top: ResponsiveSize.calculateHeight(20, context),
                                                      bottom:
                                                      ResponsiveSize.calculateHeight(10, context)),
                                                  // Adjust padding
                                                  suffix: SizedBox(
                                                      height:
                                                      ResponsiveSize.calculateHeight(10, context)),
                                                  enabledBorder: const UnderlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: AppResources.colorGray15),
                                                  ),
                                                  focusedBorder: const UnderlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: AppResources.colorGray15),
                                                  ),
                                                  errorBorder: const UnderlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.red),
                                                  ),
                                                ),
                                                autofocus: true,
                                                textInputAction: TextInputAction.done,
                                                //onFieldSubmitted: (value) => validate(),
                                                validator: AppResources.validatorNotEmpty,
                                                //onSaved: (value) => bloc.name = value,
                                                onChanged: (value) {
                                                  setState(() {
                                                    validationMessageFirstName =
                                                        AppResources.validatorNotEmpty(value);
                                                    updateFormValidity();
                                                  });
                                                },
                                              ),
                                              const SizedBox(height: 40),
                                              TextFormField(
                                                controller: _textEditingControllerLastName,
                                                keyboardType: TextInputType.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(color: AppResources.colorDark),
                                                decoration: InputDecoration(
                                                  filled: false,
                                                  hintText: 'Ton nom',
                                                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                                                  contentPadding: EdgeInsets.only(
                                                      top: ResponsiveSize.calculateHeight(20, context),
                                                      bottom:
                                                      ResponsiveSize.calculateHeight(10, context)),
                                                  // Adjust padding
                                                  suffix: SizedBox(
                                                      height:
                                                      ResponsiveSize.calculateHeight(10, context)),
                                                  enabledBorder: const UnderlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: AppResources.colorGray15),
                                                  ),
                                                  focusedBorder: const UnderlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: AppResources.colorGray15),
                                                  ),
                                                  errorBorder: const UnderlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.red),
                                                  ),
                                                ),
                                                autofocus: true,
                                                textInputAction: TextInputAction.done,
                                                //onFieldSubmitted: (value) => validate(),
                                                validator: AppResources.validatorNotEmpty,
                                                //onSaved: (value) => bloc.name = value,
                                                onChanged: (value) {
                                                  setState(() {
                                                    validationMessageLastName =
                                                        AppResources.validatorNotEmpty(value);
                                                    updateFormValidity();
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 53),
                                          Container(
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
                                                    side: BorderSide(width: 1, color: AppResources.colorDark),
                                                    borderRadius: BorderRadius.circular(40),
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                                'ENREGISTRER',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.copyWith(color: AppResources.colorDark),
                                              ),
                                              onPressed: () async {
                                                // Call the asynchronous operation and handle its completion
                                                AppService.api.updateName(_textEditingControllerFirstName.text, _textEditingControllerLastName.text).then((_) {
                                                  // Optionally, you can perform additional actions after the operation completes
                                                  Navigator.pop(context);
                                                }).catchError((error) {
                                                  // Handle any errors that occur during the asynchronous operation
                                                  print('Error: $error');
                                                  Navigator.pop(context);
                                                  if(error.toString() != "type 'Null' is not a subtype of type 'bool' in type cast") {
                                                    showMessage(context, error.toString());
                                                  }

                                                });
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
                          }
                      );
                    },
                    child: accountRowDefault('Nom & prénom', '', true)
                  ),
                  accountRowDefault('Numéro de téléphone', '+xx xx xx xx xx 92', true),
                  accountRowDefault('e-mail', widget.email, false),
                  GestureDetector(
                      onTap: () {
                        showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).viewInsets.bottom),
                                child: StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return Container(
                                      width: double.infinity,
                                      height: 357,
                                      color: AppResources.colorWhite,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 28),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            const SizedBox(height: 39),
                                            Text(
                                              'Mot de passe',
                                              style: Theme.of(context).textTheme.headlineMedium,
                                            ),
                                            Column(
                                              children: [
                                                TextFormField(
                                                  controller: _textEditingControllerCurrentPassword,
                                                  keyboardType: TextInputType.visiblePassword,
                                                  obscureText: true,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(color: AppResources.colorDark),
                                                  decoration: InputDecoration(
                                                    filled: false,
                                                    hintText: 'Current mot de passe',
                                                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                                                    contentPadding: EdgeInsets.only(
                                                        top: ResponsiveSize.calculateHeight(20, context),
                                                        bottom:
                                                        ResponsiveSize.calculateHeight(10, context)),
                                                    // Adjust padding
                                                    suffix: SizedBox(
                                                        height:
                                                        ResponsiveSize.calculateHeight(10, context)),
                                                    enabledBorder: const UnderlineInputBorder(
                                                      borderSide:
                                                      BorderSide(color: AppResources.colorGray15),
                                                    ),
                                                    focusedBorder: const UnderlineInputBorder(
                                                      borderSide:
                                                      BorderSide(color: AppResources.colorGray15),
                                                    ),
                                                    errorBorder: const UnderlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.red),
                                                    ),
                                                  ),
                                                  autofocus: true,
                                                  textInputAction: TextInputAction.done,
                                                  //onFieldSubmitted: (value) => validate(),
                                                  validator: AppResources.validatorPassword,
                                                  //onSaved: (value) => bloc.name = value,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      validationMessageCurrentPassword =
                                                          AppResources.validatorPassword(value);
                                                      updateFormValidity();
                                                    });
                                                  },
                                                ),
                                                const SizedBox(height: 40),
                                                TextFormField(
                                                  controller: _textEditingControllerNewPassword,
                                                  keyboardType: TextInputType.visiblePassword,
                                                  obscureText: true,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(color: AppResources.colorDark),
                                                  decoration: InputDecoration(
                                                    filled: false,
                                                    hintText: 'Nouveau mot de passe',
                                                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                                                    contentPadding: EdgeInsets.only(
                                                        top: ResponsiveSize.calculateHeight(20, context),
                                                        bottom:
                                                        ResponsiveSize.calculateHeight(10, context)),
                                                    // Adjust padding
                                                    suffix: SizedBox(
                                                        height:
                                                        ResponsiveSize.calculateHeight(10, context)),
                                                    enabledBorder: const UnderlineInputBorder(
                                                      borderSide:
                                                      BorderSide(color: AppResources.colorGray15),
                                                    ),
                                                    focusedBorder: const UnderlineInputBorder(
                                                      borderSide:
                                                      BorderSide(color: AppResources.colorGray15),
                                                    ),
                                                    errorBorder: const UnderlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.red),
                                                    ),
                                                  ),
                                                  autofocus: true,
                                                  textInputAction: TextInputAction.done,
                                                  //onFieldSubmitted: (value) => validate(),
                                                  validator: AppResources.validatorPassword,
                                                  //onSaved: (value) => bloc.name = value,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      validationMessageNewPassword =
                                                          AppResources.validatorPassword(value);
                                                      updateFormValidity();
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 53),
                                            Container(
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
                                                      side: BorderSide(width: 1, color: AppResources.colorDark),
                                                      borderRadius: BorderRadius.circular(40),
                                                    ),
                                                  ),
                                                ),
                                                child: Text(
                                                  'ENREGISTRER',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.copyWith(color: AppResources.colorDark),
                                                ),
                                                onPressed: () async {
                                                  // Call the asynchronous operation and handle its completion
                                                  AppService.api.updatePassword(_textEditingControllerCurrentPassword.text, _textEditingControllerNewPassword.text).then((_) {
                                                    // Optionally, you can perform additional actions after the operation completes
                                                    Navigator.pop(context);
                                                  }).catchError((error) {
                                                    // Handle any errors that occur during the asynchronous operation
                                                    print('Error: $error');
                                                    Navigator.pop(context);
                                                    if(error.toString() != "type 'Null' is not a subtype of type 'bool' in type cast") {
                                                      showMessage(context, error.toString());
                                                    }

                                                  });
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
                            }
                        );
                      },
                      child: accountRowDefault('mot de passe', '********', true),
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return Container(
                                    width: double.infinity,
                                    height: 432,
                                    color: AppResources.colorWhite,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 28),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const SizedBox(height: 39),
                                          Text(
                                            'Adresse',
                                            style: Theme.of(context).textTheme.headlineMedium,
                                          ),
                                          Column(
                                            children: [
                                              TextFormField(
                                                controller: _textEditingControllerRue,
                                                keyboardType: TextInputType.streetAddress,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(color: AppResources.colorDark),
                                                decoration: InputDecoration(
                                                  filled: false,
                                                  hintText: 'rue',
                                                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                                                  contentPadding: EdgeInsets.only(
                                                      top: ResponsiveSize.calculateHeight(20, context),
                                                      bottom:
                                                      ResponsiveSize.calculateHeight(10, context)),
                                                  // Adjust padding
                                                  suffix: SizedBox(
                                                      height:
                                                      ResponsiveSize.calculateHeight(10, context)),
                                                  enabledBorder: const UnderlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: AppResources.colorGray15),
                                                  ),
                                                  focusedBorder: const UnderlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: AppResources.colorGray15),
                                                  ),
                                                  errorBorder: const UnderlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.red),
                                                  ),
                                                ),
                                                autofocus: true,
                                                textInputAction: TextInputAction.done,
                                                //onFieldSubmitted: (value) => validate(),
                                                validator: AppResources.validatorNotEmpty,
                                                //onSaved: (value) => bloc.name = value,
                                                onChanged: (value) {
                                                  setState(() {
                                                    validationMessageRue =
                                                        AppResources.validatorNotEmpty(value);
                                                    updateFormValidity();
                                                  });
                                                },
                                              ),
                                              const SizedBox(height: 40),
                                              TextFormField(
                                                controller: _textEditingControllerVille,
                                                keyboardType: TextInputType.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(color: AppResources.colorDark),
                                                decoration: InputDecoration(
                                                  filled: false,
                                                  hintText: 'Ville',
                                                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                                                  contentPadding: EdgeInsets.only(
                                                      top: ResponsiveSize.calculateHeight(20, context),
                                                      bottom:
                                                      ResponsiveSize.calculateHeight(10, context)),
                                                  // Adjust padding
                                                  suffix: SizedBox(
                                                      height:
                                                      ResponsiveSize.calculateHeight(10, context)),
                                                  enabledBorder: const UnderlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: AppResources.colorGray15),
                                                  ),
                                                  focusedBorder: const UnderlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: AppResources.colorGray15),
                                                  ),
                                                  errorBorder: const UnderlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.red),
                                                  ),
                                                ),
                                                autofocus: true,
                                                textInputAction: TextInputAction.done,
                                                //onFieldSubmitted: (value) => validate(),
                                                validator: AppResources.validatorNotEmpty,
                                                //onSaved: (value) => bloc.name = value,
                                                onChanged: (value) {
                                                  setState(() {
                                                    validationMessageVille =
                                                        AppResources.validatorNotEmpty(value);
                                                    updateFormValidity();
                                                  });
                                                },
                                              ),
                                              const SizedBox(height: 40),
                                              TextFormField(
                                                controller: _textEditingControllerZip,
                                                keyboardType: TextInputType.number,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(color: AppResources.colorDark),
                                                decoration: InputDecoration(
                                                  filled: false,
                                                  hintText: 'Code Postal',
                                                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                                                  contentPadding: EdgeInsets.only(
                                                      top: ResponsiveSize.calculateHeight(20, context),
                                                      bottom:
                                                      ResponsiveSize.calculateHeight(10, context)),
                                                  // Adjust padding
                                                  suffix: SizedBox(
                                                      height:
                                                      ResponsiveSize.calculateHeight(10, context)),
                                                  enabledBorder: const UnderlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: AppResources.colorGray15),
                                                  ),
                                                  focusedBorder: const UnderlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: AppResources.colorGray15),
                                                  ),
                                                  errorBorder: const UnderlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.red),
                                                  ),
                                                ),
                                                autofocus: true,
                                                textInputAction: TextInputAction.done,
                                                //onFieldSubmitted: (value) => validate(),
                                                validator: AppResources.validatorNotEmpty,
                                                //onSaved: (value) => bloc.name = value,
                                                onChanged: (value) {
                                                  setState(() {
                                                    validationMessageZip =
                                                        AppResources.validatorNotEmpty(value);
                                                    updateFormValidity();
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 53),
                                          Container(
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
                                                    side: BorderSide(width: 1, color: AppResources.colorDark),
                                                    borderRadius: BorderRadius.circular(40),
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                                'ENREGISTRER',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.copyWith(color: AppResources.colorDark),
                                              ),
                                              onPressed: () async {
                                                // Call the asynchronous operation and handle its completion
                                                AppService.api.updateAddressInfo(_textEditingControllerRue.text, _textEditingControllerVille.text, _textEditingControllerZip.text).then((_) {
                                                  // Optionally, you can perform additional actions after the operation completes
                                                  Navigator.pop(context);
                                                }).catchError((error) {
                                                  // Handle any errors that occur during the asynchronous operation
                                                  print('Error: $error');
                                                  Navigator.pop(context);
                                                  if(error.toString() != "type 'Null' is not a subtype of type 'bool' in type cast") {
                                                    showMessage(context, error.toString());
                                                  }

                                                });
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
                          }
                      );
                    },
                    child: accountRowDefault('adresse', '', true),
                  ),
                  accountRowDefault('sécurité & vie privée', '', true),
                  const SizedBox(height: 20),
                  Text(
                    'Informations bancaires',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                        fontSize: 20, color: AppResources.colorDark),
                  ),
                  const SizedBox(height: 17),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppResources.colorGray30),
                  ),
                  const SizedBox(height: 17),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: StatefulBuilder(
                          builder: (BuildContext context,
                              StateSetter setState) {
                            return Container(
                              width: double.infinity,
                              height: 432,
                              color: AppResources.colorWhite,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 28),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(height: 39),
                                    Text(
                                      'Informations bancaires',
                                      style: Theme.of(context).textTheme.headlineMedium,
                                    ),
                                    Column(
                                      children: [
                                        TextFormField(
                                          controller: _textEditingControllerIBAN,
                                          keyboardType: TextInputType.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(color: AppResources.colorDark),
                                          decoration: InputDecoration(
                                            filled: false,
                                            hintText: 'IBAN',
                                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                                            contentPadding: EdgeInsets.only(
                                                top: ResponsiveSize.calculateHeight(20, context),
                                                bottom:
                                                ResponsiveSize.calculateHeight(10, context)),
                                            // Adjust padding
                                            suffix: SizedBox(
                                                height:
                                                ResponsiveSize.calculateHeight(10, context)),
                                            enabledBorder: const UnderlineInputBorder(
                                              borderSide:
                                              BorderSide(color: AppResources.colorGray15),
                                            ),
                                            focusedBorder: const UnderlineInputBorder(
                                              borderSide:
                                              BorderSide(color: AppResources.colorGray15),
                                            ),
                                            errorBorder: const UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.red),
                                            ),
                                          ),
                                          autofocus: true,
                                          textInputAction: TextInputAction.done,
                                          //onFieldSubmitted: (value) => validate(),
                                          validator: AppResources.validatorNotEmpty,
                                          //onSaved: (value) => bloc.name = value,
                                          onChanged: (value) {
                                            setState(() {
                                              validationMessageIBAN =
                                                  AppResources.validatorNotEmpty(value);
                                              updateFormValidity();
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 40),
                                        TextFormField(
                                          controller: _textEditingControllerBIC,
                                          keyboardType: TextInputType.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(color: AppResources.colorDark),
                                          decoration: InputDecoration(
                                            filled: false,
                                            hintText: 'BIC',
                                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                                            contentPadding: EdgeInsets.only(
                                                top: ResponsiveSize.calculateHeight(20, context),
                                                bottom:
                                                ResponsiveSize.calculateHeight(10, context)),
                                            // Adjust padding
                                            suffix: SizedBox(
                                                height:
                                                ResponsiveSize.calculateHeight(10, context)),
                                            enabledBorder: const UnderlineInputBorder(
                                              borderSide:
                                              BorderSide(color: AppResources.colorGray15),
                                            ),
                                            focusedBorder: const UnderlineInputBorder(
                                              borderSide:
                                              BorderSide(color: AppResources.colorGray15),
                                            ),
                                            errorBorder: const UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.red),
                                            ),
                                          ),
                                          autofocus: true,
                                          textInputAction: TextInputAction.done,
                                          //onFieldSubmitted: (value) => validate(),
                                          validator: AppResources.validatorNotEmpty,
                                          //onSaved: (value) => bloc.name = value,
                                          onChanged: (value) {
                                            setState(() {
                                              validationMessageBIC =
                                                  AppResources.validatorNotEmpty(value);
                                              updateFormValidity();
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 40),
                                        TextFormField(
                                          controller: _textEditingControllerNameTitulaire,
                                          keyboardType: TextInputType.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(color: AppResources.colorDark),
                                          decoration: InputDecoration(
                                            filled: false,
                                            hintText: 'Nom du titulaire du compte',
                                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                                            contentPadding: EdgeInsets.only(
                                                top: ResponsiveSize.calculateHeight(20, context),
                                                bottom:
                                                ResponsiveSize.calculateHeight(10, context)),
                                            // Adjust padding
                                            suffix: SizedBox(
                                                height:
                                                ResponsiveSize.calculateHeight(10, context)),
                                            enabledBorder: const UnderlineInputBorder(
                                              borderSide:
                                              BorderSide(color: AppResources.colorGray15),
                                            ),
                                            focusedBorder: const UnderlineInputBorder(
                                              borderSide:
                                              BorderSide(color: AppResources.colorGray15),
                                            ),
                                            errorBorder: const UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.red),
                                            ),
                                          ),
                                          autofocus: true,
                                          textInputAction: TextInputAction.done,
                                          //onFieldSubmitted: (value) => validate(),
                                          validator: AppResources.validatorNotEmpty,
                                          //onSaved: (value) => bloc.name = value,
                                          onChanged: (value) {
                                            setState(() {
                                              validationMessageNameTitulaire =
                                                  AppResources.validatorNotEmpty(value);
                                              updateFormValidity();
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 53),
                                    Container(
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
                                              side: BorderSide(width: 1, color: AppResources.colorDark),
                                              borderRadius: BorderRadius.circular(40),
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'ENREGISTRER',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(color: AppResources.colorDark),
                                        ),
                                        onPressed: () async {
                                          // Call the asynchronous operation and handle its completion
                                          AppService.api.updateBankInfo(_textEditingControllerIBAN.text, _textEditingControllerBIC.text, _textEditingControllerNameTitulaire.text).then((_) {
                                            // Optionally, you can perform additional actions after the operation completes
                                            Navigator.pop(context);
                                          }).catchError((error) {
                                            // Handle any errors that occur during the asynchronous operation
                                            print('Error: $error');
                                            Navigator.pop(context);
                                            if(error.toString() != "type 'Null' is not a subtype of type 'bool' in type cast") {
                                              showMessage(context, error.toString());
                                            }

                                          });
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
                    }
                );
              },
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(25, context)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Informations de compte bancaire',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorDark),
                        ),
                        Row(
                          children: [
                            Visibility(
                              visible: widget.iBAN == null,
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
                  ),
                  const SizedBox(height: 19),
                  /*Container(
                    width: 390,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: AppResources.colorImputStroke,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(25, context)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Informations de paiement',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorDark),
                        ),
                        Image.asset('images/chevron_right.png',
                            width: 27, height: 27, fit: BoxFit.fill),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(25, context)),
                    child: Row(
                      children: [
                        Image.asset('images/bank_logo.png'),
                        const SizedBox(width: 21),
                        Text(
                          'xxxx xxxx xxxx 792',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400, color: AppResources.colorDark),
                        )
                      ],
                    )
                  ),
                  const SizedBox(height: 42),*/
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(30, context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mes documents',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                        fontSize: 20, color: AppResources.colorDark),
                  ),
                  const SizedBox(height: 17),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppResources.colorGray30),
                  ),
                  const SizedBox(height: 17),
                  GestureDetector(
                      onTap: () {
                        showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).viewInsets.bottom),
                                child: StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return Container(
                                      width: double.infinity,
                                      height: 357,
                                      color: AppResources.colorWhite,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 28),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            const SizedBox(height: 39),
                                            Text(
                                              'Ma pièce d’identité',
                                              style: Theme.of(context).textTheme.headlineMedium,
                                            ),
                                            const SizedBox(height: 39),
                                            GestureDetector(
                                              onTap: () {
                                                pickImage();
                                              },
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons.add, size: 24, color: Color(0xFF1C1B1F)),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        selectedImagePath,
                                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorGray60),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Container(
                                                    height: 1,
                                                    color: AppResources.colorGray15,
                                                  )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 53),
                                            Container(
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
                                                      side: BorderSide(width: 1, color: AppResources.colorDark),
                                                      borderRadius: BorderRadius.circular(40),
                                                    ),
                                                  ),
                                                ),
                                                child: Text(
                                                  'ENREGISTRER',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.copyWith(color: AppResources.colorDark),
                                                ),
                                                onPressed: () async {
                                                  // Call the asynchronous operation and handle its completion
                                                  AppService.api.sendIdCard(selectedImagePath,).then((_) {
                                                    // Optionally, you can perform additional actions after the operation completes
                                                    Navigator.pop(context);
                                                  }).catchError((error) {
                                                    // Handle any errors that occur during the asynchronous operation
                                                    print('Error: $error');
                                                    Navigator.pop(context);
                                                    if(error.toString() != "type 'Null' is not a subtype of type 'bool' in type cast") {
                                                      showMessage(context, error.toString());
                                                    }

                                                  });
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
                            }
                        );
                      },
                      child: accountRowDefault('Ma pièce d’identité', '', true)
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                AppService.api.deleteUser();
                AppService.instance.logOut;
              },
              child: Text(
                  'Supprimer mon compte',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500, color: AppResources.colorGray30)
              ),
            ),
            const SizedBox(height: 65),
          ],
        ),
      ),
    );
  }

  Widget accountRowDefault(String name, String? info, bool modify) {
    return Column(
      children: [
        const SizedBox(height: 19),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorDark),
            ),
            Row(
              children: [
                Text(
                  info ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400, color: modify ? AppResources.colorDark : Color(0xFFBBBBBB)),
                ),
                Visibility(
                  visible: modify,
                  child: Image.asset('images/chevron_right.png',
                      width: 27, height: 27, fit: BoxFit.fill),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 19),
        Container(
          width: 390,
          decoration: const ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                strokeAlign: BorderSide.strokeAlignCenter,
                color: AppResources.colorImputStroke,
              ),
            ),
          ),
        )
      ],
    );
  }
}
