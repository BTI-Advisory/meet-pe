import 'package:flutter/material.dart';
import 'package:meet_pe/models/guide_experiences_response.dart';

import '../../models/guide_reservation_response.dart';
import '../../resources/app_theme.dart';
import '../../resources/resources.dart';
import '../../services/app_service.dart';
import '../../utils/responsive_size.dart';
import '../../utils/utils.dart';
import '../../widgets/_widgets.dart';
import '../onBoardingPages/guide/create_experience/create_exp_step1.dart';
import 'experiencePages/edit_experience_page.dart';

class ExperiencesGuidePage extends StatefulWidget {
  const ExperiencesGuidePage({super.key});

  @override
  State<ExperiencesGuidePage> createState() => _ExperiencesGuidePageState();
}

class _ExperiencesGuidePageState extends State<ExperiencesGuidePage> {
  bool isRequest = true; // Track if it's currently "Request" or "Experience"
  List<GuideReservationResponse> reservationList = [];
  List<GuideExperiencesResponse> experiencesList = [];

  @override
  void initState() {
    super.initState();
    fetchGuideReservationData();
    fetchGuideExperiencesData();
  }

  void toggleRole() {
    setState(() {
      isRequest = !isRequest;
    });
  }

  Future<void> fetchGuideReservationData() async {
    try {
      final response = await AppService.api.getGuideReservationList();
      setState(() {
        reservationList = response;
      });
      for (var item in reservationList) {
        print(item.voyageur);
      }
    } catch (e) {
      // Handle error
      print('Error fetching reservation list: $e');
    }
  }

  Future<void> fetchGuideExperiencesData() async {
    try {
      final response = await AppService.api.getGuideExperiencesList();
      setState(() {
        experiencesList = response;
      });
      for (var item in experiencesList) {
        print(item.status);
      }
    } catch (e) {
      // Handle error
      print('Error fetching experiences list: $e');
    }
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
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => _buildPopupDialog(context),
                              );
                            },
                            child: RequestCard(),
                          ),
                          RequestCard(),
                        ],
                      )
                    : Column(
                        children: List.generate(
                          experiencesList.length,
                              (index) => GestureDetector(
                                onTap: () {
                                  navigateTo(context, (_) => const EditExperiencePage());
                                },
                                child: MyCardExperience(guideExperiencesResponse: experiencesList[index],),
                              ),
                        ),
                        /*children: [
                          GestureDetector(
                            onTap: () {
                              navigateTo(context, (_) => const EditExperiencePage());
                            },
                            child: MyCardExperience(),
                          ),
                          MyCardExperience(),
                        ],*/
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
                navigateTo(context, (_) => const CreateExpStep1());
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

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(horizontal: 0),
      backgroundColor: AppResources.colorWhite,
      content: SizedBox(
        width: 329,
        height: 420,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 19),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 21),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                              child: Image.asset('images/imageTest.png', width: 75, height: 75, fit: BoxFit.cover)
                          ),
                          SizedBox(width: ResponsiveSize.calculateWidth(19, context)),
                          Column(
                            children: [
                              Text(
                                'Chen',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorDark)
                              ),
                              Text(
                                  'Lucie',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorDark)
                              )
                            ],
                          )
                        ],
                      ),
                      IconButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close, size: 20, color: AppResources.colorGray30),
                      )
                    ],
                  ),
                  const SizedBox(height: 21),
                  Row(
                    children: [
                      Container(
                        height: ResponsiveSize.calculateHeight(
                            28, context),
                        padding: EdgeInsets.symmetric(
                            horizontal:
                            ResponsiveSize.calculateWidth(
                                12, context)),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(
                              Radius.circular(ResponsiveSize
                                  .calculateCornerRadius(
                                  20, context))),
                          border: Border.all(
                              color: AppResources.colorDark),
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              Image.asset(
                                  'images/icon_verified.png', color: AppResources.colorDark),
                              SizedBox(width: ResponsiveSize.calculateWidth(4, context)),
                              Text(
                                'Vérifié',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                  color: AppResources
                                      .colorDark,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: ResponsiveSize.calculateWidth(41, context)),
                      Text(
                        'expériences vécues',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorDark),
                      ),
                      SizedBox(width: ResponsiveSize.calculateWidth(5, context)),
                      Text(
                        '343',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppResources.colorDark),
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Expérience réservée le 26/11/24',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorDark, fontSize: 12),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Le Paris de Maria en deux lignes',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppResources.colorDark, fontSize: 14),
                  ),
                  const SizedBox(height: 23),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nombre de voyageurs',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorDark, fontSize: 12),
                      ),
                      Text(
                        '2',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppResources.colorDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Créneau réservé',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorDark, fontSize: 12),
                      ),
                      Text(
                        'Ma. 17 fév. 11h30',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppResources.colorDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: const ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: AppResources.colorImputStroke,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
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
                  GestureDetector(
                    onTap: () {
                      print('Refuser');
                    },
                    child: Column(
                      children: [
                        Icon(Icons.close, size: 24,),
                        const SizedBox(height: 4),
                        Text(
                          'Refuser',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: AppResources.colorDark),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      )
    );
  }
}
