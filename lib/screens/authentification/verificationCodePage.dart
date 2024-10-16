import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meet_pe/screens/authentification/welcomePage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../resources/resources.dart';
import '../../services/app_service.dart';
import '../../utils/_utils.dart';
import '../../widgets/_widgets.dart';

class VerificationCodePage extends StatefulWidget {
  final String email;

  const VerificationCodePage({super.key, required this.email});

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage>
    with BlocProvider<VerificationCodePage, VerificationCodePageBloc> {
  @override
  initBloc() => VerificationCodePageBloc();

  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType> errorController = StreamController<ErrorAnimationType>();

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    displayInfo();
    errorController = StreamController<ErrorAnimationType>();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    errorController.close();
    super.dispose();
  }

  Future<void> displayInfo() async {
    await Future.delayed(const Duration(seconds: 1));
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Center(child: Text('Information')),
        content: const Text(
            '⚠️ Spam Alerte ça nous arrive de nous perdre dans tes SPAM ! Mais avec un bon check de ta part, nous serons plus forts que le côté obscur de la Force 💪🏼'),
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
      key: scaffoldKey,
      body: AsyncForm(
          //onValidated: bloc.verifyCode,
          onSuccess: () async {
            if (await bloc.verifyCode() == true) {
              setState(() {
                hasError = false;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Aye!!"),
                  duration: Duration(seconds: 2),
                ));
              });
              return navigateTo(context, (_) => const WelcomePage(fromCode: true));
            } else {
              errorController.add(ErrorAnimationType
                  .shake); // Triggering error shake animation
              setState(() {
                hasError = true;
              });
              showMessage(context, 'Verifiez le code!');
            }
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
                          Container(
                            width: double.infinity,
                            height: 60,
                            child: PinCodeTextField(
                              appContext: context,
                              length: 6,
                              obscureText: false,
                              animationType: AnimationType.fade,
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.underline,
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight: 50,
                                fieldWidth: 40,
                              ),
                              animationDuration: Duration(milliseconds: 300),
                              //backgroundColor: Colors.blue.shade50,
                              //enableActiveFill: true,
                              errorAnimationController: errorController,
                              controller: textEditingController,
                              keyboardType: TextInputType.number,
                              onCompleted: (v) {
                                print("Completed");
                                bloc.code = v;
                              },
                              onChanged: (value) {
                                print(value);
                                setState(() {
                                  currentText = value;
                                });
                              },
                              beforeTextPaste: (text) {
                                print("Allowing to paste $text");
                                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                return true;
                              },
                            ),
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

class VerificationCodePageBloc with Disposable {
  String? code;

  Future<bool> verifyCode() async {
    bool isVerified = await AppService.api.verifyCode(code!);
    return isVerified;
  }

  Future<bool> resendCode(String email) async {
    bool isResend = await AppService.api.resendCode(email!);
    return isResend;
  }
}
