import 'package:flutter/material.dart';
import 'package:widget_mask/widget_mask.dart';

import '../../../resources/resources.dart';
import '../../../utils/responsive_size.dart';
import '../../../widgets/themed/ep_app_bar.dart';

class ArchivedRequestsPage extends StatefulWidget {
  const ArchivedRequestsPage({super.key});

  @override
  State<ArchivedRequestsPage> createState() => _ArchivedRequestsPageState();
}

class _ArchivedRequestsPageState extends State<ArchivedRequestsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EpAppBar(
        title: 'Demandes archivées',
      ),
      body: SingleChildScrollView(
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
      ),
    );
  }

  Widget requestCard() {
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
                mask: Image.asset(
                  'images/imageTest.png',
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
                    'Paris XVIe avec Ma...',
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
              const SizedBox(width: 43),
              Container(
                width: 73,
                height: 21,
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  color: Color(0xFFFFECAB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'à compléter',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 10, fontWeight: FontWeight.w400, color: const Color(0xFFC89C00)),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
