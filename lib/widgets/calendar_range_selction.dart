import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meet_pe/utils/_utils.dart';
import 'package:meet_pe/widgets/_widgets.dart';
import 'package:table_calendar/table_calendar.dart';

import '../resources/resources.dart';

class CalendarRangeSelection extends StatefulWidget {
  const CalendarRangeSelection({super.key, required this.duration});

  final int duration;

  @override
  State<CalendarRangeSelection> createState() => _CalendarRangeSelectionState();
}

class _CalendarRangeSelectionState extends State<CalendarRangeSelection>
    with BlocProvider<CalendarRangeSelection, CalendarRangeSelectionBloc> {
  @override
  initBloc() => CalendarRangeSelectionBloc();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  bool isRangeSelected = false;

  void _onRangeAdded() {
    Navigator.pop(context, [_rangeStart, _rangeEnd]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: AsyncForm(
          onValidated: bloc.sendScheduleAbsence,
          onSuccess: () async {
            _onRangeAdded();
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
                          'Date de l’expérience',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et par defaut toutes nos expériences sont disponibles en français',
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
                            startingDayOfWeek: StartingDayOfWeek.monday,
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
                                // Automatically set range end to two days after range start
                                if (_rangeStart != null) {
                                  _rangeEnd = _rangeStart!.add(Duration(days: widget.duration));
                                } else {
                                  _rangeEnd = null;
                                }
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
                        isRangeSelected
                            ? Row(
                          children: [
                            Container(
                              width: ResponsiveSize.calculateWidth(145, context),
                              height: 44,
                              child: TextButton(
                                style: ButtonStyle(
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
                                  Navigator.pop(context);
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
                            SizedBox(width: ResponsiveSize.calculateWidth(29, context),),
                            Container(
                              width: ResponsiveSize.calculateWidth(145, context),
                              height: 44,
                              child: TextButton(
                                style: ButtonStyle(
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
                        )
                            : Container(
                          width:
                          ResponsiveSize.calculateWidth(319, context),
                          height:
                          ResponsiveSize.calculateHeight(44, context),
                          child: TextButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1,
                                      color: AppResources.colorDark),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                            ),
                            child: Text(
                              'ENREGISTRER',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                  color: AppResources.colorDark),
                            ),
                            onPressed: () {
                              showMessage(context, 'Select date!');
                            },
                          ),
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

class CalendarRangeSelectionBloc with Disposable {
  String day = '';
  String dayFrom = '';
  String dayTo = '';

  Future<bool> sendScheduleAbsence() async {

    /*Absence absence = Absence(day: '', dayFrom: dayFrom, dayTo: dayTo);

    if(dayTo == '') {
      // Create an Absence object
      absence = Absence(
        day: dayFrom,
        dayFrom: '',
        dayTo: '',
      );
    } else {
      // Create an Absence object
      absence = Absence(
        day: '',
        dayFrom: dayFrom,
        dayTo: dayTo,
      );
    }



    // Convert the Availability object to JSON
    Map<String, dynamic> json = absence.toJson();

    bool isCreated = await AppService.api.sendScheduleAbsence(json);
    return isCreated;*/
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
