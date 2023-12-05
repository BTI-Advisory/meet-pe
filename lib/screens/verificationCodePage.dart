import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:rxdart/rxdart.dart';

import '../resources/resources.dart';
import '../services/app_service.dart';
import '../utils/_utils.dart';
import '../widgets/async_form.dart';
import 'loginPage.dart';

class VerificationCodePage extends StatefulWidget {
  const VerificationCodePage({super.key,});

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}


class _VerificationCodePageState extends State<VerificationCodePage>
    with BlocProvider<VerificationCodePage, VerificationCodePageBloc> {

  @override
  initBloc() => VerificationCodePageBloc(code: '1234');

  bool _onEditing = true;
  String? _code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AsyncForm(
            onValidated: bloc.verifyCode,
            onSuccess: () {
              return navigateTo(context, (_) => const LoginPage(),
                  clearHistory: true);
            },
            builder: (context, validate) {
              bloc.setValidateForm(validate);
              return Container(
                constraints: BoxConstraints.expand(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 221),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 48.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tu viens de recevoir un code !',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  'Entre le pour vérifier que c’est bien toi !',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppResources.colorGray30),
                                ),
                                const SizedBox(
                                  height: 42,
                                ),
                                VerificationCode(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(color: AppResources.colorDark, fontSize: 32),
                                  keyboardType: TextInputType.number,
                                  underlineColor: AppResources.colorGray15,
                                  length: 4,
                                  cursorColor: AppResources.colorDark,
                                  margin: const EdgeInsets.all(12),
                                  onCompleted: (String value) {
                                    setState(() {
                                      _code = value;
                                    });
                                  },
                                  onEditing: (bool value) {
                                    setState(() {
                                      _onEditing = value;
                                    });
                                    if (!_onEditing) FocusScope.of(context).unfocus();
                                  },
                                ),
                                const SizedBox(
                                  height: 66,
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Renvoyer le code',
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
                              const EdgeInsets.only(left: 96, right: 96),
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
                                child: Image.asset('images/arrowLongRight.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }));
  }
}

class VerificationCodePageBloc with Disposable {
  late TextEditingController usernameController, passwordController;
  late Function() validateForm;
  final String code;

  VerificationCodePageBloc({required this.code}) {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    usernameController.text = code;
  }

  void setValidateForm(Function() value) => validateForm = value;

  BehaviorSubject<String> get appVersion => AppService.instance.appVersion;

  //Future<void> login() => AppService.instance
  //.login(usernameController.text, passwordController.text);
  Future<void> verifyCode() async {
    print('Login function called'); // Check if this is printed
    await AppService.instance
        .login(usernameController.text, passwordController.text);
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

