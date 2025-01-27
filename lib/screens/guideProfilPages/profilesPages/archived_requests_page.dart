import 'package:flutter/material.dart';

import '../../../models/archived_reservation_response.dart';
import '../../../resources/resources.dart';
import '../../../services/app_service.dart';
import '../../../utils/_utils.dart';
import '../../../widgets/themed/ep_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      appBar: EpAppBar(
        title: AppLocalizations.of(context)!.archive_request_text,
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
                    child: Column(
                      children: List.generate(
                        archivedReservation.length,
                            (index) => GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => _buildPopupDialog(context, archivedReservation[index]),
                            );
                          },
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
    );
  }

  Widget requestCard(ArchivedReservationResponse archivedReservation) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x1E000000),
            blurRadius: 12,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 19, top: 16, bottom: 11),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Column(
                  children: [
                    ClipOval(
                      child: Image.network(archivedReservation.voyageur.profilePath, width: 38, height: 38, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      archivedReservation.voyageur.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontWeight: FontWeight.w500, color: AppResources.colorDark),
                    )
                  ],
                ),
                const SizedBox(width: 17),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      requestFrenchFormat(archivedReservation.dateTime),
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontSize: 14, color: AppResources.colorDark),
                    ),
                    SizedBox(
                      width: 120,
                      child: Text(
                        archivedReservation.experience.title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorGray60),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              AppLocalizations.of(context)!.archived_text,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Color(0xFFA5A5A5)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPopupDialog(
      BuildContext context, ArchivedReservationResponse archivedReservation) {
    return AlertDialog(
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.symmetric(horizontal: 0),
        backgroundColor: AppResources.colorWhite,
        content: SizedBox(
            width: 329,
            height: 420,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 19),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 21),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipOval(
                                  child: Image.network(
                                      archivedReservation.voyageur.profilePath,
                                      width: 75,
                                      height: 75,
                                      fit: BoxFit.cover)),
                              SizedBox(
                                  width: ResponsiveSize.calculateWidth(
                                      19, context)),
                              Text(archivedReservation.voyageur.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                      color: AppResources.colorDark)),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.close,
                                size: 20, color: AppResources.colorGray30),
                          )
                        ],
                      ),
                      const SizedBox(height: 21),
                      Row(
                        children: [
                          Visibility(
                            visible: archivedReservation.voyageur.isVerified,
                            child: Container(
                              height:
                              ResponsiveSize.calculateHeight(28, context),
                              padding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveSize.calculateWidth(
                                      12, context)),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.all(Radius.circular(
                                    ResponsiveSize.calculateCornerRadius(
                                        20, context))),
                                border:
                                Border.all(color: AppResources.colorDark),
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    Image.asset('images/icon_verified.png',
                                        color: AppResources.colorDark),
                                    SizedBox(
                                        width: ResponsiveSize.calculateWidth(
                                            4, context)),
                                    Text(
                                      AppLocalizations.of(context)!.verified_text,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                        color: AppResources.colorDark,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                              visible: archivedReservation.voyageur.isVerified,
                              child: SizedBox(
                                  width: ResponsiveSize.calculateWidth(
                                      41, context))),
                          Text(
                            AppLocalizations.of(context)!.lived_experience,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppResources.colorDark),
                          ),
                          SizedBox(
                              width: ResponsiveSize.calculateWidth(5, context)),
                          Text(
                            archivedReservation.voyageur.numberOfExperiences.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: AppResources.colorDark),
                          )
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '${AppLocalizations.of(context)!.experience_reserved_text} ${yearsFrenchFormat(archivedReservation.createdAt)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppResources.colorDark, fontSize: 12),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        archivedReservation.experience.title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                            color: AppResources.colorDark, fontSize: 14),
                      ),
                      const SizedBox(height: 23),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.number_traveler_text,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                color: AppResources.colorDark,
                                fontSize: 12),
                          ),
                          Text(
                            archivedReservation.nombreDesVoyageurs.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(color: AppResources.colorDark),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.reserved_slot_text,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                color: AppResources.colorDark,
                                fontSize: 12),
                          ),
                          Text(
                            requestFrenchFormat(archivedReservation.dateTime),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(color: AppResources.colorDark),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: AppResources.colorImputStroke,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
        ),
    );
  }
}
