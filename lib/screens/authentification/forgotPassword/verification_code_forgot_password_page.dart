import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:meet_pe/screens/authentification/forgotPassword/change_password_page.dart';
import 'package:meet_pe/screens/authentification/signinPage.dart';
import 'package:meet_pe/screens/authentification/welcomePage.dart';

import '../../../services/app_service.dart';
import '../../../resources/resources.dart';
import '../../../services/app_service.dart';
import '../../../utils/_utils.dart';
import '../../../widgets/_widgets.dart';

class VerificationCodeForgotPasswordPage extends StatefulWidget {
  final String email;

  const VerificationCodeForgotPasswordPage({super.key, required this.email});

  @override
  State<VerificationCodeForgotPasswordPage> createState() => _VerificationCodeForgotPasswordPageState();
}

class _VerificationCodeForgotPasswordPageState extends State<VerificationCodeForgotPasswordPage>
    with BlocProvider<VerificationCodeForgotPasswordPage, VerificationCodeForgotPasswordBloc> {
  @override
  initBloc() => VerificationCodeForgotPasswordBloc();

  bool _onEditing = true;
  String? _code;

  @override
  void initState() {
    super.initState();
    displayInfo();
  }

  Future<void> displayInfo() async {
    await Future.delayed(const Duration(seconds: 1));
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Center(child: Text('Information')),
        content: const Text(
            'Et oui, même pour Meet People alors que notre mission est de rendre ce monde encore plus merveilleux grâce à toi cela nous arrive de nous perdre dans tes SPAM ! Mais avec un bon Tcheck de ta part nous serons plus fort que le côté obscur de la force 💪🏼'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AsyncForm(
          onValidated: bloc.verifyCode,
          onSuccess: () async {
            return navigateTo(context, (_) => ChangePasswordPage(email: widget.email));
          },
          builder: (context, validate) {
            return Container(
              constraints: BoxConstraints.expand(),
              child: Padding(
                padding: EdgeInsets.only(
                    top: ResponsiveSize.calculateHeight(221, context)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                              ResponsiveSize.calculateWidth(24, context)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tu viens de recevoir un code !',
                                style:
                                Theme.of(context).textTheme.headlineMedium,
                              ),
                              SizedBox(
                                height:
                                ResponsiveSize.calculateHeight(16, context),
                              ),
                              Text(
                                'Entre le pour vérifier que c’est bien toi !',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: AppResources.colorGray30),
                              ),
                              SizedBox(
                                height:
                                ResponsiveSize.calculateHeight(42, context),
                              ),
                              VerificationCode(
                                itemSize: 40,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                    color: AppResources.colorDark,
                                    fontSize: 28),
                                keyboardType: TextInputType.number,
                                underlineColor: AppResources.colorGray15,
                                length: 6,
                                cursorColor: AppResources.colorDark,
                                margin: const EdgeInsets.all(4),
                                onCompleted: (String value) {
                                  setState(() {
                                    _code = value;
                                    bloc.code = value;
                                  });
                                },
                                onEditing: (bool value) {
                                  setState(() {
                                    _onEditing = value;
                                  });
                                  if (!_onEditing)
                                    FocusScope.of(context).unfocus();
                                },
                              ),
                              SizedBox(
                                height:
                                ResponsiveSize.calculateHeight(66, context),
                              ),
                              TextButton(
                                onPressed: () {
                                  bloc.resendCode(widget.email);
                                  showMessage(context, 'code renvoyé');
                                },
                                child: Text(
                                  'Renvoyer le code',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                      color: AppResources.colorGray30,
                                      decoration: TextDecoration.underline),
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
                            width: ResponsiveSize.calculateWidth(241, context),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.symmetric(
                                        horizontal:
                                        ResponsiveSize.calculateWidth(
                                            24, context),
                                        vertical:
                                        ResponsiveSize.calculateHeight(
                                            10, context))),
                                backgroundColor: MaterialStateProperty.all(
                                    AppResources.colorVitamine),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      ResponsiveSize.calculateCornerRadius(
                                          40, context),
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: validate,
                              child: Text(
                                'VALIDER',
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
            );
          }),
    );
  }
}

class VerificationCodeForgotPasswordBloc with Disposable {
  String? code;

  Future<bool> verifyCode() async {
    bool isVerified = await AppService.api.verifyCode(code!);
    return isVerified;
  }

  Future<bool> resendCode(String email) async {
    bool isResend = await true;
    return isResend;
  }
}
