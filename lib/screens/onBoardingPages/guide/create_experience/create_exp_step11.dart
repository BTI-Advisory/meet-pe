import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../resources/resources.dart';
import '../../../../services/app_service.dart';
import '../../../../utils/responsive_size.dart';
import '../../../../utils/utils.dart';
import 'created_experience.dart';

class CreateExpStep11 extends StatefulWidget {
  CreateExpStep11({super.key, required this.sendListMap});
  Map<String, dynamic> sendListMap = {};

  @override
  State<CreateExpStep11> createState() => _CreateExpStep11State();
}

class _CreateExpStep11State extends State<CreateExpStep11> {
  late TextEditingController _textEditingControllerAdresse;
  late TextEditingController _textEditingControllerVille;
  late TextEditingController _textEditingControllerCodePostal;
  late TextEditingController _textEditingControllerCountry;
  String? validationMessageAdresse = '';
  String? validationMessageVille = '';
  String? validationMessageCodePostal = '';
  String? validationMessageCountry = '';
  bool isFormValid = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _textEditingControllerAdresse = TextEditingController();
    _textEditingControllerAdresse.addListener(_onTextChanged);
    _textEditingControllerVille = TextEditingController();
    _textEditingControllerVille.addListener(_onTextChanged);
    _textEditingControllerCodePostal = TextEditingController();
    _textEditingControllerCodePostal.addListener(_onTextChanged);
    _textEditingControllerCountry = TextEditingController();
    _textEditingControllerCountry.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textEditingControllerAdresse.removeListener(_onTextChanged);
    _textEditingControllerAdresse.dispose();
    _textEditingControllerVille.removeListener(_onTextChanged);
    _textEditingControllerVille.dispose();
    _textEditingControllerCodePostal.removeListener(_onTextChanged);
    _textEditingControllerCodePostal.dispose();
    _textEditingControllerCountry.removeListener(_onTextChanged);
    _textEditingControllerCountry.dispose();
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
          validationMessageAdresse == null && validationMessageVille == null && validationMessageCodePostal == null && validationMessageCountry == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: deviceSize.width,
          height: deviceSize.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppResources.colorGray5, AppResources.colorWhite],
            ),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(children: [
                  Image.asset(
                    'images/backgroundExp8.png',
                    width: double.infinity,
                    fit: BoxFit.fill,
                    height: ResponsiveSize.calculateHeight(190, context),
                  ),
                  Positioned(
                    top: 48,
                    left: 28,
                    child: Container(
                      width: ResponsiveSize.calculateWidth(24, context),
                      height: ResponsiveSize.calculateHeight(24, context),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              ResponsiveSize.calculateCornerRadius(40, context)),
                        ),
                      ),
                      child: FloatingActionButton(
                          heroTag: "btn1",
                          backgroundColor: AppResources.colorWhite,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            String.fromCharCode(CupertinoIcons.back.codePoint),
                            style: TextStyle(
                              inherit: false,
                              color: AppResources.colorVitamine,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w900,
                              fontFamily: CupertinoIcons
                                  .exclamationmark_circle.fontFamily,
                              package: CupertinoIcons
                                  .exclamationmark_circle.fontPackage,
                            ),
                          )),
                    ),
                  ),
                ]),
                SizedBox(height: ResponsiveSize.calculateHeight(40, context)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Étape 9 sur 9',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontSize: 10, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                          height: ResponsiveSize.calculateHeight(8, context)),
                      Text(
                        'On se retrouve où ?',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(
                          height: ResponsiveSize.calculateHeight(16, context)),
                      Text(
                        'Ou se situe votre expérience ?',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(
                          height: ResponsiveSize.calculateHeight(40, context)),
                      TextFormField(
                        controller: _textEditingControllerAdresse,
                        keyboardType: TextInputType.streetAddress,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppResources.colorDark),
                        decoration: InputDecoration(
                          filled: false,
                          hintText: 'Adresse',
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
                          focusedErrorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        //onFieldSubmitted: (value) => validate(),
                        validator: AppResources.validatorNotEmpty,
                        //onSaved: (value) => bloc.name = value,
                        onChanged: (value) {
                          setState(() {
                            validationMessageAdresse =
                                AppResources.validatorNotEmpty(value);
                            updateFormValidity();
                          });
                        },
                      ),
                      SizedBox(
                          height: ResponsiveSize.calculateHeight(40, context)),
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
                          focusedErrorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
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
                      SizedBox(
                          height: ResponsiveSize.calculateHeight(40, context)),
                      TextFormField(
                        controller: _textEditingControllerCodePostal,
                        keyboardType: TextInputType.number,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppResources.colorDark),
                        decoration: InputDecoration(
                          filled: false,
                          hintText: 'Code postal',
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
                          focusedErrorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        //onFieldSubmitted: (value) => validate(),
                        validator: AppResources.validatorNotEmpty,
                        //onSaved: (value) => bloc.name = value,
                        onChanged: (value) {
                          setState(() {
                            validationMessageCodePostal =
                                AppResources.validatorNotEmpty(value);
                            updateFormValidity();
                          });
                        },
                      ),
                      SizedBox(
                          height: ResponsiveSize.calculateHeight(40, context)),
                      TextFormField(
                        controller: _textEditingControllerCountry,
                        keyboardType: TextInputType.name,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppResources.colorDark),
                        decoration: InputDecoration(
                          filled: false,
                          hintText: 'Pays',
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
                          focusedErrorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        //onFieldSubmitted: (value) => validate(),
                        validator: AppResources.validatorNotEmpty,
                        //onSaved: (value) => bloc.name = value,
                        onChanged: (value) {
                          setState(() {
                            validationMessageCountry =
                                AppResources.validatorNotEmpty(value);
                            updateFormValidity();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: ResponsiveSize.calculateHeight(44, context),
                      ),
                      child: Container(
                        width: ResponsiveSize.calculateWidth(319, context),
                        height: ResponsiveSize.calculateHeight(44, context),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.symmetric(
                                    horizontal: ResponsiveSize.calculateHeight(
                                        24, context),
                                    vertical: ResponsiveSize.calculateHeight(
                                        10, context))),
                            backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return AppResources
                                      .colorGray15; // Change to your desired grey color
                                }
                                return AppResources
                                    .colorVitamine; // Your enabled color
                              },
                            ),
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                          ),
                          onPressed: isFormValid && !isLoading
                              ? () async {
                            setState(() {
                              isLoading = true;
                              widget.sendListMap['addresse'] = _textEditingControllerAdresse.text;
                              widget.sendListMap['ville'] = _textEditingControllerVille.text;
                              widget.sendListMap['code_postale'] = _textEditingControllerCodePostal.text;
                              widget.sendListMap['country'] = _textEditingControllerCountry.text;
                            });
                            final response = await AppService.api.makeExperienceGuide2(widget.sendListMap);
                            if(response.experience.id != null) {
                              navigateTo(context, (_) => CreatedExperience());
                            }
                            setState(() {
                              isLoading = false;
                            });
                          }
                              : null,
                          child: isLoading
                              ? CircularProgressIndicator() // Show loader when isLoading is true
                              : Text(
                            'POSTER MON EXPÉRIENCE',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppResources.colorWhite),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
