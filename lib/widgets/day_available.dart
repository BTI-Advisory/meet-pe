import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:meet_pe/services/app_service.dart';

import '../models/availability_list_response.dart';
import '../resources/resources.dart';
import '../utils/_utils.dart';

class DayAvailable extends StatefulWidget {
  const DayAvailable({super.key, required this.availabilityList});
  final AvailabilityListResponse availabilityList;

  @override
  State<DayAvailable> createState() => _DayAvailableState();
}

class _DayAvailableState extends State<DayAvailable> {
  bool isAvailableHour = false;
  String hourAvailableStart = '';
  String hourAvailableEnd = '';
  String hourSecondAvailableStart = '';
  String hourSecondAvailableEnd = '';

  String timeResult(List<ScheduleTime> times) {
    if(times.isNotEmpty) {
      if(times.length == 1) {
        return '${times[0].from.substring(0, 5)}-${times[0].to.substring(0, 5)}';
      } else {
        return '${times[0].from.substring(0, 5)}-${times[0].to.substring(0, 5)}  /  ${times[1].from.substring(0, 5)}-${times[1].to.substring(0, 5)}';
      }
    } else {
      return 'Non disponible';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 31),
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context,
                        StateSetter setState) {
                      return Container(
                        width: double.infinity,
                        height: 452,
                        color: AppResources.colorWhite,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 39),
                              Text(
                                'Horaires',
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Disponible de 9:00 à 18:00',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff797979)),
                                  ),
                                  StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return Switch.adaptive(
                                        value: isAvailableHour,
                                        activeColor: AppResources.colorVitamine,
                                        onChanged: (bool value) {
                                          setState(() {
                                            isAvailableHour = value;
                                          });
                                        },
                                      );
                                    },
                                  )
                                ],
                              ),
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
                                        DatePicker.showTimePicker(context,
                                            showTitleActions: true,
                                            showSecondsColumn: false,
                                            onChanged: (date) {
                                              print('change $date');
                                            }, onConfirm: (date) {
                                              print('confirm $date');
                                              setState(() {
                                                hourAvailableStart = '${date.hour}:${date.minute}';
                                              });
                                            }, locale: LocaleType.fr);
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                hourAvailableStart != '' ? hourAvailableStart : '00:00',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.copyWith(
                                                    color: hourAvailableStart != '' ? AppResources.colorDark : Color(0x3F1D1D1D)),
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
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                hourAvailableEnd != '' ? hourAvailableEnd : '23:59',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.copyWith(
                                                    color: hourAvailableEnd != '' ? AppResources.colorDark : Color(0x3F1D1D1D)),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        DatePicker.showTimePicker(context,
                                            showTitleActions: true,
                                            showSecondsColumn: false,
                                            onChanged: (date) {
                                              print('change $date');
                                            }, onConfirm: (date) {
                                              print('confirm $date');
                                              setState(() {
                                                hourAvailableEnd = '${date.hour}:${date.minute}';
                                              });
                                            }, locale: LocaleType.fr);
                                      },
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 39),
                              ///Select Second Hour
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
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                hourSecondAvailableStart != '' ? hourSecondAvailableStart : '00:00',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.copyWith(
                                                    color: hourSecondAvailableStart != '' ? AppResources.colorDark : Color(0x3F1D1D1D)),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        DatePicker.showTimePicker(context,
                                            showTitleActions: true,
                                            showSecondsColumn: false,
                                            onChanged: (date) {
                                              print('change $date');
                                            }, onConfirm: (date) {
                                              print('confirm $date');
                                              setState(() {
                                                hourSecondAvailableStart = '${date.hour}:${date.minute}';
                                              });
                                            }, locale: LocaleType.fr);
                                      },
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
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                hourSecondAvailableEnd != '' ? hourSecondAvailableEnd : '23:59',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.copyWith(
                                                    color: hourSecondAvailableEnd != '' ? AppResources.colorDark : Color(0x3F1D1D1D)),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        DatePicker.showTimePicker(context,
                                            showTitleActions: true,
                                            showSecondsColumn: false,
                                            onChanged: (date) {
                                              print('change $date');
                                            }, onConfirm: (date) {
                                              print('confirm $date');
                                              setState(() {
                                                hourSecondAvailableEnd = '${date.hour}:${date.minute}';
                                              });
                                            }, locale: LocaleType.fr);
                                      },
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 47),
                              Container(
                                width: ResponsiveSize.calculateWidth(319, context),
                                height: ResponsiveSize.calculateHeight(44, context),
                                child: TextButton(
                                  style: ButtonStyle(
                                    padding:
                                    MaterialStateProperty.all<EdgeInsets>(
                                        EdgeInsets.symmetric(
                                            horizontal: ResponsiveSize.calculateWidth(24, context), vertical: ResponsiveSize.calculateHeight(12, context))),
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        side: BorderSide(width: 1, color: AppResources.colorDark),
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
                                  onPressed: () async {
                                    // Create a TimeSlot object
                                    print('EHFEe 11 $hourAvailableStart');
                                    print('EHFEe 22 $hourAvailableEnd');
                                    print('EHFEe 33 $hourSecondAvailableStart');
                                    print('EHFEe 44 $hourSecondAvailableEnd');

                                    if(hourSecondAvailableStart != '' && hourSecondAvailableEnd != '') {
                                      TimeSlot timeSlot1 = TimeSlot(from: hourAvailableStart, to: hourAvailableEnd);
                                      TimeSlot timeSlot2 = TimeSlot(from: hourSecondAvailableStart, to: hourSecondAvailableEnd);
                                      // Create a list of TimeSlot objects
                                      List<TimeSlot> times = [timeSlot1, timeSlot2];
                                      // Create an Availability object
                                      Availability availability = Availability(
                                        day: widget.availabilityList.day,
                                        isAvailableFullDay: isAvailableHour,
                                        times: times,
                                      );

                                      // Convert the Availability object to JSON
                                      Map<String, dynamic> json = {'availabilities': [availability.toJson()]};

                                      await AppService.api.sendScheduleAvailability(json);
                                    } else {
                                      TimeSlot timeSlot = TimeSlot(from: hourAvailableStart, to: hourAvailableEnd);

                                      // Create a list of TimeSlot objects
                                      List<TimeSlot> times = [timeSlot];

                                      // Create an Availability object
                                      Availability availability = Availability(
                                        day: widget.availabilityList.day,
                                        isAvailableFullDay: isAvailableHour,
                                        times: times,
                                      );

                                      // Convert the Availability object to JSON
                                      Map<String, dynamic> json = {'availabilities': [availability.toJson()]};

                                      await AppService.api.sendScheduleAvailability(json);
                                    }

                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.availabilityList.day,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF797979)),
                ),
                Row(
                  children: [
                    Text(
                      widget.availabilityList.isAvailableFullTime == true
                          ? '9:00-18:00'
                          : timeResult(widget.availabilityList.scheduleTimes),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppResources.colorDark,
                      ),
                    )
                    ,
                    Image.asset('images/chevron_right.png',
                        width: 27, height: 27, fit: BoxFit.fill),
                  ],
                ),
              ],
            ),
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
        )
      ],
    );
  }
}