import 'package:flutter/material.dart';
import 'package:meet_pe/screens/travelersPages/profilePages/reservation_detail_page.dart';

import '../../../models/reservation_list_response.dart';
import '../../../resources/resources.dart';
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
                            //child: ReservationCard(reservationResponse: reservation),
                            child: GestureDetector(
                              onTap: () {
                                _showReservationBottomSheet(context, reservation);
                              },
                              child: ReservationCard(reservationResponse: reservation),
                            ),
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

  void _showReservationBottomSheet(
      BuildContext context, ReservationListResponse reservation) {
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            height: 470,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close,
                          size: 20, color: AppResources.colorGray30),
                    ),
                  ],
                ),
                Text(
                  "Expérience réservée le ${yearsFrenchFormat(reservation.createdAt!)}",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppResources.colorDark,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  reservation.experience.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppResources.colorDark,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 15),
                _buildDetailRow(
                    context, "Nombre de voyageurs", '${reservation.nombreDesVoyageurs}'),
                const SizedBox(height: 15),
                _buildDetailRow(
                    context, "Créneau réservé", requestFrenchFormat(reservation.dateTime)),
                const SizedBox(height: 15),
                _buildDetailRow(context, "Durée", _getDurationText(reservation.experience.duree)),
                const SizedBox(height: 15),
                _buildDetailRow(
                  context,
                  "Confirmation guide",
                  reservation.status,
                  valueStyle: null, // Not needed here since we customize the content
                  customWidget: _getStatusRow(reservation.status),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lieu du rendez-vous",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppResources.colorDark,
                        fontSize: 12,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Chez Alex, lieu dit Meetpe",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppResources.colorDark,
                          ),
                        ),
                        Text(
                          reservation.experience.addresse,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppResources.colorDark,
                          ),
                        ),
                        Text(
                          "${reservation.experience.codePostale} ${reservation.experience.ville}",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppResources.colorDark,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Add your map navigation logic here
                          },
                          child: Text(
                            'Voir sur le plan',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppResources.colorDark,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 22),
                Divider(color: AppResources.colorImputStroke),
                SizedBox(height: 26),
                if (reservation.status == 'En attente' || reservation.status == 'Accepté')
                  TextButton(
                    onPressed: () {
                      // Add cancellation logic here
                    },
                    child: Text(
                      'Annuler ma réservation',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppResources.colorDark,
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                SizedBox(height: 41),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(BuildContext context, String title, String value,
      {TextStyle? valueStyle, Widget? customWidget}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppResources.colorDark,
            fontSize: 12,
          ),
        ),
        customWidget ??
            Text(
              value,
              style: valueStyle ??
                  Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppResources.colorDark,
                  ),
            ),
      ],
    );
  }

  String _getDurationText(String? duree) {
    switch (duree) {
      case '1d':
        return "Quelques heures";
      case '2d':
        return "48 heures";
      case '7d':
        return "Semaine";
      default:
        return duree ?? "-";
    }
  }

  Widget _getStatusRow(String? status) {
    if (status == 'Annulée') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.close, size: 17, color: AppResources.colorGray30),
          const SizedBox(width: 5),
          Text(
            status!,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppResources.colorGray30),
          ),
        ],
      );
    } else if (status == 'En attente') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.watch_later_outlined, size: 17, color: AppResources.colorVitamine),
          const SizedBox(width: 5),
          Text(
            'En attente de confirmation',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppResources.colorVitamine),
          ),
        ],
      );
    } else if (status == 'Archivée') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark, size: 17, color: AppResources.colorDark),
          const SizedBox(width: 5),
          Text(
            status!,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppResources.colorDark),
          ),
        ],
      );
    } else {
      // Default case for unknown status
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check, size: 17, color: Color(0xFF33C579)),
          const SizedBox(width: 5),
          Text(
            status!,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Color(0xFF33C579)),
          ),
        ],
      );
    }
  }
}
