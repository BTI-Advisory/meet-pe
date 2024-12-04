import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  late List<Voyage> myList = [];
  List<Map<String, TimeOfDay?>> timeSlots = [
    {"start": null, "end": null}
  ];
  List<DateTime> selectedDays = [];

  @override
  initBloc() => CreateExpStep5Bloc(widget.infoMap, widget.name, widget.description);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AsyncForm(
          onValidated: () => bloc.addTimeDateExpGuide(timeSlots, selectedDays),
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
                            'Horaire & dates de l’expérience',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          SizedBox(
                              height: ResponsiveSize.calculateHeight(16, context)),
                          Text(
                            'Renseigne les horaires de début et de fin de l’expérience ainsi que les dates de l’expérience.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(
                              height: ResponsiveSize.calculateHeight(16, context)),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
                            decoration: ShapeDecoration(
                              color: AppResources.colorBeigeLight,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Durée de l’expérience : ',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w400, color: AppResources.colorGray60),
                                      ),
                                      TextSpan(
                                        text: 'Horaire personalisé',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppResources.colorGray60),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      shadows: [
                                        BoxShadow(
                                          color: Color(0x19FF4D00),
                                          blurRadius: 3,
                                          offset: Offset(0, 1),
                                          spreadRadius: 0,
                                        ),
                                        BoxShadow(
                                          color: Color(0x16FF4D00),
                                          blurRadius: 5,
                                          offset: Offset(0, 5),
                                          spreadRadius: 0,
                                        ),
                                        BoxShadow(
                                          color: Color(0x0CFF4D00),
                                          blurRadius: 6,
                                          offset: Offset(0, 10),
                                          spreadRadius: 0,
                                        ),
                                        BoxShadow(
                                          color: Color(0x02FF4D00),
                                          blurRadius: 7,
                                          offset: Offset(0, 18),
                                          spreadRadius: 0,
                                        ),
                                        BoxShadow(
                                          color: Color(0x00FF4D00),
                                          blurRadius: 8,
                                          offset: Offset(0, 29),
                                          spreadRadius: 0,
                                        )
                                      ],
                                    ),
                                    child: Image.asset(
                                        'images/pen_icon.png'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              height: ResponsiveSize.calculateHeight(16, context)),
                          TimeSlotWidget(
                            initialTimeSlots: timeSlots,
                            onTimeSlotsChanged: (updatedTimeSlots) {
                              setState(() {
                                timeSlots = updatedTimeSlots;
                              });
                            },
                            active: true,
                          ),
                          InkWell(
                              onTap: () async {
                                final result = await showModalBottomSheet<List<DateTime>>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return CalendarMultiSelection(initialSelectedDays: selectedDays);
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
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400, color: selectedDays.isNotEmpty ? AppResources.colorVitamine : AppResources.colorDark ),
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
  Map<String, dynamic> myMap;

  // Create a new map with lists instead of sets
  Map<String, dynamic> modifiedMap = {};

  CreateExpStep5Bloc(this.myMap, this.name, this.description);

  Future<void> addTimeDateExpGuide(List<Map<String, TimeOfDay?>> timeSlots, List<DateTime> selectedDays) async {
    try {
      // Initialize the list of time slots
      List<Map<String, dynamic>> horaires = [];

      // Iterate through the timeSlots
      for (int i = 0; i < timeSlots.length; i++) {
        Map<String, dynamic> timeSlot = {
          "heure_debut": timeSlots[i]["start"] != null ? timeOfDayToString(timeSlots[i]["start"]!) : null,
          "heure_fin": timeSlots[i]["end"] != null ? timeOfDayToString(timeSlots[i]["end"]!) : null,
          "dates": []
        };

        // Add dates for the current time slot
        for (var date in selectedDays) {
          timeSlot["dates"].add({
            "date_debut": DateFormat('yyyy-MM-dd').format(date),
          });
        }

        horaires.add(timeSlot);
      }

      // Merge new data into the original map
      myMap["horaires"] = horaires;
      modifiedMap = Map<String, dynamic>.from(myMap); // Ensure a deep copy is made

      // Debugging output
      print(modifiedMap);
    } catch (error) {
      print("Error in addTimeDateExpGuide: $error");
    }
  }

  String timeOfDayToString(TimeOfDay timeOfDay) {
    final hours = timeOfDay.hour.toString().padLeft(2, '0');
    final minutes = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hours:$minutes:00';
  }

  @override
  void dispose() {
    super.dispose();
  }
}
