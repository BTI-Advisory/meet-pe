import 'package:flutter/material.dart';

import '../models/guide_reservation_response.dart';
import '../resources/resources.dart';
import '../utils/utils.dart';

class RequestCard extends StatefulWidget {
  //const RequestCard({Key? key}) : super(key: key);
  RequestCard({super.key, required this.guideReservationResponse});
  final GuideReservationResponse guideReservationResponse;

  @override
  _RequestCardState createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  bool accepted = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 2),
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
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          ClipOval(
                            child: Image.network(widget.guideReservationResponse.voyageur.profilePath, width: 38, height: 38, fit: BoxFit.cover),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.guideReservationResponse.voyageur.name,
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
                            requestFrenchFormat(widget.guideReservationResponse.dateTime),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontSize: 14, color: AppResources.colorDark),
                          ),
                          Text(
                            widget.guideReservationResponse.experience.title,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorGray60),
                          ),
                        ],
                      ),
                      const SizedBox(width: 23),
                      Visibility(
                        visible: !accepted,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  accepted = true;
                                });
                                print('Accepted');
                              },
                              child: Column(
                                children: [
                                  Icon(Icons.check, size: 24,),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Accepter',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(color: AppResources.colorDark),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 19),
                            GestureDetector(
                              onTap: () {
                                print('Refuser');
                              },
                              child: Column(
                                children: [
                                  Icon(Icons.close, size: 24,),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Refuser',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(color: AppResources.colorDark),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Visibility(
                        visible: accepted,
                        child: Row(
                          children: [
                            const Icon(Icons.check, size: 24, color: Color(0xFF54EE9D),),
                            const SizedBox(width: 8),
                            Text(
                              'Accepté',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: Color(0xFF54EE9D)),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 11),
                ],
              ),
            ),
            Visibility(
              visible: (widget.guideReservationResponse.status == 'Pending'),
              child: Positioned(
                  top: 0,
                  left: 63,
                  child: Container(
                    width: 43,
                    height: 18,
                    decoration: ShapeDecoration(
                      color: AppResources.colorVitamine,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'New',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 12, color: AppResources.colorWhite)
                      ),
                    ),
                  )
              ),
            )
          ],
        ),
        const SizedBox(height: 19),
      ],
    );
  }
}