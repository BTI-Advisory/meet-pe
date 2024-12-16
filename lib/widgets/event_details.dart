import 'package:flutter/material.dart';
import 'package:meet_pe/screens/travelersPages/reservation_page.dart';

import '../resources/resources.dart';
import '../utils/_utils.dart';

class EventDetails extends StatelessWidget {
  final List<Event> events;

  const EventDetails({Key? key, required this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      onPressed: () {
                        // Handle reservation
                        print('FJRJFJRF');
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                              builder: (_) => const ReservationPage()),
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21.0),
            child: Text(
              'Le rendez-vous a lieu au coeur du 7eme arrondissement à proximité du métro Champs de Mars - Tour Eiffel. Le lieu exact sera communiqué après la réservation.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppResources.colorGray45, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class EventTimeSlot extends StatelessWidget {
  final String date;
  final String time;
  final VoidCallback onPressed;

  const EventTimeSlot({
    Key? key,
    required this.date,
    required this.time,
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
          Text(
            formatTimeRange(time),
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