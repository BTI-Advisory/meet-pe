import 'package:flutter/material.dart';
import 'package:meet_pe/screens/travelersPages/reservation_page.dart';

import '../models/experience_model.dart';
import '../resources/resources.dart';
import '../utils/_utils.dart';

class EventDetails extends StatelessWidget {
  final List<Event> events;
  final Experience experienceData;

  const EventDetails({Key? key, required this.events, required this.experienceData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 23),
          Padding(
            padding: const EdgeInsets.only(left: 21),
            child: Text(
              'Choisir un horaire',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: AppResources.colorDark, fontSize: 20),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 31),
              child: Row(
                children: events.map((event) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 13),
                    child: EventTimeSlot(
                      date: event.date,
                      time: event.time,
                      duration: experienceData.duree!,
                      onPressed: () {
                        // Handle reservation
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                              builder: (_) => ReservationPage(experienceData: experienceData, date: event.date, time: event.time,)),
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EventTimeSlot extends StatelessWidget {
  final String date;
  final String time;
  final String duration;
  final VoidCallback onPressed;

  const EventTimeSlot({
    Key? key,
    required this.date,
    required this.time,
    required this.duration,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 148,
      height: 178,
      decoration: BoxDecoration(
        border: Border.all(color: AppResources.colorImputStroke),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            formatDateFrench(date),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppResources.colorDark),
          ),
          const SizedBox(height: 10),
          if (duration == '1d')
            Text(
              formatTimeRange(time),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorDark, fontWeight: FontWeight.w400),
            )
          else if (duration == '2d')
            Text(
              '48 heures',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorDark, fontWeight: FontWeight.w400),
            )
          else if (duration == '7d')
              Text(
                'Une semaine',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorDark, fontWeight: FontWeight.w400),
              ),
          const SizedBox(height: 5),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppResources.colorVitamine,
            ),
            child: Text(
              'Réserver',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorWhite, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}

class Event {
  final String date;
  final String time;

  Event(this.date, this.time);
}