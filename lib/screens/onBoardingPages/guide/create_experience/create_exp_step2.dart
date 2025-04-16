import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../resources/resources.dart';
import '../../../../utils/_utils.dart';
import 'create_exp_step3.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateExpStep2 extends StatefulWidget {
  CreateExpStep2({super.key, required this.myMap});

  Map<String, Set<Object>> myMap = {};

  @override
  State<CreateExpStep2> createState() => _CreateExpStep2State();
}

class _CreateExpStep2State extends State<CreateExpStep2> {
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
    final deviceSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                  Image.asset(
                    'images/backgroundExp2.png',
                    width: double.infinity,
                    fit: BoxFit.fill,
                    height: ResponsiveSize.calculateHeight(190, context),
                  ),
                  SizedBox(height: ResponsiveSize.calculateHeight(40, context)),
                  Expanded(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.step_2_text,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontSize: 10, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                              height: ResponsiveSize.calculateHeight(8, context)),
                          Text(
                            AppLocalizations.of(context)!.step_2_title_text,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          SizedBox(
                              height: ResponsiveSize.calculateHeight(16, context)),
                          Text(
                            AppLocalizations.of(context)!.step_2_desc_text,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(
                              height: ResponsiveSize.calculateHeight(40, context)),
                          TextFormField(
                            controller: _textEditingControllerName,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppResources.colorDark),
                            decoration: InputDecoration(
                              filled: false,
                              hintText: AppLocalizations.of(context)!.title_exp_hint_text,
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
                                validationMessageNameExp =
                                    AppResources.validatorNotEmpty(value);
                                updateFormValidity();
                              });
                            },
                          ),
                          SizedBox(
                              height: ResponsiveSize.calculateHeight(40, context)),
                          TextFormField(
                            controller: _textEditingControllerDescr,
                            maxLines: null,
                            textInputAction: TextInputAction.newline,
                            keyboardType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.sentences,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(3000),
                            ],
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppResources.colorDark),
                            decoration: InputDecoration(
                              filled: false,
                              hintText: AppLocalizations.of(context)!.desc_exp_hint_text,
                              hintStyle: Theme.of(context).textTheme.bodyMedium,
                              contentPadding: EdgeInsets.only(
                                top: ResponsiveSize.calculateHeight(20, context),
                                bottom: ResponsiveSize.calculateHeight(10, context),
                              ),
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
                            //onFieldSubmitted: (value) => validate(),
                            validator: AppResources.validatorNotEmpty,
                            //onSaved: (value) => bloc.name = value,
                            onChanged: (value) {
                              setState(() {
                                validationMessageDescExp =
                                    AppResources.validatorNotEmpty(value);
                                updateFormValidity();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: EdgeInsets.only(
              bottom: ResponsiveSize.calculateHeight(44, context),
              right: ResponsiveSize.calculateWidth(28, context)),
          child: SizedBox(
            width: ResponsiveSize.calculateWidth(151, context),
            height: ResponsiveSize.calculateHeight(44, context),
            child: ElevatedButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.calculateHeight(24, context),
                        vertical: ResponsiveSize.calculateHeight(10, context))),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return AppResources.colorGray15;
                    }
                    return AppResources.colorVitamine;
                  },
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: isFormValid
                  ? () {
                navigateTo(
                    context,
                        (_) => CreateExpStep3(
                      myMap: widget.myMap,
                      name: _textEditingControllerName.text,
                      description: _textEditingControllerDescr.text,
                    ));
              }
                  : null,
              child: Image.asset('images/arrowLongRight.png'),
            ),
          ),
        ),
      ),
    );
  }
}
