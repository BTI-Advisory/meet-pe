import 'package:flutter/material.dart';

import '../../resources/resources.dart';
import '../../utils/responsive_size.dart';

class ExperiencesGuidePage extends StatefulWidget {
  const ExperiencesGuidePage({super.key});

  @override
  State<ExperiencesGuidePage> createState() => _ExperiencesGuidePageState();
}

class _ExperiencesGuidePageState extends State<ExperiencesGuidePage> {
  bool isRequest = true; // Track if it's currently "Request" or "Experience"
  bool accepted = false;

  void toggleRole() {
    setState(() {
      isRequest = !isRequest;
    });
  }
  bool firstTextActivated = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.calculateWidth(28, context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 73),
                  Text(
                    'Mes Expériences',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppResources.colorGray30),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            buildToggleButtons(),
            const SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.calculateWidth(13, context)),
              child: Column(
                children: [
                  requestCard(),
                  const SizedBox(height: 19),
                  requestCard(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildToggleButtons() {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              if (!isRequest) toggleRole();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'Demandes',
                    style: isRequest ? Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppResources.colorVitamine) : Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorDark)
                  ),
                ),
                const SizedBox(height: 4),
                if (isRequest)
                  Container(
                    width: 188,
                    height: 4,
                    decoration: const ShapeDecoration(
                      color: AppResources.colorVitamine,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              if (isRequest) toggleRole();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'Mes expériences',
                      style: isRequest ? Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorDark) : Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppResources.colorVitamine)
                  ),
                ),
                const SizedBox(height: 4),
                if (!isRequest)
                  Container(
                    width: 188,
                    height: 4,
                    decoration: const ShapeDecoration(
                      color: AppResources.colorVitamine,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget requestCard() {
    return Column(
      children: [
        Container(
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
          child: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      ClipOval(
                        child: Image.asset('images/imageTest.png', width: 38, height: 38, fit: BoxFit.cover)
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Lucie',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontWeight: FontWeight.w500, color: AppResources.colorDark),
                      )
                    ],
                  ),
                  const SizedBox(width: 17),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ma. 17 fév. à 11h30',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontSize: 14, color: AppResources.colorDark),
                      ),
                      Text(
                        'Le Paris de Maria...',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorGray60),
                      ),
                    ],
                  ),
                  const SizedBox(width: 23),
                  Visibility(
                    visible: !accepted,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              accepted = true;
                            });
                            print('Accepted');
                          },
                          child: Column(
                            children: [
                              Icon(Icons.check, size: 24,),
                              const SizedBox(height: 4),
                              Text(
                                'Accepter',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: AppResources.colorDark),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 19),
                        Column(
                          children: [
                            Icon(Icons.do_not_disturb, size: 24,),
                            const SizedBox(height: 4),
                            Text(
                              'Refuser',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: AppResources.colorDark),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: accepted,
                    child: Row(
                      children: [
                        const Icon(Icons.check, size: 24, color: Color(0xFF54EE9D),),
                        const SizedBox(width: 8),
                        Text(
                          'Accepté',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Color(0xFF54EE9D)),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 11),
            ],
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
