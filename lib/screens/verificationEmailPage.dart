import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet_pe/screens/singupPage.dart';

import '../resources/resources.dart';
import '../utils/utils.dart';

class VerificationEmailPage extends StatefulWidget {
  const VerificationEmailPage({super.key});

  @override
  State<VerificationEmailPage> createState() => _VerificationEmailPageState();
}

class _VerificationEmailPageState extends State<VerificationEmailPage> {
  bool _isError = false;
  TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 88,
          left: 48,
          right: 48,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _textController,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppResources.colorDark),
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: Theme.of(context).textTheme.bodyMedium,
                contentPadding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                // Adjust padding
                suffix: const SizedBox(height: 10),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: _isError ? Color(0xFFFF0000) : Color(0xFF737271)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: _isError ? Color(0xFFFF0000) : Color(0xFF737271)),
                ),
              ),
              //autofocus: true,
              //textInputAction: TextInputAction.next,
              //validator: AppResources.validatorNotEmpty,
              //controller: bloc.usernameController,
              onChanged: (value) {
                // Validate email or any other criteria
                if (value.isNotEmpty && !value.contains('@')) {
                  setState(() {
                    _isError = true;
                  });
                } else {
                  setState(() {
                    _isError = false;
                  });
                }
              },
            ),
            SizedBox(
              height: 17,
            ),
            Text(
              'CHAMPS INVALIDE',
              style: TextStyle(
                color: Color(0xFFFF0000),
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
                      width: 183,
                      height: 44,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(Size(183, 44)),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(horizontal: 34, vertical: 14)),
                          backgroundColor: MaterialStateProperty.all(Color(0xFFFF4C00)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                        onPressed: () {
                          navigateTo(context, (_) => const SingUpPage());
                        },
                        child: Image.asset(
                          'images/arrowLongRight.png',
                          fit: BoxFit.contain,
                          width: 44,
                          height: 24,
                        ),
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
  }
}