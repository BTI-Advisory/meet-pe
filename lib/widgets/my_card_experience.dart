import 'package:flutter/material.dart';
import 'package:widget_mask/widget_mask.dart';

import '../resources/resources.dart';

class MyCardExperience extends StatefulWidget {
  const MyCardExperience({Key? key}) : super(key: key);

  @override
  _MyCardExperienceState createState() => _MyCardExperienceState();
}

class _MyCardExperienceState extends State<MyCardExperience> {
  bool accepted = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                shadows: const [
                  BoxShadow(
                    color: Color(0x1E000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Row(
                children: [
                  WidgetMask(
                    blendMode: BlendMode.srcATop,
                    childSaveLayer: true,
                    mask: Image.asset(
                      'images/imageTest.png',
                      width: 68,
                      height: 68,
                      fit: BoxFit.cover,
                    ),
                    child: Image.asset(
                      'images/mask_picture.png',
                      width: 68,
                      height: 68,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Le Paris de Maria en deux...',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontSize: 14, color: AppResources.colorDark),
                      ),
                      Text(
                        'Postée le 16/07/2024',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorGray60),
                      ),
                      const Row(
                        children: [
                          Icon(Icons.circle, size: 10, color: Color(0xFF54EE9D)),
                          Text(
                            'en ligne',
                            style: TextStyle(
                              color: Color(0xFF54EE9D),
                              fontSize: 10,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w400,
                              height: 0.14,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(width: 43),
                  const Icon(Icons.chevron_right, size: 24, color: AppResources.colorDark,)
                ],
              ),
            ),
            Positioned(
                top: 0,
                left: 73,
                child: Container(
                  width: 43,
                  height: 18,
                  decoration: ShapeDecoration(
                    color: AppResources.colorVitamine,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: Center(
                    child: Text(
                        'New',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 12, color: AppResources.colorWhite)
                    ),
                  ),
                )
            )
          ]
        ),
        const SizedBox(height: 18),
      ],
    );
  }
}