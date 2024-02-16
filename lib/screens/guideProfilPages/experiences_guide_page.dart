import 'package:flutter/material.dart';

import '../../resources/resources.dart';
import '../../utils/responsive_size.dart';

class ExperiencesGuidePage extends StatefulWidget {
  const ExperiencesGuidePage({super.key});

  @override
  State<ExperiencesGuidePage> createState() => _ExperiencesGuidePageState();
}

class _ExperiencesGuidePageState extends State<ExperiencesGuidePage> {
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
