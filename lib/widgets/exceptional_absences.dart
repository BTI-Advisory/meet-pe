import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:meet_pe/utils/_utils.dart';
import 'package:table_calendar/table_calendar.dart';

import '../resources/resources.dart';
import '../utils/responsive_size.dart';
import '../utils/utils.dart';

class ExceptionalAbsences extends StatefulWidget {
  const ExceptionalAbsences({
    super.key,
    required this.onCallBack,
    required this.absences, // Include list of absences as a parameter
  });

  final Function(List<Map<String, String>>) onCallBack; // Change the type of the callback function
  final List<Map<String, String>> absences; // Define list of absences

  @override
  State<ExceptionalAbsences> createState() => _ExceptionalAbsencesState();
}

class _ExceptionalAbsencesState extends State<ExceptionalAbsences> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  String hourAvailableStart = '';
  String hourAvailableEnd = '';
  String hourSecondAvailableStart = '';
  String hourSecondAvailableEnd = '';

  bool isRangeSelected = false;

  void addAbsence(String startDate, String endDate, String startHour, String endHour) {
    setState(() {
      Map<String, String> newAbsence = {
        'startDate': startDate,
        'endDate': endDate,
        'startHour': startHour,
        'endHour': endHour,
      };
      widget.absences.add(newAbsence);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 39),
                  Text(
                    'Absences exceptionnelles',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et par defaut toutes nos expériences sont disponibles en français',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 12, color: const Color(0xFF979797)),
                  ),
                  const SizedBox(height: 31),
                  Container(
                    width: ResponsiveSize.calculateWidth(319, context),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            ResponsiveSize.calculateCornerRadius(12, context)),
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
                            bottom:
                                ResponsiveSize.calculateHeight(16, context)),
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
                            _rangeStart = null; // Important to clean those
                            _rangeEnd = null;
                            _rangeSelectionMode = RangeSelectionMode.toggledOff;
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
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          // Call `setState()` when updating calendar format
                          setState(() {
                            _calendarFormat = format;
                          });
                        }
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
                        rangeHighlightColor:
                            AppResources.colorVitamine.withOpacity(0x44 / 0xFF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 31),
                  Text(
                    'Horaires',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 44),
                  ///Select Hour
                  Row(
                    children: [
                      ///Choose start time
                      Container(
                        width: 155.50,
                        height: 52,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: AppResources.colorGray15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            DatePicker.showTimePicker(context,
                                showTitleActions: true,
                                showSecondsColumn: false, onChanged: (date) {
                              print('change $date');
                            }, onConfirm: (date) {
                              print('confirm $date');
                              setState(() {
                                hourAvailableStart =
                                    '${date.hour}:${date.minute}';
                              });
                            }, locale: LocaleType.fr);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'De',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontSize: 12),
                              ),
                              StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return Text(
                                    hourAvailableStart != ''
                                        ? hourAvailableStart
                                        : '00:00',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            color: AppResources.colorDark),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      ///Choose end time
                      Container(
                        width: 155.50,
                        height: 52,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: AppResources.colorGray15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: GestureDetector(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'A',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontSize: 12),
                              ),
                              StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return Text(
                                    hourAvailableEnd != ''
                                        ? hourAvailableEnd
                                        : '23:59',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            color: AppResources.colorDark),
                                  );
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            DatePicker.showTimePicker(context,
                                showTitleActions: true,
                                showSecondsColumn: false, onChanged: (date) {
                              print('change $date');
                            }, onConfirm: (date) {
                              print('confirm $date');
                              setState(() {
                                hourAvailableEnd =
                                    '${date.hour}:${date.minute}';
                              });
                            }, locale: LocaleType.fr);
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 47),
                  isRangeSelected
                      ? Row(
                          children: [
                            Container(
                              width: 145,
                              height: 44,
                              child: TextButton(
                                style: ButtonStyle(
                                  padding: MaterialStateProperty
                                      .all<EdgeInsets>(EdgeInsets.symmetric(
                                          horizontal:
                                              ResponsiveSize.calculateWidth(
                                                  24, context),
                                          vertical:
                                              ResponsiveSize.calculateHeight(
                                                  12, context))),
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 1,
                                          color: AppResources.colorDark),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'SUPPRIMER',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(color: AppResources.colorDark),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            const SizedBox(width: 29),
                            Container(
                              width: 145,
                              height: 44,
                              child: TextButton(
                                style: ButtonStyle(
                                  padding: MaterialStateProperty
                                      .all<EdgeInsets>(EdgeInsets.symmetric(
                                          horizontal:
                                              ResponsiveSize.calculateWidth(
                                                  24, context),
                                          vertical:
                                              ResponsiveSize.calculateHeight(
                                                  12, context))),
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      side: const BorderSide(
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
                                      ?.copyWith(color: AppResources.colorDark),
                                ),
                                onPressed: () {
                                  addAbsence(_rangeStart.toString(), _rangeStart.toString(), hourAvailableStart, hourAvailableEnd);
                                  widget.onCallBack(widget.absences);
                                  Navigator.pop(context);
                                },
                              ),
                            )
                          ],
                        )
                      : Container(
                          width: ResponsiveSize.calculateWidth(319, context),
                          height: ResponsiveSize.calculateHeight(44, context),
                          child: TextButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.symmetric(
                                      horizontal: ResponsiveSize.calculateWidth(
                                          24, context),
                                      vertical: ResponsiveSize.calculateHeight(
                                          12, context))),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1, color: AppResources.colorDark),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                            ),
                            child: Text(
                              'ENREGISTRER',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: AppResources.colorDark),
                            ),
                            onPressed: () {
                              showMessage(context, 'Select date!');
                            },
                          ),
                        ),
                  const SizedBox(height: 73),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
