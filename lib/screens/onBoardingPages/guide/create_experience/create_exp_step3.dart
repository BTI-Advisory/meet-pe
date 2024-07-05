import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../resources/resources.dart';
import '../../../../utils/audio_player.dart';
import '../../../../utils/audio_recorder.dart';
import '../../../../utils/responsive_size.dart';
import '../../../../utils/utils.dart';
import 'create_exp_step4.dart';

class CreateExpStep3 extends StatefulWidget {
  CreateExpStep3({super.key, required this.myMap, required this.name, required this.description});

  final String name;
  final String description;

  Map<String, Set<Object>> myMap = {};

  @override
  State<CreateExpStep3> createState() => _CreateExpStep3State();
}

class _CreateExpStep3State extends State<CreateExpStep3> {
  bool showPlayer = false;
  String? audioPath;
  late TextEditingController _textEditingControllerAbout;
  String? validationMessageAbout = '';
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    showPlayer = false;
    _textEditingControllerAbout = TextEditingController();
    _textEditingControllerAbout.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textEditingControllerAbout.removeListener(_onTextChanged);
    _textEditingControllerAbout.dispose();
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
          validationMessageAbout == null;
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Étape 2 sur 9',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontSize: 10, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                          height: ResponsiveSize.calculateHeight(8, context)),
                      Text(
                        'A propos de toi',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(
                          height: ResponsiveSize.calculateHeight(16, context)),
                      Text(
                        "C'est le moment idéal pour donner une touche personnelle à ton profil. Partage nous quelque chose de spécial sur toi. Tu es la star de notre équipe, c’est à toi 🎙️",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(
                          height: ResponsiveSize.calculateHeight(40, context)),
                      ///Todo add Audio Feature
                      /*Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                ResponsiveSize.calculateWidth(22, context)),
                        width: double.infinity,
                        height: ResponsiveSize.calculateHeight(90, context),
                        decoration: ShapeDecoration(
                          color: AppResources.colorBeige,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                ResponsiveSize.calculateCornerRadius(
                                    45, context)),
                          ),
                        ),
                        child: showPlayer
                            ? Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(25, context)),
                                child: AudioPlayer(
                                  source: audioPath!,
                                  onDelete: () {
                                    setState(() => showPlayer = false);
                                  },
                                ),
                              )
                            : Recorder(
                                onStop: (path) {
                                  if (kDebugMode)
                                    print('Recorded file path: $path');
                                  setState(() {
                                    audioPath = path;
                                    showPlayer = true;
                                  });
                                },
                              ),
                      ),*/
                      TextFormField(
                        controller: _textEditingControllerAbout,
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
                          hintText: 'A propos de moi',
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
                            validationMessageAbout =
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
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: ResponsiveSize.calculateHeight(44, context),
                          right: ResponsiveSize.calculateWidth(28, context),
                      ),
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
                              // Proceed to the next step
                              navigateTo(context, (_) => CreateExpStep4(myMap: widget.myMap, name: widget.name, description: widget.description, about: _textEditingControllerAbout.text, audioPath: audioPath ?? '',));
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
      ),
    );
  }
}
