import 'package:flutter/material.dart';
import 'package:meet_pe/utils/_utils.dart';
import 'package:meet_pe/widgets/_widgets.dart';

import '../../../../resources/resources.dart';
import 'create_exp_step6.dart';

class CreateExpStep5 extends StatefulWidget {
  CreateExpStep5({super.key, required this.name, required this.description, required this.infoMap});

  Map<String, dynamic> infoMap = {};
  final String name;
  final String description;

  @override
  State<CreateExpStep5> createState() => _CreateExpStep5State();
}

class _CreateExpStep5State extends State<CreateExpStep5> with BlocProvider<CreateExpStep5, CreateExpStep5Bloc> {
  final idExperience = 0;
  late List<Voyage> myList = [];
  List<Map<String, TimeOfDay?>> timeSlots = [
    {"start": null, "end": null}
  ];
  List<DateTime> selectedDays = [];

  @override
  initBloc() => CreateExpStep5Bloc(widget.infoMap, widget.name, widget.description, idExperience);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AsyncForm(
          onValidated: bloc.makeExperienceGuide1,
          onSuccess: () {
            return navigateTo(context, (_) => CreateExpStep6(name: widget.name, description: widget.description, infoMap: bloc.modifiedMap,));
          },
          builder: (BuildContext context, void Function() validate) {
            return Container(
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
                    Image.asset(
                      'images/backgroundExp3.png',
                      width: double.infinity,
                      fit: BoxFit.fill,
                      height: ResponsiveSize.calculateHeight(190, context),
                    ),
                    SizedBox(height: ResponsiveSize.calculateHeight(40, context)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Étape 4 sur 11',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontSize: 10, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                              height: ResponsiveSize.calculateHeight(8, context)),
                          Text(
                            'Horaire de l’expérience',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          SizedBox(
                              height: ResponsiveSize.calculateHeight(16, context)),
                          Text(
                            'Renseigne l’horaire de début de l’expérience et de fin de l’expérience.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(
                              height: ResponsiveSize.calculateHeight(40, context)),
                          TimeSlotWidget(
                            initialTimeSlots: timeSlots,
                            onTimeSlotsChanged: (updatedTimeSlots) {
                              setState(() {
                                timeSlots = updatedTimeSlots;
                              });
                            },
                          ),
                          InkWell(
                              onTap: () async {
                                final result = await showModalBottomSheet<List<DateTime>>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return CalendarMultiSelection();
                                  },
                                );
                                if (result != null && result.isNotEmpty) {
                                  setState(() {
                                    selectedDays = result;
                                  });
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Dates de l’expérience',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorDark),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        selectedDays.isNotEmpty ? 'Renseigné' : 'Non renseigné',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400, color: AppResources.colorDark),
                                      ),
                                      Image.asset('images/chevron_right.png',
                                          width: 27, height: 27, fit: BoxFit.fill),
                                    ],
                                  ),
                                ],
                              ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: ResponsiveSize.calculateHeight(44, context),
                              right: ResponsiveSize.calculateWidth(28, context)),
                          child: Container(
                            width: ResponsiveSize.calculateWidth(151, context),
                            height: ResponsiveSize.calculateHeight(44, context),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.symmetric(
                                    horizontal: ResponsiveSize.calculateHeight(24, context),
                                    vertical: ResponsiveSize.calculateHeight(10, context),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.disabled)) {
                                      return AppResources.colorGray15; // Disabled color
                                    }
                                    return AppResources.colorVitamine; // Enabled color
                                  },
                                ),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                              ),
                              onPressed: timeSlots.any((slot) => slot["start"] != null && slot["end"] != null) && selectedDays.isNotEmpty
                                  ? () {
                                setState(() {
                                  validate();
                                });
                              }
                                  : null,
                              child: Image.asset('images/arrowLongRight.png'),
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
      ),
    );
  }
}

class CreateExpStep5Bloc with Disposable {
  String? name;
  String? description;
  int? idExperience;
  Map<String, dynamic> myMap;

  // Create a new map with lists instead of sets
  Map<String, dynamic> modifiedMap = {};

  CreateExpStep5Bloc(this.myMap, this.name, this.description, this.idExperience);

  Future<void> makeExperienceGuide1() async {
    try {
      /*// Convert sets to lists
      myMap.forEach((key, value) {
        modifiedMap[key] = value.toList();
      });*/
      modifiedMap = myMap;

    } catch (error) {
      // Handle the error appropriately
      print("Error in make Experience Guide 1: $error");
    }
  }

  @override
  void dispose() {
    // Dispose of any resources if needed
    super.dispose();
  }
}
