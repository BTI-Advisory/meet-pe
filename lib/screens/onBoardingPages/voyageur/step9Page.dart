import 'package:flutter/material.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../services/app_service.dart';
import '../../../utils/_utils.dart';
import 'loadingPage.dart';

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
                'Tu viens quand ?',
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
                  calendarFormat: _calendarFormat,
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
                          backgroundColor: MaterialStateProperty.all(
                              AppResources.colorVitamine),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(ResponsiveSize.calculateCornerRadius(40, context)),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (_selectedDay != null) {
                            // Adding selected date to myMap
                            String key = 'date'; // You can use a meaningful key
                            Set<String> selectedDatesSet = { _selectedDay.toString() };

                            setState(() {
                              // Add the selected date to myMap
                              widget.myMap[key] = selectedDatesSet;
                            });

                            // Convert sets to lists
                            widget.myMap.forEach((key, value) {
                              widget.modifiedMap[key] = value.toList();
                            });
                            // Verify that the date is added to myMap
                            print('Updated modifiedMap: ${widget.modifiedMap}');
                            //navigateTo(context, (_) => LoadingPage());
                            bool isSend = await AppService.api
                                .sendListVoyageur(widget.modifiedMap);
                            if (isSend) {
                              navigateTo(context, (_) => LoadingPage());
                            }
                          } else {
                            // Handle case when no date is selected
                            // You might want to show a message or take another action here
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
