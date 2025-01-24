import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:meet_pe/screens/authentification/verificationEmailPage.dart';
import 'package:meet_pe/widgets/web_view_container.dart';
import '../../utils/_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  ///Todo: Hide social connect button, problem with google in android device
  /*Future<UserCredential> signInWithGoogle() async{
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
    FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<UserCredential> signInWithApple() async {
    final appleProvider = AppleAuthProvider();
    appleProvider.addScope('email');
    var credential = await FirebaseAuth.instance.signInWithProvider(appleProvider);
    return credential;
  }*/

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
            SizedBox(height: ResponsiveSize.calculateHeight(62, context),),
            Container(
              margin: EdgeInsets.only(left: ResponsiveSize.calculateWidth(24, context), right: ResponsiveSize.calculateWidth(25, context)),
              child: Column(
                children: [
                  ///Todo: Hide social connect button, problem with google in android device
                  /*TextButton(
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
                                navigateTo(context, (_) => MainTravelersPage(initialPage: 0,));
                              } else {
                                navigateTo(context, (_) => MainGuidePage(initialPage: 2));
                              }
                            } else {
                              navigateTo(context, (_) => const WelcomePage(fromCode: false));
                            }
                          });
                        }
                      } catch(e) {
                        print('FRFRHFURHUFRF FFF $e');
                        showMessage(context, 'Hello $e');
                      }
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
                                  navigateTo(context, (_) => MainTravelersPage(initialPage: 0,));
                                } else {
                                  navigateTo(context, (_) => MainGuidePage(initialPage: 2));
                                }
                              } else {
                                navigateTo(context, (_) => const WelcomePage(fromCode: false));
                              }
                            });
                          }
                        } catch(e) {}
                      },
                  ),*/
                  ///Todo: when fix facebook response with flutter
                  /*SizedBox(height: ResponsiveSize.calculateHeight(22, context),),
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
                                navigateTo(context, (_) => MainGuidePage(initialPage: 2));
                              }
                            } else {
                              navigateTo(context, (_) => const WelcomePage(fromCode: false));
                            }
                          });
                        }
                      } catch(e) {}
                    },
                  ),*/
                  SizedBox(height: ResponsiveSize.calculateHeight(30, context),),
                  SizedBox(
                    width: ResponsiveSize.calculateWidth(325, context),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: AppLocalizations.of(context)!.login_1_text,
                            style: TextStyle(
                              color: Color(0xFF979797),
                              fontSize: 14,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          TextSpan(
                            text: AppLocalizations.of(context)!.login_2_text,
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
                          TextSpan(
                            text: AppLocalizations.of(context)!.login_3_text,
                            style: TextStyle(
                              color: Color(0xFF979797),
                              fontSize: 14,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          TextSpan(
                            text: AppLocalizations.of(context)!.login_4_text,
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
                                navigateTo(context, (_) => const WebViewContainer(webUrl: 'https://www.meetpe.fr/privacy'));
                              },
                          ),
                          TextSpan(
                            text: AppLocalizations.of(context)!.login_5_text,
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
            ///Todo: Remove comment when social button is back
            /*SizedBox(height: ResponsiveSize.calculateHeight(41, context),),
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
            ),*/
            SizedBox(height: ResponsiveSize.calculateHeight(57, context)),
          ],
        ),
      ),
    );
  }
}
