import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet_pe/screens/signinPage.dart';
import 'package:meet_pe/screens/signupPage.dart';
import 'package:meet_pe/utils/_utils.dart';
import 'package:meet_pe/utils/responsive_size.dart';
import 'package:meet_pe/widgets/_widgets.dart';
import '../resources/resources.dart';
import '../services/app_service.dart';
import '../utils/utils.dart';

class VerificationEmailPage extends StatefulWidget {
  const VerificationEmailPage({super.key});

  @override
  State<VerificationEmailPage> createState() => _VerificationEmailPageState();
}

class _VerificationEmailPageState extends State<VerificationEmailPage>
    with BlocProvider<VerificationEmailPage, VerificationEmailPageBloc> {
  String? validationMessage;

  @override
  initBloc() => VerificationEmailPageBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AsyncForm(
        //onValidated: bloc.checkEmail,
        onSuccess: () async {
          bool isVerified = await bloc.checkEmail();
          if (isVerified) {
            return navigateTo(
                context,
                (_) => SignInPage(
                      email: bloc.email!,
                    ));
          } else {
            return navigateTo(
                context,
                (_) => SignUpPage(
                      email: bloc.email!,
                    ));
          }
        },
        builder: (BuildContext context, void Function() validate) {
          return Stack(
            children: [
              Positioned(
                top: 48,
                left: 28,
                child: Container(
                  width: ResponsiveSize.calculateWidth(32, context),
                  height: ResponsiveSize.calculateHeight(32, context),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          ResponsiveSize.calculateCornerRadius(40, context)),
                    ),
                  ),
                  child: FloatingActionButton(
                      heroTag: "btn1",
                      backgroundColor: AppResources.colorWhite,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        String.fromCharCode(CupertinoIcons.back.codePoint),
                        style: TextStyle(
                          inherit: false,
                          color: AppResources.colorVitamine,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w900,
                          fontFamily:
                              CupertinoIcons.exclamationmark_circle.fontFamily,
                          package:
                              CupertinoIcons.exclamationmark_circle.fontPackage,
                        ),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 88,
                  left: 48,
                  right: 48,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: AppResources.colorDark),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: Theme.of(context).textTheme.bodyMedium,
                        contentPadding:
                            const EdgeInsets.only(top: 20.0, bottom: 10.0),
                        // Adjust padding
                        suffix: const SizedBox(height: 10),
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
                      autofocus: true,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (value) => validate(),
                      validator: AppResources.validatorEmail,
                      onSaved: (value) => bloc.email = value,
                      onChanged: (value) {
                        setState(() {
                          validationMessage =
                              AppResources.validatorEmail(value, true);
                        });
                      },
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    if (validationMessage != null)
                      const Text(
                        'CHAMPS INVALIDE',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w400,
                          height: 0.14,
                        ),
                      ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            width: double.infinity,
                            child: SizedBox(
                              width: 241,
                              height: 40,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          const EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 10)),
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xFFFF4C00)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                ),
                                onPressed: validate,
                                child: Text(
                                  'CONTINUER AVEC CET EMAIL',
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
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class VerificationEmailPageBloc with Disposable {
  String? email;

  Future<bool> checkEmail() async {
    bool isVerified = await AppService.api.askEmailExist(email!);
    return isVerified;
  }
}
