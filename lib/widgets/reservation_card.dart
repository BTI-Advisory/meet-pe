import 'package:flutter/material.dart';
import 'package:widget_mask/widget_mask.dart';

import '../models/reservation_list_response.dart';
import '../resources/resources.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReservationCard extends StatefulWidget {
  const ReservationCard({super.key, required this.reservationResponse});
  final ReservationListResponse reservationResponse;

  @override
  _ReservationCardState createState() => _ReservationCardState();
}

class _ReservationCardState extends State<ReservationCard> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
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
                mask: Image.network(widget.reservationResponse.experience.photos.first.photoUrl, width: 68, height: 68, fit: BoxFit.cover),
                child: Image.asset(
                  'images/mask_picture.png',
                  width: 68,
                  height: 68,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        widget.reservationResponse.experience.title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontSize: 14, color: widget.reservationResponse.status == 'Annulée' ? AppResources.colorGray30 : AppResources.colorDark),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    if (widget.reservationResponse.status == 'En attente')
                      statusRow(context, Icons.watch_later_outlined, AppResources.colorVitamine, AppLocalizations.of(context)!.pending_confirmation_text),
                    if (widget.reservationResponse.status == 'Archivée')
                      statusRow(context, Icons.bookmark, AppResources.colorDark, AppLocalizations.of(context)!.archived_confirmation_text),
                    if (widget.reservationResponse.status == 'Acceptée')
                      statusRow(context, Icons.check, const Color(0xFF33C579), AppLocalizations.of(context)!.accepted_confirmation_text),
                    if (widget.reservationResponse.status == 'Annulée')
                      statusRow(context, Icons.close, AppResources.colorGray30, AppLocalizations.of(context)!.cancel_confirmation_text),
                    if (widget.reservationResponse.status == 'Refusée')
                      statusRow(context, Icons.close, Colors.red, AppLocalizations.of(context)!.refused_confirmation_text),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: const Icon(Icons.chevron_right, size: 24, color: AppResources.colorDark,),
              )
            ],
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }
}

Widget statusRow(BuildContext context, IconData icon, Color color, String text) {
  return Row(
    children: [
      Icon(icon, size: 17, color: color),
      const SizedBox(width: 5),
      Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
      )
    ],
  );
}
