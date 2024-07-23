import 'package:flutter/material.dart';
import 'package:widget_mask/widget_mask.dart';

import '../models/reservation_data_response.dart';
import '../resources/resources.dart';

class ReservationCard extends StatefulWidget {
  const ReservationCard({super.key, required this.reservationResponse});
  final ReservationDataResponse reservationResponse;

  @override
  _ReservationCardState createState() => _ReservationCardState();
}

class _ReservationCardState extends State<ReservationCard> {
  bool accepted = false;

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
                mask: Image.network(widget.reservationResponse.mainPhoto ?? '', width: 68, height: 68, fit: BoxFit.cover),
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
                  SizedBox(
                    width: 176,
                    child: Text(
                      widget.reservationResponse.title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontSize: 14, color: widget.reservationResponse.status == 'Annulée' ? AppResources.colorGray30 : AppResources.colorDark),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  if(widget.reservationResponse.status == 'En attente de confirmation')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.watch_later_outlined, size: 17, color: AppResources.colorVitamine),
                        const SizedBox(width: 5),
                        Text(
                          widget.reservationResponse.status,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppResources.colorVitamine),
                        )
                      ],
                    ),
                  if(widget.reservationResponse.status == 'Archivée')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bookmark, size: 17, color: AppResources.colorDark),
                        const SizedBox(width: 5),
                        Text(
                          widget.reservationResponse.status,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppResources.colorDark),
                        )
                      ],
                    ),
                  if(widget.reservationResponse.status == 'Accepté')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check, size: 17, color: Color(0xFF33C579)),
                        const SizedBox(width: 5),
                        Text(
                          widget.reservationResponse.status,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Color(0xFF33C579)),
                        )
                      ],
                    ),
                  if(widget.reservationResponse.status == 'Annulée')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.close, size: 17, color: AppResources.colorGray30),
                        const SizedBox(width: 5),
                        Text(
                          widget.reservationResponse.status,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppResources.colorGray30),
                        )
                      ],
                    )
                ],
              ),
              const SizedBox(width: 43),
              const Icon(Icons.chevron_right, size: 24, color: AppResources.colorDark,)
            ],
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }
}