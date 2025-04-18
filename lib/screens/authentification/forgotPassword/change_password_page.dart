import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet_pe/screens/authentification/signinPage.dart';
import 'package:rxdart/rxdart.dart';
import '../../../resources/resources.dart';
import '../../../services/app_service.dart';
import '../../../utils/_utils.dart';
import '../../../widgets/_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key, required this.email});

  final String email;

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage>
    with BlocProvider<ChangePasswordPage, ChangePasswordPageBloc> {
  @override
  initBloc() => ChangePasswordPageBloc(email: widget.email);

  String? validationMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AsyncForm(
            onValidated: bloc.updateForgotPassword,
            onSuccess: () {
              return navigateTo(context, (_) => SignInPage(email: widget.email),
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
                          SizedBox(height: 50),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 48.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.change_password_title_text,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                    const SizedBox(
                                      height: 42,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          96,
                                      child: PasswordField(
                                        //onFieldSubmitted: (value) => validate(),
                                        controller: bloc.passwordController,
                                        hint: AppLocalizations.of(context)!.new_password_text,
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
                                      height: 26,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          96,
                                      child: PasswordField(
                                        //onFieldSubmitted: (value) => validate(),
                                        controller: bloc.confirmationPasswordController,
                                        hint: AppLocalizations.of(context)!.confirm_password_text,
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
                                      Text(
                                        AppLocalizations.of(context)!.champs_invalid_text,
                                        style: TextStyle(
                                          color: Color(0xFFFF0000),
                                          fontSize: 10,
                                          fontFamily: 'Outfit',
                                          fontWeight: FontWeight.w400,
                                          height: 0.14,
                                        ),
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
                                      AppLocalizations.of(context)!.enregister_text,
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

class ChangePasswordPageBloc with Disposable {
  late TextEditingController passwordController, confirmationPasswordController;
  late Function() validateForm;
  final String email;

  ChangePasswordPageBloc({required this.email}) {
    passwordController = TextEditingController();
    confirmationPasswordController = TextEditingController();
  }

  void setValidateForm(Function() value) => validateForm = value;

  BehaviorSubject<String> get appVersion => AppService.instance.appVersion;

  Future<void> updateForgotPassword() async {
    AppService.api.updateForgotPassword(passwordController.text, confirmationPasswordController.text);
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmationPasswordController.dispose();
    super.dispose();
  }
}
