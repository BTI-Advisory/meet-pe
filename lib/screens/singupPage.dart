import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../resources/resources.dart';

class SingUpPage extends StatefulWidget {
  const SingUpPage({super.key});

  @override
  State<SingUpPage> createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.71, -0.71),
            end: Alignment(-0.71, 0.71),
            colors: [AppResources.colorGray5, Colors.white.withOpacity(0)],
          ),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'images/logo_color.png',
                width: 110,
                height: 101,
              ),
              SizedBox(height: 50),
              Row(
                //margin: EdgeInsets.only(left: 48),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 48.0),
                    child: Column(
                      children: [
                        Text(
                          'Crée ton compte',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(
                          height: 42,
                        ),
                        Text(
                          'johndoe@cognac.com',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppResources.colorDark),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: 3,
                          child: Container(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}
