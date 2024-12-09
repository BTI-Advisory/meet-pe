import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../models/experience_data_response.dart';
import '../../../models/modify_experience_data_model.dart';
import '../../../utils/_utils.dart';
import '../../../widgets/_widgets.dart';
import '../../../resources/resources.dart';

class EditAvailabilitiesPage extends StatefulWidget {
  const EditAvailabilitiesPage({super.key, required this.planning});

  final List<Planning> planning;

  @override
  State<EditAvailabilitiesPage> createState() => _EditAvailabilitiesPageState();
}

class _EditAvailabilitiesPageState extends State<EditAvailabilitiesPage> {
  List<Map<String, TimeOfDay?>> timeSlots = [
    {"start": null, "end": null}
  ];
  List<DateTime> selectedDays = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Combine dates with time slots into a structured planning object
  List<HorairesDataModel> _generateHoraires() {
    List<HorairesDataModel> horaires = [];

    for (var day in selectedDays) {
      horaires.add(HorairesDataModel(
        heureDebut: timeSlots.first["start"]?.format(context),
        heureFin: timeSlots.first["end"]?.format(context),
        dates: [
          DatesDataModel(
            dateDebut: day.toIso8601String().split('T').first, // Format as YYYY-MM-DD
            dateFin: day.toIso8601String().split('T').first,   // Format as YYYY-MM-DD
          ),
        ],
      ));
    }

    return horaires;
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF3F3F3), Colors.white],
              stops: [0.0, 1.0],
            ),
          ),
          child: Stack(
            children: <Widget>[
              // Main content with scroll capability
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 48),
                      SizedBox(
                        width: ResponsiveSize.calculateWidth(24, context),
                        height: ResponsiveSize.calculateHeight(24, context),
                        child: FloatingActionButton(
                          backgroundColor: AppResources.colorWhite,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            String.fromCharCode(CupertinoIcons.back.codePoint),
                            style: TextStyle(
                              inherit: false,
                              color: AppResources.colorVitamine,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w900,
                              fontFamily: CupertinoIcons
                                  .exclamationmark_circle.fontFamily,
                              package: CupertinoIcons
                                  .exclamationmark_circle.fontPackage,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                      Text(
                        'Horaire & dates de l’expérience',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
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
              ),
              // Bottom button
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  // Add some bottom margin for padding
                  child: SizedBox(
                    width: ResponsiveSize.calculateWidth(319, context),
                    height: ResponsiveSize.calculateHeight(44, context),
                    child: TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(
                                horizontal:
                                ResponsiveSize.calculateWidth(24, context),
                                vertical: ResponsiveSize.calculateHeight(
                                    12, context))),
                        backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            side: BorderSide(
                                width: 1, color: AppResources.colorDark),
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                      onPressed: timeSlots.any((slot) => slot["start"] != null && slot["end"] != null) && selectedDays.isNotEmpty
                          ? () {
                        setState(() {
                          print("Selected Days: $selectedDays");
                          print("Time Slots: $timeSlots");
                          List<HorairesDataModel> horaires = _generateHoraires();

                          // Create ModifyExperienceDataModel with horaires data
                          final modifyExperienceDataModel = ModifyExperienceDataModel(
                            horaires: horaires,
                          );

                          // Pass the ModifyExperienceDataModel back to the previous screen
                          Navigator.pop(context, modifyExperienceDataModel);
                        });
                      }
                          : null,
                      child: Text(
                        'ENREGISTRER',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: AppResources.colorDark),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
