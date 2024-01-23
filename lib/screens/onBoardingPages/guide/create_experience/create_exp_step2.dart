import 'package:flutter/material.dart';

import '../../../../resources/resources.dart';
import '../../../../utils/responsive_size.dart';

class CreateExpStep2 extends StatefulWidget {
  CreateExpStep2({super.key, required this.myMap});

  Map<String, Set<Object>> myMap = {};

  @override
  State<CreateExpStep2> createState() => _CreateExpStep2State();
}

class _CreateExpStep2State extends State<CreateExpStep2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppResources.colorGray5, AppResources.colorWhite],
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('images/backgroundExp.png'),
              SizedBox(height: ResponsiveSize.calculateHeight(40, context)),
              Text(
                'Étape 2 sur 8',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: 10, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
