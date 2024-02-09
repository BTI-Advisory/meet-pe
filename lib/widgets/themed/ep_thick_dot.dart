import 'package:flutter/material.dart';

import '../../resources/resources.dart';

class EpThickDot extends StatelessWidget {
  const EpThickDot({Key? key, this.color}) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).primaryColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppResources.colorWhite,
          width: 2,
        ),
      ),
    );
  }
}
