import 'package:flutter/material.dart';
import 'package:widget_mask/widget_mask.dart';

import '../../../models/archived_reservation_response.dart';
import '../../../resources/resources.dart';
import '../../../services/app_service.dart';
import '../../../utils/responsive_size.dart';
import '../../../widgets/themed/ep_app_bar.dart';

class ArchivedRequestsPage extends StatefulWidget {
  const ArchivedRequestsPage({super.key});

  @override
  State<ArchivedRequestsPage> createState() => _ArchivedRequestsPageState();
}

class _ArchivedRequestsPageState extends State<ArchivedRequestsPage> {
  late Future<List<ArchivedReservationResponse>> _archivedReservationFuture;

  @override
  void initState() {
    super.initState();
    _archivedReservationFuture = AppService.api.getArchivedReservation();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EpAppBar(
        title: 'Demandes archivées',
      ),
      body: FutureBuilder<List<ArchivedReservationResponse>>(
        future: _archivedReservationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final archivedReservation = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.calculateWidth(13, context)),
                    /*child: Column(
                      children: [
                        const SizedBox(height: 37),
                        requestCard(),
                        requestCard()
                      ],
                    ),*/
                    child: Column(
                      children: List.generate(
                        archivedReservation.length,
                            (index) => GestureDetector(
                          onTap: () {},
                          child: requestCard(archivedReservation[index]),
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
      /*body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.calculateWidth(13, context)),
              child: Column(
                children: [
                  const SizedBox(height: 37),
                  requestCard(),
                  requestCard()
                ],
              ),
            )
          ],
        ),
      ),*/
    );
  }

  Widget requestCard(ArchivedReservationResponse archivedReservation) {
    return Column(
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            shadows: const [
              BoxShadow(
                color: Color(0x1E000000),
                blurRadius: 12,
                offset: Offset(0, 4),
                spreadRadius: 0,
              )
            ],
          ),
          child: Row(
            children: [
              WidgetMask(
                blendMode: BlendMode.srcATop,
                childSaveLayer: true,
                mask: Image.network(
                  archivedReservation.voyageur.profilePath,
                  width: 68,
                  height: 68,
                  fit: BoxFit.cover,
                ),
                child: Image.asset(
                  'images/mask_picture.png',
                  width: 68,
                  height: 68,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    archivedReservation.experience.title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontSize: 14, color: AppResources.colorDark),
                  ),
                  Text(
                    'Afficher la réservation',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
