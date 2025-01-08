import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:meet_pe/utils/_utils.dart';
import 'package:meet_pe/widgets/_widgets.dart';
import 'package:table_calendar/table_calendar.dart';

import '../resources/resources.dart';
import '../services/app_service.dart';

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
          onValidated: bloc.updateScheduleAbsence,
          onSuccess: () async {
            widget.onAbsenceModified();
            Navigator.pop(context);
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
                          'Absences exceptionnelles',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'Absence exceptionnelle du ${AppResources.formatterDate.format(DateTime.parse(widget.firstFormatDate))} au ${AppResources.formatterDate.format(DateTime.parse(widget.lastFormatDate))}.',
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
                          children: [
                            Container(
                              width: 145,
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
                                        title: Text("Confirmer la suppression"),
                                        content: Text("Etes-vous sûr de vouloir supprimer cette absence exceptionnelle?"),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(false); // User canceled deletion
                                            },
                                            child: Text("ANNULER"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(true); // User confirmed deletion
                                            },
                                            child: Text("SUPPRIMER"),
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
                                  'SUPPRIMER',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                      color: AppResources.colorDark),
                                ),
                              ),
                            ),
                            const SizedBox(width: 29),
                            Container(
                              width: 145,
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
                                    showMessage(context, 'Error date select');
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
                                  'ENREGISTRER',
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

  Future<bool> updateScheduleAbsence() async {
    bool isCreated = await AppService.api.updateScheduleAbsence(id, dayFrom, dayTo);
    return isCreated;
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
