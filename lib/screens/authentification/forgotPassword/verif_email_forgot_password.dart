import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet_pe/screens/authentification/forgotPassword/verification_code_forgot_password_page.dart';
import 'package:meet_pe/screens/guideProfilPages/main_guide_page.dart';
import 'package:rxdart/rxdart.dart';
import '../../../resources/resources.dart';
import '../../../services/app_service.dart';
import '../../../utils/_utils.dart';
import '../../../widgets/_widgets.dart';

class VerifEmailForgotPassword extends StatefulWidget {
  const VerifEmailForgotPassword({super.key, required this.email});

  final String email;

  @override
  State<VerifEmailForgotPassword> createState() => _VerifEmailForgotPasswordState();
}

class _VerifEmailForgotPasswordState extends State<VerifEmailForgotPassword>
    with BlocProvider<VerifEmailForgotPassword, VerifEmailForgotPasswordBloc> {

  @override
  initBloc() => VerifEmailForgotPasswordBloc(email: widget.email);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AsyncForm(
            //onValidated: bloc.login,
            onSuccess: () {
              return navigateTo(context, (_) => VerificationCodeForgotPasswordPage(email: widget.email),
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
                      padding: const EdgeInsets.only(top: 70),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Image.asset(
                            'images/logo_color.png',
                            width: 110,
                            height: 101,
                          ),
                          const SizedBox(height: 50),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 48.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mot de passe oublié',
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
                                      ?.copyWith(
                                          color: AppResources.colorDark),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  height: 1,
                                  width: MediaQuery.of(context).size.width -
                                      96,
                                  color: AppResources.colorGray15,
                                ),
                                const SizedBox(
                                  height: 29,
                                ),
                                Text(
                                  'Clique sur le lien dans l’e-mail que tu viens de recevoir pour changer ton mot de passe.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppResources.colorGray30,
                                      ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 44),
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 67, right: 67),
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      padding:
                                          MaterialStateProperty.all<EdgeInsets>(
                                              const EdgeInsets.symmetric(
                                                  horizontal: 24,
                                                  vertical: 10)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              AppResources.colorVitamine),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                      ),
                                    ),
                                    onPressed: validate,
                                    child: Text(
                                      'RENVOYER UN MAIL',
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

class VerifEmailForgotPasswordBloc with Disposable {
  late Function() validateForm;
  final String email;

  VerifEmailForgotPasswordBloc({required this.email}) {
  }

  void setValidateForm(Function() value) => validateForm = value;

  BehaviorSubject<String> get appVersion => AppService.instance.appVersion;

  //Future<void> login() => AppService.instance
      //.login(usernameController.text);

  @override
  void dispose() {
    super.dispose();
  }
}
