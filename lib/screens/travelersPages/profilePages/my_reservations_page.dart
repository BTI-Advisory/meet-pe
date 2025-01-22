import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
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
  bool isFormValid = false;
  List<String> _categories = ['Je ne suis plus disponible sur ce créneaux', 'Le guide n’a pas confirmé la réservation', 'J’aimerai ajouter/supprimer des voyageurs', 'J’ai trouvé une meilleure expérience', 'Autre'];

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
                          "Chez ${reservation.experience.user.name}, lieu dit Meetpe",
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
                            final latitude = double.parse(reservation.experience.lat);
                            final longitude = double.parse(reservation.experience.lang);
                            int zoom = 18;

                            MapsSheet.show(
                              context: context,
                              onMapTap: (map) {
                                map.showMarker(
                                  coords: Coords(latitude, longitude),
                                  title: reservation.experience.title,
                                  zoom: zoom,
                                );
                              },
                            );

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
                      _showCancellationBottomSheet(context, reservation);
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

  void _showCancellationBottomSheet(BuildContext context, ReservationListResponse reservation) {
    final TextEditingController guideNoteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        bool _isDropdownOpened = false;
        String? selectedReason;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Annulation",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 17),
                  Text(
                    "Conformément à nos Conditions Générales des frais d’annulation peuvent s’appliquer si l’annulation intervient moins de 72h avant le début de l’expérience.",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: AppResources.colorGray, fontSize: 12),
                  ),
                  SizedBox(height: 24),
                  InkWell(
                    onTap: () {
                      setModalState(() {
                        _isDropdownOpened = !_isDropdownOpened;
                      });
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedReason ?? "Sélectionnez une raison",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppResources.colorGray60),
                            ),
                            Icon(
                              _isDropdownOpened
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 24,
                              color: Color(0xFF1C1B1F),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 1,
                          color: AppResources.colorGray15,
                        ),
                        if (_isDropdownOpened)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _categories.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title: Text(_categories[index]),
                                  onTap: () {
                                    setModalState(() {
                                      selectedReason = _categories[index];
                                      _isDropdownOpened = false; // Close dropdown
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  TextFormField(
                    controller: guideNoteController,
                    keyboardType: TextInputType.text,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppResources.colorDark),
                    decoration: InputDecoration(
                      filled: false,
                      hintText: 'Un mot pour le guide',
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      contentPadding: EdgeInsets.only(
                        top: ResponsiveSize.calculateHeight(20, context),
                        bottom: ResponsiveSize.calculateHeight(10, context),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppResources.colorGray15),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppResources.colorGray15),
                      ),
                    ),
                    onChanged: (value) {
                      // Trigger a state update when the text field changes
                      setModalState(() {});
                    },
                  ),
                  SizedBox(height: 82),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: ResponsiveSize.calculateHeight(44, context)),
                      child: Container(
                        width: ResponsiveSize.calculateWidth(264, context),
                        height: ResponsiveSize.calculateHeight(48, context),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return AppResources.colorWhite;
                                }
                                return AppResources.colorVitamine;
                              },
                            ),
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                                side: BorderSide(
                                  color: selectedReason != null &&
                                      guideNoteController.text.isNotEmpty
                                      ? AppResources.colorVitamine
                                      : AppResources.colorGray,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          onPressed: selectedReason != null && guideNoteController.text.isNotEmpty
                              ? () async {
                            // Call the cancelReservation API
                            final result = await AppService.api.cancelReservation(
                              reservation.id,
                              selectedReason!,
                              guideNoteController.text,
                            );

                            // Display an alert dialog with the response
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(result.error == null ? 'Success' : 'Error'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (result.message != null)
                                        Text('Message: ${result.message}'),
                                      if (result.refundAmount != null)
                                        Text('Refund Amount: ${result.refundAmount}'),
                                      if (result.status != null)
                                        Text('Status: ${result.status}'),
                                      if (result.error != null)
                                        Text('Error: ${result.error}', style: TextStyle(color: Colors.red)),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Close the dialog
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                              : null,
                          child: Text(
                            "ANNULER MA RÉSERVATION",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                              color: selectedReason != null &&
                                  guideNoteController.text.isNotEmpty
                                  ? AppResources.colorWhite
                                  : AppResources.colorGray30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
