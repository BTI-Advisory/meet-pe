import 'package:flutter/material.dart';
import 'package:meet_pe/screens/travelersPages/profilePages/reservation_detail_page.dart';

import '../../../models/reservation_list_response.dart';
import '../../../services/app_service.dart';
import '../../../utils/_utils.dart';
import '../../../widgets/_widgets.dart';

class MyReservationsPage extends StatefulWidget {
  const MyReservationsPage({super.key});

  @override
  State<MyReservationsPage> createState() => _MyReservationsPageState();
}

class _MyReservationsPageState extends State<MyReservationsPage> {
  late Future<List<ReservationListResponse>> _reservationFuture;

  @override
  void initState() {
    super.initState();
    _reservationFuture = AppService.api.getReservation();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EpAppBar(
        title: 'Mes réservations',
      ),
      body: FutureBuilder<List<ReservationListResponse>>(
          future: _reservationFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final reservationList = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.calculateWidth(13, context)),
                      child: Column(
                        children: reservationList.map((reservation) {
                          return GestureDetector(
                            onTap: () {
                              //navigateTo(context, (_) => ReservationDetailPage(reservationResponse: reservation),);
                            },
                            child: ReservationCard(reservationResponse: reservation),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
              );
            }
          }
      ),
    );
  }
}
