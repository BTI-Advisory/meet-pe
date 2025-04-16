import 'package:flutter/material.dart';
import 'package:meet_pe/utils/_utils.dart';
import 'package:widget_mask/widget_mask.dart';

import '../models/experience_data_response.dart';
import '../resources/resources.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyCardExperience extends StatefulWidget {
  MyCardExperience({super.key, required this.guideExperiencesResponse, required this.parentContext});
  final ExperienceDataResponse guideExperiencesResponse;
  final BuildContext parentContext;

  @override
  _MyCardExperienceState createState() => _MyCardExperienceState();
}

class _MyCardExperienceState extends State<MyCardExperience> {
  bool accepted = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WidgetMask(
                    blendMode: BlendMode.srcATop,
                    childSaveLayer: true,
                    mask: Image.network(widget.guideExperiencesResponse.photoprincipal.photoUrl ?? '', width: 68, height: 68, fit: BoxFit.cover),
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
                          width: 176,
                          child: Text(
                            widget.guideExperiencesResponse.title,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontSize: 14, color: AppResources.colorDark),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Visibility(
                          visible: widget.guideExperiencesResponse.status == 'en ligne',
                          child: Text(
                            '${AppLocalizations.of(widget.parentContext)!.posted_on_text} ${yearsFrenchFormat(widget.guideExperiencesResponse.createdAt)}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorGray60),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.guideExperiencesResponse.status == 'en cours de vérification')
                              Row(
                                children: [
                                  Icon(Icons.watch_later_outlined, size: 17, color: AppResources.colorVitamine),
                                  const SizedBox(width: 5),
                                  Text(
                                    widget.guideExperiencesResponse.status,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: AppResources.colorVitamine),
                                  ),
                                ],
                              ),

                            if (widget.guideExperiencesResponse.status == 'à compléter')
                              Row(
                                children: [
                                  Icon(Icons.hourglass_empty, size: 17, color: AppResources.colorVitamine),
                                  const SizedBox(width: 5),
                                  Text(
                                    widget.guideExperiencesResponse.status,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: AppResources.colorVitamine),
                                  ),
                                ],
                              ),

                            if (widget.guideExperiencesResponse.status == 'autre_document')
                              Row(
                                children: [
                                  const Icon(Icons.file_copy, size: 17, color: AppResources.colorVitamine),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Autres documents nécessaires',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: AppResources.colorVitamine),
                                  ),
                                ],
                              ),

                            if (widget.guideExperiencesResponse.status == 'en ligne')
                              Row(
                                children: [
                                  Icon(Icons.circle, size: 17, color: Color(0xFF54EE9D)),
                                  const SizedBox(width: 5),
                                  Text(
                                    widget.guideExperiencesResponse.status,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Color(0xFF54EE9D)),
                                  ),
                                ],
                              ),

                            if (widget.guideExperiencesResponse.status == 'hors ligne')
                              Row(
                                children: [
                                  Icon(Icons.circle, size: 17, color: AppResources.colorVitamine),
                                  const SizedBox(width: 5),
                                  Text(
                                    widget.guideExperiencesResponse.status,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: AppResources.colorVitamine),
                                  ),
                                ],
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, size: 24, color: AppResources.colorDark,)
                ],
              ),
            ),
            Visibility(
              visible: widget.guideExperiencesResponse.status == 'en cours de vérification',
              child: Positioned(
                  top: 0,
                  left: 73,
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
          ]
        ),
        const SizedBox(height: 18),
      ],
    );
  }
}