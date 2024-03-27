import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:meet_pe/screens/verificationCodePage.dart';
import 'package:meet_pe/utils/responsive_size.dart';
import 'package:meet_pe/widgets/_widgets.dart';
import 'package:rxdart/rxdart.dart';
import '../resources/resources.dart';
import '../services/app_service.dart';
import '../services/secure_storage_service.dart';
import '../services/storage_service.dart';
import '../utils/_utils.dart';
import '../utils/countdown_timer.dart';

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
      isFormValid =
          validationMessage == null && isChecked == true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AsyncForm(
            onValidated: bloc.register,
            onSuccess: () {
              bloc.saveCredentials();
              return navigateTo(context, (_) => const VerificationCodePage(),
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
                  child: Padding(
                    padding: EdgeInsets.only(top: ResponsiveSize.calculateHeight(70, context)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'images/logo_color.png',
                          width: ResponsiveSize.calculateWidth(110, context),
                          height: ResponsiveSize.calculateHeight(101, context),
                        ),
                        SizedBox(height: ResponsiveSize.calculateHeight(50, context)),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(40, context)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Crée ton compte',
                                    style:
                                    Theme.of(context).textTheme.headlineMedium,
                                  ),
                                  SizedBox(
                                    height: ResponsiveSize.calculateHeight(42, context),
                                  ),
                                  Text(
                                    widget.email,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(color: AppResources.colorDark),
                                  ),
                                  SizedBox(
                                    height: ResponsiveSize.calculateHeight(8, context),
                                  ),
                                  Container(
                                    height: 1,
                                    width: MediaQuery.of(context).size.width - 96,
                                    color: AppResources.colorGray15,
                                  ),
                                  SizedBox(
                                    height: ResponsiveSize.calculateHeight(26, context),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width - 96,
                                    child: PasswordField(
                                      onFieldSubmitted: (value) => validate(),
                                      controller: bloc.passwordController,
                                      onChanged: (value) {
                                        setState(() {
                                          validationMessage = AppResources.validatorPassword(value);
                                          updateFormValidity();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: ResponsiveSize.calculateHeight(7, context),
                                  ),
                                  if (validationMessage != null)
                                    const Text(
                                      'Ⓧ 6 caractères minimum',
                                      style: TextStyle(
                                        color: Color(0xFFFF0000),
                                        fontSize: 10,
                                        fontFamily: 'Outfit',
                                        fontWeight: FontWeight.w400,
                                        height: 0.14,
                                      ),
                                    ),
                                  SizedBox(height: ResponsiveSize.calculateHeight(54, context),),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          // Toggle the checkbox state on tap
                                          setState(() {
                                            isChecked = !isChecked;
                                            _showErrorMessage = !_showErrorMessage;
                                            updateFormValidity();
                                          });
                                        },
                                        child: Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: !_showErrorMessage
                                                  ? Colors.red
                                                  : Colors.black,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(4.0),
                                            color: isChecked ? Colors.white : null,
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
                                      const Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'J’accepte les ',
                                                  style: TextStyle(
                                                    color: Color(0xFF979797),
                                                    fontSize: 13,
                                                    fontFamily: 'Outfit',
                                                    fontWeight: FontWeight.w400,
                                                    height: 0,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: 'Conditions Générales',
                                                  style: TextStyle(
                                                    color: Color(0xFFFF4C00),
                                                    fontSize: 13,
                                                    fontFamily: 'Outfit',
                                                    fontWeight: FontWeight.w500,
                                                    decoration:
                                                    TextDecoration.underline,
                                                    height: 0,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: ' et ',
                                                  style: TextStyle(
                                                    color: Color(0xFF979797),
                                                    fontSize: 13,
                                                    fontFamily: 'Outfit',
                                                    fontWeight: FontWeight.w400,
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
                                                text: ' la ',
                                                style: TextStyle(
                                                  color: Color(0xFF979797),
                                                  fontSize: 13,
                                                  fontFamily: 'Outfit',
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                'Politique de Confidentialité',
                                                style: TextStyle(
                                                  color: Color(0xFFFF4C00),
                                                  fontSize: 13,
                                                  fontFamily: 'Outfit',
                                                  fontWeight: FontWeight.w500,
                                                  decoration:
                                                  TextDecoration.underline,
                                                  height: 0,
                                                ),
                                              ),
                                              TextSpan(
                                                text: ' ',
                                                style: TextStyle(
                                                  color: Color(0xFF979797),
                                                  fontSize: 13,
                                                  fontFamily: 'Outfit',
                                                  fontWeight: FontWeight.w500,
                                                  decoration:
                                                  TextDecoration.underline,
                                                  height: 0,
                                                ),
                                              ),
                                              TextSpan(
                                                text: 'Meetpe',
                                                style: TextStyle(
                                                  color: Color(0xFF979797),
                                                  fontSize: 13,
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
                                  SizedBox(height: ResponsiveSize.calculateHeight(17, context),),
                                  if (!_showErrorMessage)
                                    const Text(
                                      'ACCEPTE LES CONDITIONS GENERALES POUR CONTINUER',
                                      style: TextStyle(
                                        color: Color(0xFFFF0000),
                                        fontSize: 10,
                                        fontFamily: 'Outfit',
                                        fontWeight: FontWeight.w400,
                                        height: 0.14,
                                      ),
                                    ),

                                  SizedBox(height: ResponsiveSize.calculateHeight(19, context),),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          // Toggle the checkbox state on tap
                                          setState(() {
                                            isCheckedNewsletter = !isCheckedNewsletter;
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
                                            color: isCheckedNewsletter ? Colors.white : null,
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
                                      const Text(
                                        'J’accepte de recevoir les dernières\n nouveautés Meetpe (nouvelles expériences,\n tips et newsletter)',
                                        style: TextStyle(
                                          color: Color(0xFF979797),
                                          fontSize: 13,
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
                                width: ResponsiveSize.calculateWidth(241, context),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                        EdgeInsets.symmetric(
                                            horizontal: ResponsiveSize.calculateWidth(24, context), vertical: ResponsiveSize.calculateHeight(10, context))),
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
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(ResponsiveSize.calculateCornerRadius(40, context)),
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
                                    'CREER UN COMPTE',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(color: AppResources.colorWhite),
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
    await AppService.api.register(usernameController.text, passwordController.text);
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
