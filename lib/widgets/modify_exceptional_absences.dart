import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:meet_pe/utils/_utils.dart';
import 'package:meet_pe/widgets/_widgets.dart';
import 'package:table_calendar/table_calendar.dart';

import '../resources/resources.dart';
import '../services/app_service.dart';

class ModifyExceptionalAbsences extends StatefulWidget {
  ModifyExceptionalAbsences({super.key, required this.id, required this.firstFormatDate, required this.lastFormatDate, required this.startHour, required this.endHour});
  int id;
  String firstFormatDate;
  String lastFormatDate;
  String startHour;
  String endHour;

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

  String hourAvailableStart = '';
  String hourAvailableEnd = '';
  int id = 0;

  bool isRangeSelected = false;

  @override
  void initState() {
    super.initState();
    _rangeStart  = DateTime.parse(widget.firstFormatDate);
    _rangeEnd  = DateTime.parse(widget.lastFormatDate);
    hourAvailableStart = widget.startHour;
    hourAvailableEnd = widget.endHour;
    id = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AsyncForm(
          onValidated: bloc.updateScheduleAbsence,
          onSuccess: () async {
            Navigator.pop(context);
          },
          builder: (context, validate) {
            return SingleChildScrollView(
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
                              rangeHighlightColor: AppResources.colorVitamine
                                  .withOpacity(0x44 / 0xFF),
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
                                      width: 1,
                                      color: AppResources.colorGray15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  print('FJRFJRFJJRFJRJF HELLLLOO $_rangeEnd');
                                  if(DateFormat('yyyy-MM-dd').format(_rangeEnd!) != '') {
                                    DatePicker.showTimePicker(context,
                                        showTitleActions: true,
                                        showSecondsColumn: false,
                                        onChanged: (date) {
                                          print('change $date');
                                        }, onConfirm: (date) {
                                          print('confirm $date');
                                          setState(() {
                                            hourAvailableStart = DateFormat('HH:mm:ss').format(date);
                                          });
                                        }, locale: LocaleType.fr);
                                  }
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
                                              color:
                                              AppResources.colorDark),
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
                                      width: 1,
                                      color: AppResources.colorGray15),
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
                                              color:
                                              AppResources.colorDark),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  if(DateFormat('yyyy-MM-dd').format(_rangeEnd!) != '') {
                                    DatePicker.showTimePicker(context,
                                        showTitleActions: true,
                                        showSecondsColumn: false,
                                        onChanged: (date) {
                                          print('change $date');
                                        }, onConfirm: (date) {
                                          print('confirm $date');
                                          setState(() {
                                            hourAvailableEnd = DateFormat('HH:mm:ss').format(date);
                                          });
                                        }, locale: LocaleType.fr);
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 47),
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
                                    bloc.id = id;
                                    bloc.hourAvailableStart = hourAvailableStart;
                                    bloc.hourAvailableEnd = hourAvailableEnd;
                                    if(_rangeStart != null) {
                                      bloc.dayFrom = DateFormat('yyyy-MM-dd').format(_rangeStart!);
                                    }
                                    if(_rangeEnd != null) {
                                      bloc.dayTo = DateFormat('yyyy-MM-dd').format(_rangeEnd!);
                                    }
                                    validate();
                                  } else {
                                    showMessage(context, 'Error date select');
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
                        const SizedBox(height: 73),
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
  String hourAvailableStart = '00:00:00';
  String hourAvailableEnd = '23:59:59';
  String day = '';
  String dayFrom = '';
  String dayTo = '';

  Future<bool> updateScheduleAbsence() async {
    // Create a TimeSlot object
    TimeSlot timeSlot =
    TimeSlot(from: hourAvailableStart, to: hourAvailableEnd);

    // Create a list of TimeSlot objects
    List<TimeSlot> times = [timeSlot];

    ModifyAbsence absence = ModifyAbsence(id: id, day: '', dayFrom: dayFrom, dayTo: dayTo, times: times);

    if(dayTo == '') {
      // Create an Absence object
      absence = ModifyAbsence(
        id: id,
        day: dayFrom,
        dayFrom: '',
        dayTo: '',
        times: times,
      );
    } else {
      // Create an Absence object
      absence = ModifyAbsence(
        id: id,
        day: '',
        dayFrom: dayFrom,
        dayTo: dayTo,
        times: times,
      );
    }



    // Convert the Availability object to JSON
    Map<String, dynamic> json = absence.toJson();

    bool isCreated = await AppService.api.updateScheduleAbsence(json);
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
