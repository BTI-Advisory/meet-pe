import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:widget_mask/widget_mask.dart';

import '../models/favoris_data_response.dart';
import '../resources/resources.dart';
import '../services/app_service.dart';

class FavorisCard extends StatefulWidget {
  const FavorisCard({super.key, required this.favorisResponse, required this.onRemoveFavorite});
  final FavorisDataResponse favorisResponse;
  final void Function(FavorisDataResponse) onRemoveFavorite; // Callback to notify parent

  @override
  _FavorisCardState createState() => _FavorisCardState();
}

class _FavorisCardState extends State<FavorisCard> {

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
                mask: Image.network(widget.favorisResponse.experience.photoprincipal.photoUrl ?? '', width: 68, height: 68, fit: BoxFit.cover),
                child: Image.asset(
                  'images/mask_picture.png',
                  width: 68,
                  height: 68,
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 176,
                child: Text(
                  widget.favorisResponse.experience.title,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontSize: 14, color: AppResources.colorDark),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 43),
              IconButton(
                onPressed: () {
                  // Notify the parent widget that the experience is removed
                  widget.onRemoveFavorite(widget.favorisResponse);
                  AppService.api.setFavoriteExperience(widget.favorisResponse.experienceId, "remove", "", context);
                },
                icon: SvgPicture.asset('images/heart_outlined_fill.svg'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }
}