import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:meet_pe/screens/welcomePage.dart';
import 'package:meet_pe/utils/responsive_size.dart';
import 'package:rxdart/rxdart.dart';

import '../resources/resources.dart';
import '../services/app_service.dart';
import '../utils/_utils.dart';
import '../widgets/async_form.dart';

class VerificationCodePage extends StatefulWidget {
  const VerificationCodePage({super.key,});

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}


class _VerificationCodePageState extends State<VerificationCodePage>
    with BlocProvider<VerificationCodePage, VerificationCodePageBloc> {

  @override
  initBloc() => VerificationCodePageBloc();

  bool _onEditing = true;
  String? _code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AsyncForm(
            onValidated: bloc.verifyCode,
            onSuccess: () async {
              bool isVerified = await bloc.verifyCode();
              if (isVerified) {
                return navigateTo(context, (_) => WelcomePage());
              } else {
                //Todo: add alert
                showMessage(context, 'Erreur code');
              }
            },
            builder: (context, validate) {
              return Container(
                constraints: BoxConstraints.expand(),
                child: Padding(
                  padding: EdgeInsets.only(top: ResponsiveSize.calculateHeight(221, context)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(24, context)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tu viens de recevoir un code !',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                SizedBox(
                                  height: ResponsiveSize.calculateHeight(16, context),
                                ),
                                Text(
                                  'Entre le pour vérifier que c’est bien toi !',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppResources.colorGray30),
                                ),
                                SizedBox(
                                  height: ResponsiveSize.calculateHeight(42, context),
                                ),
                                VerificationCode(
                                  itemSize: 40,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(color: AppResources.colorDark, fontSize: 32),
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
                                    if (!_onEditing) FocusScope.of(context).unfocus();
                                  },
                                ),
                                SizedBox(
                                  height: ResponsiveSize.calculateHeight(66, context),
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
                              width: ResponsiveSize.calculateWidth(241, context),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  padding:
                                  MaterialStateProperty.all<EdgeInsets>(
                                      EdgeInsets.symmetric(
                                          horizontal: ResponsiveSize.calculateWidth(24, context), vertical: ResponsiveSize.calculateHeight(10, context))),
                                  backgroundColor: MaterialStateProperty.all(
                                      AppResources.colorVitamine),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(ResponsiveSize.calculateCornerRadius(40, context),),
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
            }));
  }
}

class VerificationCodePageBloc with Disposable {
  String? code;

  Future<bool> verifyCode() async {
    bool isVerified = await AppService.api.verifyCode(code!);
    return isVerified;
  }
}

