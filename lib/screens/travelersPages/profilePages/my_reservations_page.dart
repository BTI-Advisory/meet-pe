import 'package:flutter/material.dart';

import '../../../models/archived_reservation_response.dart';
import '../../../models/guide_experiences_response.dart';
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
  late GuideExperiencesResponse reservationResponse;

  @override
  void initState() {
    super.initState();
    _reservationFuture = AppService.api.getArchivedReservation();
    reservationResponse = GuideExperiencesResponse(id: 12, title: 'Le Paris de Maria en deux lignes', description: 'description', dure: '2', prixParVoyageur: '122', nombreDesVoyageurs: 4, ville: 'ville', addresse: 'addresse', codePostale: 'codePostale', createdAt: '2024-07-22T08:13:16.000000Z', updatedAt: '2024-07-22T08:13:16.000000Z', userId: 44, status: 'Accepté', country: 'country', categorie: '12', guidePersonnesPeuvesParticiper: '12312', etAvecCa: 'etAvecCa', isOnline: true, photoPrincipal: PhotoPrincipal(id: 12, guideExperienceId: 33, photoUrl: "https:\/\/www.meetpe.fr\/user_profile\/profile.png", typeImage: '', createdAt: '', updatedAt: ''));
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
                            onTap: () {},
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
