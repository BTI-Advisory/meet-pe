import 'package:flutter/material.dart';

import '../../../../resources/resources.dart';
import '../../../../utils/responsive_size.dart';

class CreateExpStep3 extends StatefulWidget {
  CreateExpStep3({super.key, required this.myMap});

  Map<String, Set<Object>> myMap = {};

  @override
  State<CreateExpStep3> createState() => _CreateExpStep3State();
}

class _CreateExpStep3State extends State<CreateExpStep3> {
  late TextEditingController _textEditingControllerName;
  late TextEditingController _textEditingControllerDescr;
  String? validationMessageNameExp = '';
  String? validationMessageDescExp = '';
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    _textEditingControllerName = TextEditingController();
    _textEditingControllerName.addListener(_onTextChanged);
    _textEditingControllerDescr = TextEditingController();
    _textEditingControllerDescr.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textEditingControllerName.removeListener(_onTextChanged);
    _textEditingControllerName.dispose();
    _textEditingControllerDescr.removeListener(_onTextChanged);
    _textEditingControllerDescr.dispose();
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
          validationMessageNameExp == null && validationMessageDescExp == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              Image.asset('images/backgroundExp2.png'),
              SizedBox(height: ResponsiveSize.calculateHeight(40, context)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Étape 2 sur 8',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontSize: 10, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                        height: ResponsiveSize.calculateHeight(8, context)),
                    Text(
                      'Description de l’expérience',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(
                        height: ResponsiveSize.calculateHeight(16, context)),
                    Text(
                      'C’est la première information que l’on va voir sur ton profil. Alors écris un titre et un descriptif qui donnent “l’envie d’avoir envie” !',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(
                        height: ResponsiveSize.calculateHeight(40, context)),
                    TextFormField(
                      controller: _textEditingControllerName,
                      keyboardType: TextInputType.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppResources.colorDark),
                      decoration: InputDecoration(
                        filled: false,
                        hintText: 'Titre de ton expérience',
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
                          validationMessageNameExp =
                              AppResources.validatorNotEmpty(value);
                          updateFormValidity();
                        });
                      },
                    ),
                    SizedBox(
                        height: ResponsiveSize.calculateHeight(40, context)),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: ResponsiveSize.calculateHeight(44, context),
                        right: ResponsiveSize.calculateWidth(28, context)),
                    child: Container(
                      width: ResponsiveSize.calculateWidth(151, context),
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
                        onPressed: isFormValid
                            ? () {
                          setState(() {
                            if (widget.myMap['desc_exp_title'] == null) {
                              widget.myMap['desc_exp_title'] =
                                  Set<String>(); // Initialize if null
                            }
                            if (widget.myMap['desc_exp_desc'] == null) {
                              widget.myMap['desc_exp_desc'] =
                                  Set<String>(); // Initialize if null
                            }

                            if (_textEditingControllerName
                                .text.isNotEmpty) {
                              widget.myMap['desc_exp_title']!
                                  .add(_textEditingControllerName.text);
                            }
                            if (_textEditingControllerDescr
                                .text.isNotEmpty) {
                              widget.myMap['desc_exp_desc']!
                                  .add(_textEditingControllerDescr.text);
                            }

                            // Proceed to the next step
                            //navigateTo(context, (_) => CreateExpStep3(myMap: myMap));
                          });
                        }
                            : null,
                        child: Image.asset('images/arrowLongRight.png'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
