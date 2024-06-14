import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:meet_pe/screens/authentification/verificationEmailPage.dart';
import 'package:meet_pe/screens/authentification/welcomePage.dart';
import 'package:meet_pe/services/app_service.dart';
import 'package:meet_pe/widgets/web_view_container.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../services/secure_storage_service.dart';
import '../../utils/_utils.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meet_pe/firebase_options.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../guideProfilPages/main_guide_page.dart';
import '../homePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Future<UserCredential> signInWithGoogle() async{
    final GoogleSignInAccount? googleUser = await GoogleSignIn(clientId:
    (DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.ios)
        ? DefaultFirebaseOptions.currentPlatform.iosClientId
        : DefaultFirebaseOptions.currentPlatform.androidClientId
    ).signIn();

    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final OAuthCredential facebookAuthCredential =
    FacebookAuthProvider.credential(loginResult.accessToken!.token);
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<UserCredential> signInWithApple() async {
    final appleProvider = AppleAuthProvider();
    appleProvider.addScope('email');
    var credential = await FirebaseAuth.instance.signInWithProvider(appleProvider);
    return credential;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xffedd8be), AppResources.colorWhite],
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/logo_color.png', width: ResponsiveSize.calculateWidth(110, context), height: ResponsiveSize.calculateHeight(101, context),),
            SizedBox(height: ResponsiveSize.calculateHeight(62, context),),
            Container(
              margin: EdgeInsets.only(left: ResponsiveSize.calculateWidth(24, context), right: ResponsiveSize.calculateWidth(25, context)),
              child: Column(
                children: [
                  TextButton(
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset('images/googleButton.png'),
                    ),
                    onPressed: () async {
                      try {
                        final UserCredential userCredential = await signInWithGoogle();
                        if(context.mounted) {
                          await AppService.api.loginSocial(userCredential.user!.displayName!, userCredential.user!.email!, await userCredential.user!.getIdToken() ?? '');
                          Future.delayed(Duration(seconds: 1), () async {
                            if(await SecureStorageService.readAction() == 'connexion') {
                              if (await SecureStorageService.readRole() == '1') {
                                navigateTo(context, (_) => const HomePage());
                              } else {
                                navigateTo(context, (_) => const MainGuidePage());
                              }
                            } else {
                              navigateTo(context, (_) => const WelcomePage(fromCode: false));
                            }
                          });
                        }
                      } catch(e) {}
                    },
                  ),
                  SizedBox(height: ResponsiveSize.calculateHeight(22, context),),
                  TextButton(
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset('images/appleButton.png'),
                    ),
                      onPressed: () async {
                        try {
                          final UserCredential userCredential = await signInWithApple();
                          if(context.mounted) {
                            await AppService.api.loginSocial('From Apple', userCredential.user!.email!, userCredential.user!.uid ?? '');
                            Future.delayed(Duration(seconds: 1), () async {
                              if(await SecureStorageService.readAction() == 'connexion') {
                                if (await SecureStorageService.readRole() == '1') {
                                  navigateTo(context, (_) => const HomePage());
                                } else {
                                  navigateTo(context, (_) => const MainGuidePage());
                                }
                              } else {
                                navigateTo(context, (_) => const WelcomePage(fromCode: false));
                              }
                            });
                          }
                        } catch(e) {}
                      },
                  ),
                  SizedBox(height: ResponsiveSize.calculateHeight(22, context),),
                  TextButton(
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset('images/facebookButton.png'),
                    ),
                    onPressed: () async {
                      try {
                        final UserCredential userCredential = await signInWithFacebook();
                        if(context.mounted) {
                          await AppService.api.loginSocial(userCredential.user!.displayName!, userCredential.user!.email!, await userCredential.user!.getIdToken() ?? '');
                          Future.delayed(Duration(seconds: 1), () async {
                            if(await SecureStorageService.readAction() == 'connexion') {
                              if (await SecureStorageService.readRole() == '1') {
                                navigateTo(context, (_) => const HomePage());
                              } else if (await SecureStorageService.readRole() == '2') {
                                navigateTo(context, (_) => const MainGuidePage());
                              }
                            } else {
                              navigateTo(context, (_) => const WelcomePage(fromCode: false));
                            }
                          });
                        }
                      } catch(e) {}
                    },
                  ),
                  SizedBox(height: ResponsiveSize.calculateHeight(30, context),),
                  SizedBox(
                    width: ResponsiveSize.calculateWidth(325, context),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'En continuant avec Google, Apple ou Facebook vous accepter ',
                            style: TextStyle(
                              color: Color(0xFF979797),
                              fontSize: 14,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          TextSpan(
                            text: 'les Conditions Générales',
                            style: const TextStyle(
                              color: Color(0xFFFF4C00),
                              fontSize: 14,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              height: 0,
                            ),
                            recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              navigateTo(context, (_) => const WebViewContainer(webUrl: 'https://meetpe.fr/conditions-generales'));
                            },
                          ),
                          const TextSpan(
                            text: ' et la ',
                            style: TextStyle(
                              color: Color(0xFF979797),
                              fontSize: 14,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          TextSpan(
                            text: 'Politique de Confidentialité',
                            style: const TextStyle(
                              color: Color(0xFFFF4C00),
                              fontSize: 14,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              height: 0,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                navigateTo(context, (_) => const WebViewContainer(webUrl: 'https://meetpe.fr/privacy'));
                              },
                          ),
                          const TextSpan(
                            text: ' Meet People',
                            style: TextStyle(
                              color: Color(0xFF979797),
                              fontSize: 14,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveSize.calculateHeight(41, context),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 1,
                    width: double.infinity,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFFE2E2E2),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveSize.calculateWidth(34, context),),
                const Text(
                  'ou',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                SizedBox(width: ResponsiveSize.calculateWidth(34, context),),
                Expanded(
                  child: Container(
                    height: 1, //
                    width: double.infinity,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFFE2E2E2),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveSize.calculateHeight(53, context),),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: ResponsiveSize.calculateWidth(52, context), right: ResponsiveSize.calculateWidth(44, context)),
                  child: GestureDetector(
                    onTap: () {
                      navigateTo(context, (_) => const VerificationEmailPage());
                    },
                    child: Image.asset('images/emailButton.png', width: ResponsiveSize.calculateWidth(279, context), height: ResponsiveSize.calculateHeight(32, context),),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveSize.calculateHeight(57, context)),
          ],
        ),
      ),
    );
  }
}
