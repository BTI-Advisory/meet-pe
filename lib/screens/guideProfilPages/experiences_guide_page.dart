import 'package:flutter/material.dart';

import '../../resources/app_theme.dart';
import '../../resources/resources.dart';
import '../../utils/responsive_size.dart';
import '../../widgets/_widgets.dart';

class ExperiencesGuidePage extends StatefulWidget {
  const ExperiencesGuidePage({super.key});

  @override
  State<ExperiencesGuidePage> createState() => _ExperiencesGuidePageState();
}

class _ExperiencesGuidePageState extends State<ExperiencesGuidePage> {
  bool isRequest = true; // Track if it's currently "Request" or "Experience"

  void toggleRole() {
    setState(() {
      isRequest = !isRequest;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: buildAppTheme(),
      home: Scaffold(
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
                child: isRequest
                    ? Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                            },
                            child: RequestCard(),
                          ),
                          RequestCard(),
                        ],
                      )
                    : Column(
                        children: [
                          MyCardExperience(),
                          MyCardExperience(),
                        ],
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: Visibility(
          visible: !isRequest,
          child: SizedBox(
            width: 52.0,
            height: 52.0,
            child: FloatingActionButton(
              onPressed: () {
                // Add your action here
                print('Floating Action Button pressed');
              },
              backgroundColor: AppResources.colorVitamine,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    26.0), // Half of width or height to make it circular
              ),
              child: const Icon(Icons.add, color: AppResources.colorWhite),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
                  child: Text('Demandes',
                      style: isRequest
                          ? Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(color: AppResources.colorVitamine)
                          : Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppResources.colorDark)),
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
                  child: Text('Mes expériences',
                      style: isRequest
                          ? Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppResources.colorDark)
                          : Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(color: AppResources.colorVitamine)),
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
}
