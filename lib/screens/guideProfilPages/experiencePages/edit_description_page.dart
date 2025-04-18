import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../utils/_utils.dart';
import '../../../resources/resources.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditDescriptionPage extends StatefulWidget {
  const EditDescriptionPage({super.key, required this.initialDescription});

  final String initialDescription;

  @override
  State<EditDescriptionPage> createState() => _EditDescriptionPageState();
}

class _EditDescriptionPageState extends State<EditDescriptionPage> {
  late TextEditingController _textEditingControllerDescription;
  String? validationMessageDescription = '';

  @override
  void initState() {
    super.initState();
    // Initialize the TextEditingController with the initial description
    _textEditingControllerDescription = TextEditingController(text: widget.initialDescription);
    _textEditingControllerDescription.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textEditingControllerDescription.removeListener(_onTextChanged);
    _textEditingControllerDescription.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      //_showButton = _textEditingControllerName.text.isEmpty;
    });
  }

  void updateFormValidity() {
    setState(() {
      validationMessageDescription == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF3F3F3), Colors.white],
              stops: [0.0, 1.0],
            ),
          ),
          child: Stack(
            children: <Widget>[
              // Main content with scroll capability
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 48),
                      SizedBox(
                        width: ResponsiveSize.calculateWidth(24, context),
                        height: ResponsiveSize.calculateHeight(24, context),
                        child: FloatingActionButton(
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
                              fontFamily: CupertinoIcons.exclamationmark_circle.fontFamily,
                              package: CupertinoIcons.exclamationmark_circle.fontPackage,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                      Text(
                        AppLocalizations.of(context)!.step_2_title_text,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.description_experience_text,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _textEditingControllerDescription,
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(3000),
                        ],
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorDark),
                        decoration: InputDecoration(
                          filled: false,
                          hintText: AppLocalizations.of(context)!.description_text,
                          hintStyle: Theme.of(context).textTheme.bodyMedium,
                          contentPadding: EdgeInsets.only(
                              top: ResponsiveSize.calculateHeight(20, context),
                              bottom: ResponsiveSize.calculateHeight(10, context)),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppResources.colorGray15),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppResources.colorGray15),
                          ),
                          errorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.length > 3000) {
                            showMessage(
                                context, AppLocalizations.of(context)!.limited_character_text);
                          }
                          setState(() {
                            validationMessageDescription =
                                AppResources.validatorNotEmpty(value);
                            updateFormValidity();
                          });
                        },
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
              // Bottom button
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: SizedBox(
                    width: ResponsiveSize.calculateWidth(319, context),
                    height: ResponsiveSize.calculateHeight(44, context),
                    child: TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(
                                horizontal: ResponsiveSize.calculateWidth(24, context),
                                vertical: ResponsiveSize.calculateHeight(12, context))),
                        backgroundColor: MaterialStateProperty.all(Colors.transparent),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: AppResources.colorDark),
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.enregister_text,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppResources.colorDark),
                      ),
                      onPressed: () {
                        Navigator.pop(context, _textEditingControllerDescription.text);
                      },
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
