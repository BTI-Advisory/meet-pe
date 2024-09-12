import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:meet_pe/screens/onBoardingPages/guide/step4GuidePage.dart';
import '../../../utils/responsive_size.dart';
import '../../../utils/utils.dart';

class Step3GuidePage extends StatefulWidget {
  final int totalSteps;
  final int currentStep;
  Map<String, Set<Object>> myMap = {};

  Step3GuidePage({
    Key? key,
    required this.totalSteps,
    required this.currentStep,
    required this.myMap,
  }) : super(key: key);

  @override
  State<Step3GuidePage> createState() => _Step3GuidePageState();
}

class _Step3GuidePageState extends State<Step3GuidePage> {
  late List<Voyage> myList = [];
  late TextEditingController _textEditingControllerAbout;
  String? validationMessageAbout = '';
  bool isFormValid = false;
  bool _isButtonActive = false;

  @override
  void initState() {
    super.initState();
    _textEditingControllerAbout = TextEditingController();
    _textEditingControllerAbout.addListener(_onTextChanged);

    _textEditingControllerAbout.addListener(() {
      setState(() {
        _isButtonActive = _textEditingControllerAbout.text.isNotEmpty;
      });
    });
  }

  double calculateProgress() {
    return widget.currentStep / widget.totalSteps;
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
    double progress = calculateProgress();

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
                  'A propos de toi',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: AppResources.colorGray100),
                ),
                SizedBox(height: ResponsiveSize.calculateHeight(100, context)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    "C'est le moment idéal pour donner une touche personnelle à ton profil qui sera vu par tous nos voyageurs. Partage nous quelque chose de spécial sur toi. Tu es la star de notre équipe, c’est à toi 🎙️",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                SizedBox(height: ResponsiveSize.calculateHeight(40, context)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: TextFormField(
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
                      hintText: 'Hello la communauté Meet People, je suis Sacha\npassionné par la food de ma région...',
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
                    validator: AppResources.validatorNotEmpty,
                    onChanged: (value) {
                      setState(() {
                        validationMessageAbout =
                            AppResources.validatorNotEmpty(value);
                        updateFormValidity();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: ResponsiveSize.calculateHeight(44, context)),
                      child: Container(
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
                          onPressed: _isButtonActive
                              ? () {
                            if (widget.myMap['languages_fr'] == null) {
                              widget.myMap['languages_fr'] =
                                  Set<int>(); // Initialize if null
                            }
                            widget.myMap['languages_fr']!.add(188);

                            navigateTo(
                              context,
                                  (_) => Step4GuidePage(
                                myMap: widget.myMap,
                                totalSteps: 5,
                                currentStep: 4,
                              ),
                            );
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
        ),
      ),
    );
  }
}
