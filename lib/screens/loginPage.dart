import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:meet_pe/screens/verificationEmailPage.dart';

import '../utils/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xffedd8be), AppResources.colorWhite],
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/logo_color.png', width: 110, height: 101,),
            SizedBox(height: 62,),
            Container(
              margin: EdgeInsets.only(left: 34, right: 35),
              child: Column(
                children: [
                  TextButton(
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset('images/googleButton.png'),
                    ),
                    onPressed: (){},
                  ),
                  SizedBox(height: 22,),
                  TextButton(
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset('images/appleButton.png'),
                    ),
                    onPressed: (){},
                  ),
                  SizedBox(height: 22,),
                  TextButton(
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset('images/facebookButton.png'),
                    ),
                    onPressed: (){},
                  ),
                  SizedBox(height: 30,),
                  Container(
                    margin: EdgeInsets.only(left: 3, right: 10),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'En continuant avec Google, Apple ou Facebook vous accepter ',
                            style: TextStyle(
                              color: Color(0xFF979797),
                              fontSize: 15,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          TextSpan(
                            text: 'les Conditions Générales',
                            style: TextStyle(
                              color: Color(0xFFFF4C00),
                              fontSize: 15,
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
                              fontSize: 15,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          TextSpan(
                            text: 'Politique de Confidentialité',
                            style: TextStyle(
                              color: Color(0xFFFF4C00),
                              fontSize: 15,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              height: 0,
                            ),
                          ),
                          TextSpan(
                            text: ' ',
                            style: TextStyle(
                              color: Color(0xFF979797),
                              fontSize: 15,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              height: 0,
                            ),
                          ),
                          TextSpan(
                            text: 'Meetpe',
                            style: TextStyle(
                              color: Color(0xFF979797),
                              fontSize: 15,
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
            SizedBox(height: 41,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 1,
                    width: double.infinity,
                    decoration: ShapeDecoration(
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
                SizedBox(width: 34,),
                Text(
                  'ou',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                SizedBox(width: 34,),
                Expanded(
                  child: Container(
                    height: 1, //
                    width: double.infinity,
                    decoration: ShapeDecoration(
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
            SizedBox(height: 53,),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 52, right: 44),
                  child: GestureDetector(
                    onTap: () {
                      //navigateTo(context, (_) => const VerificationEmailPage());
                    },
                    child: Image.asset('images/emailButton.png', height: 32,),
                  ),
                ),
              ],
            ),
            SizedBox(height: 57),
            Container(
              margin: EdgeInsets.only(left: 67, right: 67),
              child: TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 24, vertical: 10)),
                    backgroundColor:
                    MaterialStateProperty.all(Color(0xFFFF4C00)),
                    shape:
                    MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ))),
                child: Text(
                  'CONTINUER AVEC CET EMAIL',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: AppResources.colorWhite),
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
