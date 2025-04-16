import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../models/experience_data_response.dart';
import '../../../models/modify_experience_data_model.dart';
import '../../../utils/_utils.dart';
import '../../../widgets/_widgets.dart';
import '../../../resources/resources.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditAvailabilitiesRangeDatePage extends StatefulWidget {
  const EditAvailabilitiesRangeDatePage({super.key, required this.planning, required this.duration});

  final List<Planning> planning;
  final String duration;

  @override
  State<EditAvailabilitiesRangeDatePage> createState() => _EditAvailabilitiesRangeDatePageState();
}

class _EditAvailabilitiesRangeDatePageState extends State<EditAvailabilitiesRangeDatePage> {
  List<Map<String, TimeOfDay?>> timeSlots = [
    {"start": null, "end": null}
  ];
  // Add a state for selected ranges
  List<Map<String, DateTime>> selectedRanges = [];

  @override
  void initState() {
    super.initState();
    _initializeSelectedRanges();
  }

  void _initializeSelectedRanges() {
    setState(() {
      selectedRanges = widget.planning.map((plan) {
        return {
          "start": DateTime.parse(plan.startDate),
          "end": DateTime.parse(plan.endDate),
        };
      }).toList();

      if (widget.planning.isNotEmpty) {
        // Use the first schedule for the time slots
        final firstSchedule = widget.planning.first.schedules.first;
        timeSlots = [
          {
            "start": TimeOfDay(
              hour: int.parse(firstSchedule.startTime.split(":")[0]),
              minute: int.parse(firstSchedule.startTime.split(":")[1]),
            ),
            "end": TimeOfDay(
              hour: int.parse(firstSchedule.endTime.split(":")[0]),
              minute: int.parse(firstSchedule.endTime.split(":")[1]),
            ),
          }
        ];
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Combine selectedRanges with time slots into a structured planning object
  List<HorairesDataModel> _generateHoraires() {
    List<HorairesDataModel> horaires = [];

    for (var range in selectedRanges) {
      final startDate = range["start"];
      final endDate = range["end"];

      if (startDate != null && endDate != null) {
        horaires.add(HorairesDataModel(
          heureDebut: timeSlots.first["start"]?.format(context) ?? "00:00",
          heureFin: timeSlots.first["end"]?.format(context) ?? "23:59",
          dates: [
            DatesDataModel(
              dateDebut: startDate.toIso8601String().split('T').first,
              dateFin: endDate.toIso8601String().split('T').first,
            ),
          ],
        ));
      }
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
          child: Column(
            children: <Widget>[
              // Expanded area for scrollable content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
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
                            child: Icon(
                              CupertinoIcons.back,
                              color: AppResources.colorVitamine,
                              size: 24.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 80),
                        Text(
                          AppLocalizations.of(context)!.step_5_title_text,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.step_5_desc_text,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: ResponsiveSize.calculateHeight(16, context)),
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
                                      text: AppLocalizations.of(context)!.duration_text,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: AppResources.colorGray60,
                                      ),
                                    ),
                                    TextSpan(
                                      text: widget.duration == "2 jours" ? "48 h" : AppLocalizations.of(context)!.schedule_3_text,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppResources.colorGray60,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: ResponsiveSize.calculateHeight(16, context)),
                        TimeSlotWidget(
                          initialTimeSlots: timeSlots,
                          onTimeSlotsChanged: (updatedTimeSlots) {
                            setState(() {
                              timeSlots = updatedTimeSlots;
                            });
                          },
                          active: false,
                          validateTimes: false,
                        ),
                        SizedBox(height: ResponsiveSize.calculateHeight(16, context)),
                        InkWell(
                          onTap: () async {
                            final result = await showModalBottomSheet<List<DateTime?>>(
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return CalendarRangeSelection(
                                  duration: widget.duration == "2 jours" ? 2 : 7,
                                );
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
                            AppLocalizations.of(context)!.add_dates_text,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppResources.colorVitamine,
                            ),
                          ),
                        ),
                        ...selectedRanges.asMap().entries.map((entry) {
                          final rangeIndex = entry.key;
                          final range = entry.value;

                          final startDate = range["start"];
                          final endDate = range["end"];

                          // Generate a unique key based on the start and end dates
                          final uniqueKey = '${startDate?.toIso8601String()}_${endDate?.toIso8601String()}';

                          return Dismissible(
                            key: ValueKey(uniqueKey), // Use a unique key instead of index
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (direction) {
                              setState(() {
                                selectedRanges.removeAt(rangeIndex);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(AppLocalizations.of(context)!.date_removed_text)),
                              );
                            },
                            child: GestureDetector(
                              onTap: () async {
                                final result = await showModalBottomSheet<List<DateTime?>>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return CalendarRangeSelection(
                                      duration: widget.duration == "2 jours" ? 2 : 7,
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
                      ],
                    ),
                  ),
                ),
              ),
              // Fixed bottom button
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
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
                    onPressed: timeSlots.any((slot) => slot["start"] != null && slot["end"] != null) && selectedRanges.isNotEmpty
                        ? () {
                      List<HorairesDataModel> horaires = _generateHoraires();
                      final modifyExperienceDataModel = ModifyExperienceDataModel(
                        horaires: horaires,
                      );
                      Navigator.pop(context, modifyExperienceDataModel);
                    }
                        : null,
                    child: Text(
                      AppLocalizations.of(context)!.enregister_text,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppResources.colorDark),
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
                '${AppLocalizations.of(context)!.from_text} $startDate ${AppLocalizations.of(context)!.to_text} $endDate',
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
