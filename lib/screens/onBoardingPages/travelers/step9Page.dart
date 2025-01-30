import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../services/app_service.dart';
import '../../../utils/_utils.dart';
import 'loadingPage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Step9Page extends StatefulWidget {
  Step9Page({super.key, required this.myMap});

  Map<String, Set<Object>> myMap = {};
  // Create a new map with lists instead of sets
  Map<String, dynamic> modifiedMap = {};

  @override
  State<Step9Page> createState() => _Step9PageState();
}

class _Step9PageState extends State<Step9Page> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  bool isRangeSelected = false;

  final BoxDecoration tableCalendarDecoration = BoxDecoration(
    color: Colors.white,
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: Colors.black,
      width: 2.0,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppResources.colorGray5, AppResources.colorWhite],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: ResponsiveSize.calculateHeight(158, context)),
              Text(
                AppLocalizations.of(context)!.traveler_step_9_title_text,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: AppResources.colorGray100),
              ),
              SizedBox(height: ResponsiveSize.calculateHeight(57, context)),
              Container(
                width: ResponsiveSize.calculateWidth(319, context),
                //height: ResponsiveSize.calculateHeight(411, context),
                height: 360,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveSize.calculateCornerRadius(12, context)),
                  ),
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
                    headerPadding: EdgeInsets.only(bottom: ResponsiveSize.calculateHeight(16, context)),
                    headerMargin: EdgeInsets.zero,
                  ),
                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  focusedDay: _focusedDay,
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  calendarFormat: _calendarFormat,
                  rangeSelectionMode: _rangeSelectionMode,
                  selectedDayPredicate: (day) {
                    // Use `selectedDayPredicate` to determine which day is currently selected.
                    // If this returns true, then `day` will be marked as selected.

                    // Using `isSameDay` is recommended to disregard
                    // the time-part of compared DateTime objects.
                    return isSameDay(_selectedDay, day);
                  },
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
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: ResponsiveSize.calculateHeight(44, context)),
                    child: Container(
                      width: ResponsiveSize.calculateWidth(235, context),
                      height: ResponsiveSize.calculateHeight(44, context),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(
                                  horizontal: ResponsiveSize.calculateWidth(24, context), vertical: ResponsiveSize.calculateHeight(10, context))),
                          backgroundColor:
                          MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states
                                  .contains(MaterialState.disabled)) {
                                return AppResources
                                    .colorGray15; // Change to your desired grey color
                              }
                              return AppResources
                                  .colorVitamine; // Your enabled color
                            },
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(ResponsiveSize.calculateCornerRadius(40, context)),
                            ),
                          ),
                        ),
                        onPressed: (_rangeStart == null || _rangeEnd == null)
                            ? null
                            : () async {
                          if (_rangeStart!.isBefore(DateTime.now())) {
                            showMessage(context, AppLocalizations.of(context)!.error_date_select_text);
                          } else {
                            if (_rangeStart != null) {
                              widget.myMap['date_arrivee'] ??= Set<String>(); // Initialize if null
                              widget.myMap['date_arrivee']!.add(DateFormat('yyyy-MM-dd').format(_rangeStart!));
                            }
                            if (_rangeEnd != null) {
                              widget.myMap['date_depart'] ??= Set<String>(); // Initialize if null
                              widget.myMap['date_depart']!.add(DateFormat('yyyy-MM-dd').format(_rangeEnd!));
                            }
                          }
                          // Convert sets/lists to comma-separated strings
                          widget.myMap.forEach((key, value) {
                            if (value is Iterable) {
                              widget.modifiedMap[key] = value.join(', '); // Join values with comma
                            } else {
                              widget.modifiedMap[key] = value.toString(); // Convert single values to string
                            }
                          });
                          // Verify that the date is added to myMap
                          print('Updated modifiedMap: ${widget.modifiedMap}');
                          bool isSend = await AppService.api.sendListVoyageur(widget.modifiedMap);
                          if (isSend) {
                            navigateTo(context, (_) => LoadingPage());
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(AppLocalizations.of(context)!.error_text),
                                content: Text(AppLocalizations.of(context)!.error_server_text),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text(AppLocalizations.of(context)!.ok_text),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: Text(
                          'VOIR LES EXPERIENCES',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: AppResources.colorWhite),
                        ),
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
