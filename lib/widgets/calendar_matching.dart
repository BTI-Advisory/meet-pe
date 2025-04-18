import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meet_pe/utils/_utils.dart';
import 'package:meet_pe/widgets/_widgets.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../providers/filter_provider.dart';
import '../resources/resources.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalendarMatching extends StatefulWidget {
  const CalendarMatching({super.key});

  @override
  State<CalendarMatching> createState() => _CalendarMatchingState();
}

class _CalendarMatchingState extends State<CalendarMatching>
    with BlocProvider<CalendarMatching, CalendarMatchingBloc> {
  @override
  initBloc() => CalendarMatchingBloc();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
  DateTime _focusedDay = DateTime.now();
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);
    _rangeStart = filterProvider.startDate != null
        ? DateTime.tryParse(filterProvider.startDate!)
        : null;
    _rangeEnd = filterProvider.endDate != null
        ? DateTime.tryParse(filterProvider.endDate!)
        : null;
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  void _onDateAdded() {
    if (_rangeStart != null && _rangeEnd != null) {
      final result = {
        'rangeStart': formatDate(_rangeStart!),
        'rangeEnd': formatDate(_rangeEnd!),
      };
      Navigator.pop(context, result);
    } else {
      showMessage(context, AppLocalizations.of(context)!.select_valid_range_text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: AsyncForm(
          onValidated: bloc.sendSchedule,
          onSuccess: () async {
            _onDateAdded();
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
                          AppLocalizations.of(context)!.calendar_text,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontSize: 32, color: AppResources.colorDark),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width,
                          color: AppResources.colorGray15,
                        ),
                        const SizedBox(height: 40),
                        Text(
                          AppLocalizations.of(context)!.choice_date_text,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(color: AppResources.colorDark),
                        ),
                        const SizedBox(height: 42),
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
                            locale: 'fr_FR',
                            firstDay: kFirstDay,
                            lastDay: kLastDay,
                            focusedDay: _focusedDay,
                            rangeStartDay: _rangeStart,
                            rangeEndDay: _rangeEnd,
                            calendarFormat: _calendarFormat,
                            rangeSelectionMode: _rangeSelectionMode,
                            onRangeSelected: (start, end, focusedDay) {
                              setState(() {
                                _focusedDay = focusedDay;
                                _rangeStart = start;
                                _rangeEnd = end;
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
                        const SizedBox(height: 40),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width,
                          color: AppResources.colorGray15,
                        ),
                        const SizedBox(height: 40),
                        Row(
                          children: [
                            Container(
                              width: ResponsiveSize.calculateWidth(145, context),
                              height: 44,
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(Colors.transparent),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      side: const BorderSide(
                                        width: 1,
                                        color: AppResources.colorVitamine,
                                      ),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  final filterProvider = Provider.of<FilterProvider>(context, listen: false);
                                  filterProvider.updateDateRange(null, null);

                                  final result = {
                                    'rangeStart': '',
                                    'rangeEnd': '',
                                  };

                                  Navigator.pop(context, result);
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.delete_up_text,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                      color: AppResources.colorVitamine),
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
                                  MaterialStateProperty.all(AppResources.colorVitamine),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      side: const BorderSide(
                                        width: 1,
                                        color: Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  if (_rangeStart != null && _rangeStart!.isBefore(DateTime.now())) {
                                    showMessage(context, AppLocalizations.of(context)!.error_date_select_text);
                                  } else {
                                    if (_rangeStart != null) {
                                      bloc.dayFrom = DateFormat('yyyy-MM-dd').format(_rangeStart!);
                                    }
                                    if (_rangeEnd != null) {
                                      bloc.dayTo = DateFormat('yyyy-MM-dd').format(_rangeEnd!);
                                    }
                                    _onDateAdded(); // Pass the result back to the parent
                                  }
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.enregister_text,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                      color: AppResources.colorWhite),
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

class CalendarMatchingBloc with Disposable {
  String dayFrom = '';
  String dayTo = '';

  Future<bool> sendSchedule() async {

    SearchByDate absence = SearchByDate(dayFrom: dayFrom, dayTo: dayTo);

    if(dayTo == '') {
      // Create an Absence object
      absence = SearchByDate(
        dayFrom: '',
        dayTo: '',
      );
    } else {
      // Create an Absence object
      absence = SearchByDate(
        dayFrom: dayFrom,
        dayTo: dayTo,
      );
    }

    // Convert the Availability object to JSON
    Map<String, dynamic> json = absence.toJson();
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
