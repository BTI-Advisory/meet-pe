import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:meet_pe/screens/authentification/verificationCodePage.dart';
import 'package:meet_pe/widgets/_widgets.dart';
import 'package:rxdart/rxdart.dart';
import '../../resources/resources.dart';
import '../../services/app_service.dart';
import '../../services/secure_storage_service.dart';
import '../../utils/_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.email});

  final String email;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with BlocProvider<SignUpPage, SignUpPageBloc> {
  @override
  initBloc() => SignUpPageBloc(email: widget.email);

  bool isChecked = false;
  bool isCheckedNewsletter = false;
  String? validationMessage;
  bool _showErrorMessage = false;
  bool isFormValid = false;

  void updateFormValidity() {
    setState(() {
      isFormValid = validationMessage == null && isChecked == true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AsyncForm(
            onValidated: bloc.register,
            onSuccess: () {
              bloc.saveCredentials();
              return navigateTo(
                  context, (_) => VerificationCodePage(email: widget.email),
                  clearHistory: true);
            },
            builder: (context, validate) {
              bloc.setValidateForm(validate);
              return SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 0,
                    maxHeight: MediaQuery.of(context).size.height,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.71, -0.71),
                      end: Alignment(-0.71, 0.71),
                      colors: [
                        AppResources.colorGray5,
                        Colors.white.withOpacity(0)
                      ],
                    ),
                  ),
                  child: Stack(children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: ResponsiveSize.calculateHeight(70, context)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Image.asset(
                            'images/logo_color.png',
                            width: ResponsiveSize.calculateWidth(110, context),
                            height:
                                ResponsiveSize.calculateHeight(101, context),
                          ),
                          SizedBox(
                              height:
                                  ResponsiveSize.calculateHeight(50, context)),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveSize.calculateWidth(
                                        38, context)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.create_account_text,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                    SizedBox(
                                      height: ResponsiveSize.calculateHeight(
                                          42, context),
                                    ),
                                    Text(
                                      widget.email,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                              color: AppResources.colorDark),
                                    ),
                                    SizedBox(
                                      height: ResponsiveSize.calculateHeight(
                                          8, context),
                                    ),
                                    Container(
                                      height: 1,
                                      width: MediaQuery.of(context).size.width -
                                          96,
                                      color: AppResources.colorGray15,
                                    ),
                                    SizedBox(
                                      height: ResponsiveSize.calculateHeight(
                                          26, context),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          96,
                                      child: PasswordField(
                                        //onFieldSubmitted: (value) => validate(),
                                        controller: bloc.passwordController,
                                        onChanged: (value) {
                                          setState(() {
                                            validationMessage =
                                                AppResources.validatorPassword(
                                                    value);
                                            updateFormValidity();
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: ResponsiveSize.calculateHeight(
                                          7, context),
                                    ),
                                    if (validationMessage != null)
                                      Text(
                                        AppLocalizations.of(context)!.minimum_password_text,
                                        style: const TextStyle(
                                          color: Color(0xFFFF0000),
                                          fontSize: 10,
                                          fontFamily: 'Outfit',
                                          fontWeight: FontWeight.w400,
                                          height: 0.14,
                                        ),
                                      ),
                                    SizedBox(
                                      height: ResponsiveSize.calculateHeight(
                                          54, context),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            // Toggle the checkbox state on tap
                                            setState(() {
                                              isChecked = !isChecked;
                                              _showErrorMessage =
                                                  !_showErrorMessage;
                                              updateFormValidity();
                                            });
                                          },
                                          child: Container(
                                            width: 25,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: !_showErrorMessage
                                                    ? Colors.red
                                                    : Colors.black,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                              color: isChecked
                                                  ? Colors.white
                                                  : null,
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
                                        SizedBox(
                                            width:
                                                ResponsiveSize.calculateWidth(
                                                    12, context)),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: AppLocalizations.of(context)!.signup_1_text,
                                                    style: TextStyle(
                                                      color: Color(0xFF979797),
                                                      fontSize: 12,
                                                      fontFamily: 'Outfit',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 0,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: AppLocalizations.of(context)!.signup_2_text,
                                                    style: const TextStyle(
                                                      color: Color(0xFFFF4C00),
                                                      fontSize: 12,
                                                      fontFamily: 'Outfit',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      height: 0,
                                                    ),
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () {
                                                            navigateTo(
                                                                context,
                                                                (_) => const WebViewContainer(
                                                                    webUrl:
                                                                        'https://www.meetpe.fr/conditions-generales'));
                                                          },
                                                  ),
                                                  TextSpan(
                                                    text: AppLocalizations.of(context)!.signup_3_text,
                                                    style: TextStyle(
                                                      color: Color(0xFF979797),
                                                      fontSize: 12,
                                                      fontFamily: 'Outfit',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                            Text.rich(
                                              TextSpan(children: [
                                                TextSpan(
                                                  text: AppLocalizations.of(context)!.signup_4_text,
                                                  style: TextStyle(
                                                    color: Color(0xFF979797),
                                                    fontSize: 12,
                                                    fontFamily: 'Outfit',
                                                    fontWeight: FontWeight.w400,
                                                    height: 0,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                  AppLocalizations.of(context)!.signup_5_text,
                                                  style: const TextStyle(
                                                    color: Color(0xFFFF4C00),
                                                    fontSize: 12,
                                                    fontFamily: 'Outfit',
                                                    fontWeight: FontWeight.w500,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    height: 0,
                                                  ),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          navigateTo(
                                                              context,
                                                              (_) => const WebViewContainer(
                                                                  webUrl:
                                                                      'https://www.meetpe.fr/privacy/'));
                                                        },
                                                ),
                                                const TextSpan(
                                                  text: ' ',
                                                  style: TextStyle(
                                                    color: Color(0xFF979797),
                                                    fontSize: 12,
                                                    fontFamily: 'Outfit',
                                                    fontWeight: FontWeight.w500,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    height: 0,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: AppLocalizations.of(context)!.login_5_text,
                                                  style: TextStyle(
                                                    color: Color(0xFF979797),
                                                    fontSize: 12,
                                                    fontFamily: 'Outfit',
                                                    fontWeight: FontWeight.w400,
                                                    height: 0,
                                                  ),
                                                ),
                                              ]),
                                              textAlign: TextAlign.start,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: ResponsiveSize.calculateHeight(
                                          17, context),
                                    ),
                                    if (!_showErrorMessage)
                                      Text(
                                        AppLocalizations.of(context)!.check_1_text,
                                        style: TextStyle(
                                          color: Color(0xFFFF0000),
                                          fontSize: 10,
                                          fontFamily: 'Outfit',
                                          fontWeight: FontWeight.w400,
                                          height: 0.14,
                                        ),
                                      ),
                                    SizedBox(
                                      height: ResponsiveSize.calculateHeight(
                                          19, context),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            // Toggle the checkbox state on tap
                                            setState(() {
                                              isCheckedNewsletter =
                                                  !isCheckedNewsletter;
                                            });
                                          },
                                          child: Container(
                                            width: 25,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.black,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                              color: isCheckedNewsletter
                                                  ? Colors.white
                                                  : null,
                                            ),
                                            child: isCheckedNewsletter
                                                ? Icon(
                                                    Icons.check,
                                                    size: 10.0,
                                                    color: Colors.black,
                                                  )
                                                : null,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          AppLocalizations.of(context)!.check_2_text,
                                          style: TextStyle(
                                            color: Color(0xFF979797),
                                            fontSize: 12,
                                            fontFamily: 'Outfit',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 44),
                                child: Container(
                                  width: ResponsiveSize.calculateWidth(
                                      241, context),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty
                                          .all<EdgeInsets>(EdgeInsets.symmetric(
                                              horizontal:
                                                  ResponsiveSize.calculateWidth(
                                                      24, context),
                                              vertical: ResponsiveSize
                                                  .calculateHeight(
                                                      10, context))),
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.disabled)) {
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
                                          borderRadius: BorderRadius.circular(
                                              ResponsiveSize
                                                  .calculateCornerRadius(
                                                      40, context)),
                                        ),
                                      ),
                                    ),
                                    //onPressed: isChecked ? validate : null,
                                    /*onPressed: () {
                                      // Toggle the visibility of the error message based on isChecked
                                      if (!isChecked) {
                                        setState(() {
                                          _showErrorMessage = true;
                                        });
                                      } else {
                                        // Perform the necessary action when the button is pressed
                                        validate();
                                      }
                                    },*/
                                    onPressed: isFormValid
                                        ? () {
                                            setState(() {
                                              validate();
                                            });
                                          }
                                        : null,
                                    child: Text(
                                      AppLocalizations.of(context)!.create_account_button,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
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
                    Positioned(
                      top: 48,
                      left: 28,
                      child: Container(
                        width: ResponsiveSize.calculateWidth(32, context),
                        height: ResponsiveSize.calculateHeight(32, context),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                ResponsiveSize.calculateCornerRadius(
                                    40, context)),
                          ),
                        ),
                        child: FloatingActionButton(
                            heroTag: "btn1",
                            backgroundColor: AppResources.colorWhite,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              String.fromCharCode(
                                  CupertinoIcons.back.codePoint),
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
                ),
              );
            }));
  }
}

class DeveloperModeButton extends StatefulWidget {
  const DeveloperModeButton({Key? key}) : super(key: key);

  @override
  State<DeveloperModeButton> createState() => _DeveloperModeButtonState();
}

class _DeveloperModeButtonState extends State<DeveloperModeButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: Colors.transparent,
        width: 40,
        height: 40,
      ),
      onTap: () => onDeveloperModePressed(context),
    );
  }

  int _toggleDevModeCount = 10;
  int _toggleDevModeCounter = 0;
  final CountdownTimer _toggleDevModeCoolDownTimer =
      CountdownTimer(const Duration(seconds: 5));
  final CountdownTimer _toggleDevModeCancelTimer =
      CountdownTimer(const Duration(seconds: 5));

  void onDeveloperModePressed(BuildContext context) {
    if (!_toggleDevModeCoolDownTimer.isElapsed) return;

    if (_toggleDevModeCancelTimer.isElapsed) _toggleDevModeCounter = 0;

    _toggleDevModeCounter++;
    _toggleDevModeCancelTimer.restart();

    if (_toggleDevModeCounter >= _toggleDevModeCount) {
      //Toggle developerMode
      AppService.instance.developerModeStream
          .add(!AppService.instance.developerMode);

      //Reset vars
      _toggleDevModeCounter = 0;
      _toggleDevModeCount = 5;
      _toggleDevModeCoolDownTimer.restart();

      //Display message
      showMessage(context,
          'Developer mode is ${AppService.instance.developerMode ? 'enabled' : 'disabled'}');
    } else if (_toggleDevModeCounter >= 3) {
      showMessage(context,
          'Developer mode will be ${(AppService.instance.developerMode ? 'disabled' : 'enabled')} in : ${_toggleDevModeCount - _toggleDevModeCounter}');
    }
  }
}

class SignUpPageBloc with Disposable {
  late TextEditingController usernameController, passwordController;
  LocalAuthentication localAuth = LocalAuthentication();
  late Function() validateForm;
  final String email;

  SignUpPageBloc({required this.email}) {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    usernameController.text = email;
  }

  void setValidateForm(Function() value) => validateForm = value;

  void saveCredentials() {
    SecureStorageService.saveUsername(usernameController.text);
    SecureStorageService.savePassword(passwordController.text);
  }

  BehaviorSubject<String> get appVersion => AppService.instance.appVersion;

  Future<void> register() async {
    print('Login function called'); // Check if this is printed
    await AppService.instance
        .register(usernameController.text, passwordController.text);
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
