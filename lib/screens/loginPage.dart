import 'package:flutter/material.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:meet_pe/screens/verificationEmailPage.dart';

import '../utils/responsive_size.dart';
import '../utils/utils.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meet_pe/firebase_options.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

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

    final credential = GoogleAuthProvider. credential(accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final OAuthCredential facebookAuthCredential =
    FacebookAuthProvider.credential(loginResult.accessToken!.token);
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
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
                          print('Hello world: ${userCredential.user!.email}');
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
                    onPressed: (){},
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
                          print('Hello world: ${userCredential.user!.displayName}');
                        }
                      } catch(e) {}
                    },
                  ),
                  SizedBox(height: ResponsiveSize.calculateHeight(30, context),),
                  SizedBox(
                    width: ResponsiveSize.calculateWidth(325, context),
                    child: const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
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
                            style: TextStyle(
                              color: Color(0xFFFF4C00),
                              fontSize: 14,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              height: 0,
                            ),
                          ),
                          TextSpan(
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
                            style: TextStyle(
                              color: Color(0xFFFF4C00),
                              fontSize: 14,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              height: 0,
                            ),
                          ),
                          TextSpan(
                            text: ' Meetpe',
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
                      //navigateTo(context, (_) => const VerificationEmailPage());
                    },
                    child: Image.asset('images/emailButton.png', width: ResponsiveSize.calculateWidth(279, context), height: ResponsiveSize.calculateHeight(32, context),),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveSize.calculateHeight(57, context)),
            Container(
              width: ResponsiveSize.calculateWidth(241, context),
              height: 40,
              child: TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(24, context), vertical: ResponsiveSize.calculateHeight(10, context))),
                    backgroundColor:
                    MaterialStateProperty.all(Color(0xFFFF4C00)),
                    shape:
                    MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ResponsiveSize.calculateCornerRadius(24, context)),
                        ))),
                child: Text(
                  'CONTINUER AVEC CET EMAIL',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: AppResources.colorWhite, fontSize: ResponsiveSize.calculateTextSize(12, context)),
                ),
                onPressed: () {
                  navigateTo(context, (_) => const VerificationEmailPage());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
