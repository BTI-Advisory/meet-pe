import 'package:flutter/material.dart';
import 'package:meet_pe/screens/travelersPages/profilePages/reservation_detail_page.dart';

import '../../../models/archived_reservation_response.dart';
import '../../../models/guide_experiences_response.dart';
import '../../../models/reservation_data_response.dart';
import '../../../services/app_service.dart';
import '../../../utils/_utils.dart';
import '../../../widgets/_widgets.dart';

class MyReservationsPage extends StatefulWidget {
  const MyReservationsPage({super.key});

  @override
  State<MyReservationsPage> createState() => _MyReservationsPageState();
}

class _MyReservationsPageState extends State<MyReservationsPage> {
  late Future<List<ArchivedReservationResponse>> _reservationFuture;
  late ReservationDataResponse reservationResponse;

  @override
  void initState() {
    super.initState();
    _reservationFuture = AppService.api.getArchivedReservation();
    reservationResponse = ReservationDataResponse(id: 12, title: 'Le Paris de Maria en deux lignes', description: 'Lorem ipsum dolor sit amet, consectetur adipe iscijd elit, sed do eiusmod tempor incididunt ut labore etsi dolore magna aliqua. Ut enim adipsd minim estedgj veniam, quis nostrud exercitation esteil ullamco astr labor commodou consequat.', duration: '3', aboutGuide: "Le Lorem Ipsum est simplement du faux texte employé dans la composition et la mise en page avant impression. Le Lorem Ipsum est le faux texte standard de l'imprimerie depuis les années 1500, quand un imprimeur anonyme assembla ensemble des morceaux de texte pour réaliser un livre spécimen de polices de texte. Il n'a pas fait que survivre cinq siècles, mais s'est aussi adapté à la bureautique informatique, sans que son contenu n'en soit modifié. Il a été popularisé dans les années 1960 grâce à la vente de feuilles Letraset contenant des passages du Lorem Ipsum, et, plus récemment, par son inclusion dans des applications de mise en page de texte, comme Aldus PageMaker.", pricePerTraveler: '120', numberOfTravelers: 4, city: '', address: '', postalCode: '', createdAt: '', updatedAt: '', status: 'Accepté', userId: 12, country: '', categories: ['Aventurier'], guideParticipants: [''], etAvecCa: [''], isOnline: true, isProfessionalGuide: true, guideDescription: "Lorem ipsum dolor sit amet, consectetur adipe iscijd elit, sed do eiusmod tempor incididunt ut labore etsi dolore magna aliqua. Ut enim adipsd minim estedgj veniam, quis nostrud exercitation esteil ullamco astr labor commodou consequat.", guideName: 'Maria', mainPhoto: 'https:\/\/www.meetpe.fr\/\/user_profile\/669fc7d02049aimage_picker_D2F0CDF9-2732-4B83-B4A7-7F4C7E97C230-77723-000001233A7AAB01.jpg', image0: 'https:\/\/www.meetpe.fr\/\/user_profile\/669fc7d02049aimage_picker_D2F0CDF9-2732-4B83-B4A7-7F4C7E97C230-77723-000001233A7AAB01.jpg');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EpAppBar(
        title: 'Mes réservations',
      ),
      body: FutureBuilder<List<ArchivedReservationResponse>>(
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
                        children: List.generate(
                          1,
                              (index) => GestureDetector(
                            onTap: () {
                              navigateTo(context, (_) => ReservationDetailPage(reservationResponse: reservationResponse));
                            },
                            child: ReservationCard(reservationResponse: reservationResponse,),
                          ),
                        ),
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
