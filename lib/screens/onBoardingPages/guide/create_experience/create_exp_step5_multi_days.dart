import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meet_pe/utils/_utils.dart';
import 'package:meet_pe/widgets/_widgets.dart';

import '../../../../resources/resources.dart';
import 'create_exp_step6.dart';

class CreateExpStep5MultiDays extends StatefulWidget {
  CreateExpStep5MultiDays({super.key, required this.name, required this.description, required this.infoMap, required this.duration});

  Map<String, dynamic> infoMap = {};
  final String name;
  final String description;
  final int duration;

  @override
  State<CreateExpStep5MultiDays> createState() => _CreateExpStep5MultiDaysState();
}

class _CreateExpStep5MultiDaysState extends State<CreateExpStep5MultiDays> with BlocProvider<CreateExpStep5MultiDays, CreateExpStep5MultiDaysBloc> {
  late List<Voyage> myList = [];
  List<Map<String, TimeOfDay?>> timeSlots = [
    {"start": null, "end": null}
  ];
  // Add a state for selected ranges
  List<Map<String, DateTime>> selectedRanges = [];

  @override
  initBloc() => CreateExpStep5MultiDaysBloc(widget.infoMap, widget.name, widget.description);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: AsyncForm(
            onValidated: () => bloc.addTimeDateExpGuide(timeSlots, selectedRanges),
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
                                          text: widget.duration == 2 ? "48 h" : "7 jours",
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
                              active: false,
                            ),
                            SizedBox(
                                height: ResponsiveSize.calculateHeight(16, context)),
                            Text(
                              'L’expérience commence à ${timeSlots.isNotEmpty && timeSlots.first["start"] != null ? timeSlots.first["start"]!.format(context) : "00:00"} '
                                  'et se termine ${widget.duration == 2 ? "48 h" : "7 jours"} après à ${timeSlots.isNotEmpty && timeSlots.first["end"] != null ? timeSlots.first["end"]!.format(context) : "23:59"}.',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppResources.colorGray60),
                            ),
                            SizedBox(
                                height: ResponsiveSize.calculateHeight(18, context)),
                            InkWell(
                              onTap: () async {
                                final result = await showModalBottomSheet<List<DateTime?>>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return CalendarRangeSelection(duration: widget.duration,);
                                  },
                                );
                                if (result != null && result.length == 2) {
                                  final startDate = result[0];
                                  final endDate = result[1];

                                  if (startDate != null && endDate != null) {
                                    setState(() {
                                      selectedRanges.add({
                                        "start": startDate,
                                        "end": endDate,
                                      });
                                    });
                                  }
                                }
                              },
                              child: Text(
                                '+ Ajouter des dates',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppResources.colorVitamine),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...selectedRanges.map((range) {
                        final startDate = range["start"];
                        final endDate = range["end"];
                        final rangeIndex = selectedRanges.indexOf(range); // Get the index for Dismissible key

                        return Dismissible(
                          key: ValueKey(rangeIndex), // Unique key for each item
                          direction: DismissDirection.endToStart, // Allow swipe to delete
                          background: Container(
                            color: Colors.red, // Background color when swiping
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (direction) {
                            setState(() {
                              selectedRanges.removeAt(rangeIndex); // Remove the item from the list
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Date range removed')),
                            );
                          },
                          child: GestureDetector(
                            onTap: () async {
                              final result = await showModalBottomSheet<List<DateTime?>>(
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return CalendarRangeSelection(
                                    duration: widget.duration,
                                    initialStartDate: startDate,
                                    initialEndDate: endDate,
                                  );
                                },
                              );

                              if (result != null && result.length == 2) {
                                final updatedStartDate = result[0];
                                final updatedEndDate = result[1];

                                if (updatedStartDate != null && updatedEndDate != null) {
                                  setState(() {
                                    // Update the selected range
                                    range["start"] = updatedStartDate;
                                    range["end"] = updatedEndDate;
                                  });
                                }
                              }
                            },
                            child: _listRangeAvailabilities(
                              yearsFrenchFormatDateVar(startDate!),
                              yearsFrenchFormatDateVar(endDate!),
                            ),
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 30,),
                      Align(
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
                              onPressed: timeSlots.any((slot) => slot["start"] != null && slot["end"] != null) && selectedRanges.isNotEmpty
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
                    ],
                  ),
                ),
              );
            }
        ),
      ),
    );
  }

  Widget _listRangeAvailabilities(String startDate, String endDate) {
    return Column(
      children: [
        const SizedBox(height: 19),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 31),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Du $startDate au $endDate',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400, color: const Color(0xFF797979)),
              ),
              Icon(Icons.chevron_right, size: 27, color: Color(0xFFBBBBBB)),
            ],
          ),
        ),
        const SizedBox(height: 19),
        Container(
          width: 390,
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
      ],
    );
  }
}

class CreateExpStep5MultiDaysBloc with Disposable {
  String? name;
  String? description;
  Map<String, dynamic> myMap;

  // Create a new map with lists instead of sets
  Map<String, dynamic> modifiedMap = {};

  CreateExpStep5MultiDaysBloc(this.myMap, this.name, this.description);

  Future<void> addTimeDateExpGuide(List<Map<String, TimeOfDay?>> timeSlots, List<Map<String, DateTime>> selectedRanges) async {
    try {
      // Initialize the list of horaires
      List<Map<String, dynamic>> horaires = [];

      for (int i = 0; i < timeSlots.length; i++) {
        // Create a time slot entry
        Map<String, dynamic> timeSlot = {
          "heure_debut": timeSlots[i]["start"] != null ? timeOfDayToString(timeSlots[i]["start"]!) : null,
          "heure_fin": timeSlots[i]["end"] != null ? timeOfDayToString(timeSlots[i]["end"]!) : null,
          "dates": []
        };

        // Add date ranges to the current time slot
        for (var range in selectedRanges) {
          timeSlot["dates"].add({
            "date_debut": DateFormat('yyyy-MM-dd').format(range["start"]!),
            "date_fin": DateFormat('yyyy-MM-dd').format(range["end"]!),
          });
        }

        horaires.add(timeSlot);
      }

      // Merge the new horaires into the existing map
      myMap["horaires"] = horaires;
      modifiedMap = Map<String, dynamic>.from(myMap);

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
    // Dispose of any resources if needed
    super.dispose();
  }
}
