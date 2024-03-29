import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:meet_pe/screens/guideProfilPages/main_guide_page.dart';
import 'package:rxdart/rxdart.dart';
import '../resources/resources.dart';
import '../services/app_service.dart';
import '../services/secure_storage_service.dart';
import '../services/storage_service.dart';
import '../utils/_utils.dart';
import '../widgets/async_form.dart';
import '../widgets/password_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key, required this.email});

  final String email;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>
    with BlocProvider<SignInPage, SignInPageBloc> {
  @override
  initBloc() => SignInPageBloc(email: widget.email);

  String? validationMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AsyncForm(
            onValidated: bloc.login,
            onSuccess: () {
              bloc.saveCredentials();
              return navigateTo(context, (_) => const MainGuidePage(), clearHistory: true);
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
                    padding: const EdgeInsets.only(top: 70),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'images/logo_color.png',
                          width: 110,
                          height: 101,
                        ),
                        SizedBox(height: 50),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 48.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Connection',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                  const SizedBox(
                                    height: 42,
                                  ),
                                  Text(
                                    widget.email,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(color: AppResources.colorDark),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    height: 1,
                                    width: MediaQuery.of(context).size.width - 96,
                                    color: AppResources.colorGray15,
                                  ),
                                  const SizedBox(
                                    height: 26,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width - 96,
                                    child: PasswordField(
                                      //onFieldSubmitted: (value) => validate(),
                                      controller: bloc.passwordController,
                                      onChanged: (value) {
                                        setState(() {
                                          validationMessage =
                                              AppResources.validatorPassword(
                                                  value);
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  if (validationMessage != null)
                                    const Text(
                                      'CHAMPS INVALIDE',
                                      style: TextStyle(
                                        color: Color(0xFFFF0000),
                                        fontSize: 10,
                                        fontFamily: 'Outfit',
                                        fontWeight: FontWeight.w400,
                                        height: 0.14,
                                      ),
                                    ),
                                  const SizedBox(
                                    height: 37,
                                  ),
                                 TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'mot de passe oublié ?',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppResources.colorGray30, decoration: TextDecoration.underline),
                                    ),
                                  )
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
                                margin:
                                    const EdgeInsets.only(left: 67, right: 67),
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                            const EdgeInsets.symmetric(
                                                horizontal: 24, vertical: 10)),
                                    backgroundColor: MaterialStateProperty.all(
                                        AppResources.colorVitamine),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                    ),
                                  ),
                                  onPressed: validate,
                                  child: Text(
                                    'SE CONNECTER',
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
                ),
              );
            }));
  }
}

class SignInPageBloc with Disposable {
  late TextEditingController usernameController, passwordController;
  LocalAuthentication localAuth = LocalAuthentication();
  late Function() validateForm;
  final String email;

  SignInPageBloc({required this.email}) {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    usernameController.text = email;
    tryBiometricsAuthentication();
  }

  void setValidateForm(Function() value) => validateForm = value;

  void tryBiometricsAuthentication() async {
    final username = await SecureStorageService.readUsername();
    final password = await SecureStorageService.readPassword();
    final availableBiometrics = await localAuth.getAvailableBiometrics();
    final biometricsEnabled = StorageService.biometricsEnabledBox.value ?? true;
    if (biometricsEnabled &&
        availableBiometrics.isNotEmpty &&
        (username ?? '').isNotEmpty &&
        (password ?? '').isNotEmpty) loginWithBiometrics(validateForm);
  }

  void loginWithBiometrics(VoidCallback validate) async {
    try {
      final bool didAuthenticate = await localAuth.authenticate(
        localizedReason:
            'Veuillez vous authentifier pour accéder à votre compte',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (didAuthenticate) {
        usernameController.text =
            await SecureStorageService.readUsername() ?? '';
        passwordController.text =
            await SecureStorageService.readPassword() ?? '';
        validate();
      }
    } catch (e) {
      debugPrint('LocalAuth ERROR : $e');
    }
  }

  void saveCredentials() {
    SecureStorageService.saveUsername(usernameController.text);
    SecureStorageService.savePassword(passwordController.text);
  }

  BehaviorSubject<String> get appVersion => AppService.instance.appVersion;

  Future<void> login() => AppService.instance
  .login(usernameController.text, passwordController.text);


  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
