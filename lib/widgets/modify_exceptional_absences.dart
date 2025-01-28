import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meet_pe/utils/_utils.dart';
import 'package:meet_pe/widgets/_widgets.dart';
import 'package:table_calendar/table_calendar.dart';

import '../resources/resources.dart';
import '../services/app_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ModifyExceptionalAbsences extends StatefulWidget {
  ModifyExceptionalAbsences({super.key, required this.id, required this.firstFormatDate, required this.lastFormatDate, required this.onAbsenceModified});
  int id;
  String firstFormatDate;
  String lastFormatDate;
  final VoidCallback onAbsenceModified;

  @override
  State<ModifyExceptionalAbsences> createState() => _ModifyExceptionalAbsencesState();
}

class _ModifyExceptionalAbsencesState extends State<ModifyExceptionalAbsences>
    with BlocProvider<ModifyExceptionalAbsences, ExceptionalAbsencesBloc> {
  @override
  initBloc() => ExceptionalAbsencesBloc();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  int id = 0;

  bool isRangeSelected = false;

  void showCustomDialog(BuildContext context, String info) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning Icon
                const Icon(
                  Icons.warning_amber,
                  size: 40,
                  color: Colors.black,
                ),
                const SizedBox(height: 8),
                // Warning Message
                Text(
                  info,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                      color: AppResources.colorDark),
                ),
                const SizedBox(height: 19),
                // Button to modify
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppResources.colorVitamine,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.modify_time_text,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                        color: AppResources.colorWhite),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _rangeStart  = DateTime.parse(widget.firstFormatDate);
    _rangeEnd  = DateTime.parse(widget.lastFormatDate);
    id = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: AsyncForm(
          onValidated: () async {
            try {
              String isCreated = await bloc.updateScheduleAbsence();
              if (isCreated == "Une absence avec ces dates existe déjà.") {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showCustomDialog(context, AppLocalizations.of(context)!.exist_absence_text); // Ensure this runs after the widget tree is built
                });
              } else if (isCreated == "Vous avez au moins une expérience déjà bookée ce jour.") {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showCustomDialog(context, AppLocalizations.of(context)!.resa_absence_text); // Ensure this runs after the widget tree is built
                });
              } else {
                widget.onAbsenceModified();
                Navigator.pop(context);
              }
            } catch (e) {
              print("Error: $e");
            }
          },
          onSuccess: () async {
            //_onAbsenceAdded();
          },
          builder: (context, validate) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context)!.exceptional_absences_text,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '${AppLocalizations.of(context)!.absence_from_text} ${AppResources.formatterDate.format(DateTime.parse(widget.firstFormatDate))} ${AppLocalizations.of(context)!.to_text} ${AppResources.formatterDate.format(DateTime.parse(widget.lastFormatDate))}.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                              fontSize: 12, color: const Color(0xFF979797)),
                        ),
                        const SizedBox(height: 31),
                        Container(
                          width: ResponsiveSize.calculateWidth(319, context),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  ResponsiveSize.calculateCornerRadius(
                                      12, context)),
                            ),
                            shadows: const [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 4,
                                offset: Offset(0, 4),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: TableCalendar(
                            headerStyle: HeaderStyle(
                              titleTextStyle: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                  color: AppResources.colorDark,
                                  fontWeight: FontWeight.w700),
                              formatButtonShowsNext: false,
                              formatButtonVisible: false,
                              titleCentered: true,
                              headerPadding: EdgeInsets.only(
                                  bottom: ResponsiveSize.calculateHeight(
                                      16, context)),
                              headerMargin: EdgeInsets.zero,
                            ),
                            firstDay: kFirstDay,
                            lastDay: kLastDay,
                            focusedDay: _focusedDay,
                            rangeStartDay: _rangeStart,
                            rangeEndDay: _rangeEnd,
                            calendarFormat: _calendarFormat,
                            rangeSelectionMode: _rangeSelectionMode,
                            selectedDayPredicate: (day) =>
                                isSameDay(_selectedDay, day),
                            onDaySelected: (selectedDay, focusedDay) {
                              if (!isSameDay(_selectedDay, selectedDay)) {
                                // Call `setState()` when updating the selected day
                                setState(() {
                                  _selectedDay = selectedDay;
                                  _focusedDay = focusedDay;
                                  _rangeStart = null;
                                  _rangeEnd = null;
                                  _rangeSelectionMode =
                                      RangeSelectionMode.toggledOff;
                                  isRangeSelected = false;
                                });
                              }
                            },
                            onRangeSelected: (start, end, focusedDay) {
                              setState(() {
                                _selectedDay = null;
                                _focusedDay = focusedDay;
                                _rangeStart = start;
                                _rangeEnd = end;
                                isRangeSelected = true;
                              });
                            },
                            onPageChanged: (focusedDay) {
                              // No need to call `setState()` here
                              _focusedDay = focusedDay;
                            },
                            calendarStyle: CalendarStyle(
                              selectedDecoration: BoxDecoration(
                                color: AppResources.colorVitamine,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppResources.colorVitamine,
                                  width: 1.0,
                                ),
                              ),
                              rangeStartDecoration: BoxDecoration(
                                color: AppResources.colorWhite,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppResources.colorVitamine,
                                  width: 1.0,
                                ),
                              ),
                              rangeStartTextStyle: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                  fontSize: 14,
                                  color: AppResources.colorVitamine),
                              rangeEndDecoration: BoxDecoration(
                                color: AppResources.colorWhite,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppResources.colorVitamine,
                                  width: 1.0,
                                ),
                              ),
                              rangeEndTextStyle: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                  fontSize: 14,
                                  color: AppResources.colorVitamine),
                              rangeHighlightColor: AppResources.colorVitamine
                                  .withOpacity(0x44 / 0xFF),
                            ),
                          ),
                        ),
                        const SizedBox(height: 27),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 44,
                              child: TextButton(
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<
                                      EdgeInsets>(
                                      EdgeInsets.symmetric(
                                          horizontal: ResponsiveSize
                                              .calculateWidth(
                                              24, context),
                                          vertical: ResponsiveSize
                                              .calculateHeight(
                                              12, context))),
                                  backgroundColor:
                                  MaterialStateProperty.all(
                                      Colors.transparent),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 1,
                                          color: AppResources.colorDark),
                                      borderRadius:
                                      BorderRadius.circular(40),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  // Show a confirmation dialog to the user
                                  bool confirmDelete = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(AppLocalizations.of(context)!.confirm_delete_text),
                                        content: Text(AppLocalizations.of(context)!.delete_absence_text),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(false); // User canceled deletion
                                            },
                                            child: Text(AppLocalizations.of(context)!.cancel_text),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(true); // User confirmed deletion
                                            },
                                            child: Text(AppLocalizations.of(context)!.delete_up_text),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  // If user confirmed deletion, call deleteScheduleAbsence method
                                  if (confirmDelete == true) {
                                    bloc.id = id;
                                    bool isDeleted = await bloc.deleteScheduleAbsence();
                                    widget.onAbsenceModified();
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.delete_up_text,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                      color: AppResources.colorDark),
                                ),
                              ),
                            ),
                            //const SizedBox(width: 29),
                            Container(
                              height: 44,
                              child: TextButton(
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<
                                      EdgeInsets>(
                                      EdgeInsets.symmetric(
                                          horizontal: ResponsiveSize
                                              .calculateWidth(
                                              24, context),
                                          vertical: ResponsiveSize
                                              .calculateHeight(
                                              12, context))),
                                  backgroundColor:
                                  MaterialStateProperty.all(
                                      Colors.transparent),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 1,
                                          color: AppResources.colorDark),
                                      borderRadius:
                                      BorderRadius.circular(40),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  if (_rangeStart!.isBefore(DateTime.now())) {
                                    showMessage(context, AppLocalizations.of(context)!.error_date_select_text);
                                  } else {
                                    bloc.id = id;
                                    if(_rangeStart != null) {
                                      bloc.dayFrom = DateFormat('yyyy-MM-dd').format(_rangeStart!);
                                    }
                                    if(_rangeEnd != null) {
                                      bloc.dayTo = DateFormat('yyyy-MM-dd').format(_rangeEnd!);
                                    }
                                    validate();
                                  }
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.enregister_text,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                      color: AppResources.colorDark),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 33),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class ExceptionalAbsencesBloc with Disposable {
  int id = 0;
  String dayFrom = '';
  String dayTo = '';

  Future<String> updateScheduleAbsence() async {
    String response = await AppService.api.updateScheduleAbsence(id, dayFrom, dayTo);
    return response;
  }

  Future<bool> deleteScheduleAbsence() async {
    bool isCreated = await AppService.api.deleteScheduleAbsence(id);
    return isCreated;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
