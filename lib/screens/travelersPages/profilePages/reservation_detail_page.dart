import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:widget_mask/widget_mask.dart';

import '../../../../resources/resources.dart';
import '../../../../utils/responsive_size.dart';
import '../../../models/reservation_data_response.dart';

class ReservationDetailPage extends StatefulWidget {
  ReservationDetailPage({super.key, required this.reservationResponse});

  late ReservationDataResponse reservationResponse;


  @override
  State<ReservationDetailPage> createState() => _ReservationDetailPageState();
}

class _ReservationDetailPageState extends State<ReservationDetailPage> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment(-0.00, -1.00),
                end: Alignment(0, 1),
                //colors: [Color(0x00F8F3EC), AppResources.colorBeigeLight],
                colors: [Color(0xFFEDD8BE), AppResources.colorWhite]
            ),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                WidgetMask(
                  blendMode: BlendMode.srcATop,
                  childSaveLayer: true,
                  mask: Stack(
                    children: [
                      Container(
                        width: ResponsiveSize.calculateWidth(375, context),
                        height: ResponsiveSize.calculateHeight(576, context),
                        child: Stack(
                          children: [
                            Positioned(
                              left: -36,
                              top: 0,
                              bottom: 0,
                              child: Container(
                                width:
                                ResponsiveSize.calculateWidth(427, context),
                                height: ResponsiveSize.calculateHeight(
                                    592, context),
                                child: Image.network(
                                  widget.reservationResponse.mainPhoto,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              top: 60,
                              bottom: 0,
                              child: Container(
                                width:
                                ResponsiveSize.calculateWidth(375, context),
                                height: ResponsiveSize.calculateHeight(
                                    532, context),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment(-0.00, -1.00),
                                    end: Alignment(0, 1),
                                    colors: [
                                      Colors.black.withOpacity(0),
                                      Colors.black
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //back button
                      Positioned(
                        top: 48,
                        left: 28,
                        child: Container(
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  ResponsiveSize.calculateCornerRadius(
                                      40, context)),
                            ),
                          ),
                          child: SizedBox(
                            width:
                            ResponsiveSize.calculateWidth(24, context),
                            height:
                            ResponsiveSize.calculateHeight(24, context),
                            child: FloatingActionButton(
                              backgroundColor: AppResources.colorWhite,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                String.fromCharCode(
                                    CupertinoIcons.back.codePoint),
                                style: TextStyle(
                                  inherit: false,
                                  color: AppResources.colorVitamine,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: CupertinoIcons
                                      .exclamationmark_circle.fontFamily,
                                  package: CupertinoIcons
                                      .exclamationmark_circle.fontPackage,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      ///bloc info in the bottom
                      Positioned(
                        top: 425,
                        left: 28,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recommandé à',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: AppResources.colorBeigeLight),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '88 %',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                      fontSize: 32,
                                      color:
                                      AppResources.colorBeigeLight),
                                ),
                                SizedBox(
                                    width: ResponsiveSize.calculateWidth(
                                        11, context)),
                                Container(
                                  height: 28,
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                  decoration: ShapeDecoration(
                                    color: AppResources.colorVitamine,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          ResponsiveSize
                                              .calculateCornerRadius(
                                              20, context)),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.reservationResponse.categories[0],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                          fontSize: 12,
                                          color: AppResources.colorWhite),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width: ResponsiveSize.calculateWidth(
                                        11, context)),
                                Container(
                                  width: ResponsiveSize.calculateWidth(
                                      85, context),
                                  height: 28,
                                  decoration: ShapeDecoration(
                                    color: AppResources.colorWhite,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          ResponsiveSize
                                              .calculateCornerRadius(
                                              20, context)),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${widget.reservationResponse.pricePerTraveler}€/pers',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                          fontSize: 12,
                                          color:
                                          AppResources.colorDark),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                IntrinsicWidth(
                                  child: Container(
                                    height: 28,
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                        ResponsiveSize.calculateWidth(
                                            12, context)),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      border: Border.all(
                                          color:
                                          AppResources.colorBeigeLight),
                                    ),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          SvgPicture.asset('images/icon_verified.svg'),
                                          SizedBox(
                                              width: ResponsiveSize
                                                  .calculateWidth(
                                                  4, context)),
                                          Text(
                                            'Vérifié',
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                              color: AppResources
                                                  .colorBeigeLight,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width: ResponsiveSize.calculateWidth(
                                        8, context)),
                                if(widget.reservationResponse.isProfessionalGuide)
                                  IntrinsicWidth(
                                    child: Container(
                                      height: 28,
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                          ResponsiveSize.calculateWidth(
                                              12, context)),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        border: Border.all(
                                            color:
                                            AppResources.colorBeigeLight),
                                      ),
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Image.asset(
                                                'images/icon_badge.png'),
                                            SizedBox(
                                                width: ResponsiveSize
                                                    .calculateWidth(
                                                    4, context)),
                                            Text(
                                              'Pro',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(
                                                color: AppResources
                                                    .colorBeigeLight,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ///Todo remove comment when avis is ready
                                /*if(experienceData.isProfessionalGuide)
                                        SizedBox(
                                            width: ResponsiveSize.calculateWidth(
                                                8, context)),
                                        IntrinsicWidth(
                                          child: Container(
                                            height: 28,
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                ResponsiveSize.calculateWidth(
                                                    12, context)),
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(20)),
                                              border: Border.all(
                                                  color:
                                                  AppResources.colorBeigeLight),
                                            ),
                                            child: Center(
                                              child: Row(
                                                children: [
                                                  Image.asset('images/icon_star.png'),
                                                  SizedBox(
                                                      width: ResponsiveSize
                                                          .calculateWidth(
                                                          4, context)),
                                                  Text(
                                                    '4,75/5 (120)',
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.copyWith(
                                                      color: AppResources
                                                          .colorBeigeLight,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),*/
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'images/background_mask1.png',
                  ),
                ),
                SizedBox(height: ResponsiveSize.calculateHeight(32, context)),
                SizedBox(
                  width: ResponsiveSize.calculateWidth(319, context),
                  child: Text(
                    widget.reservationResponse.title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontSize: 32, color: AppResources.colorDark),
                  ),
                ),
                SizedBox(height: ResponsiveSize.calculateHeight(20, context)),
                SizedBox(
                  width: ResponsiveSize.calculateWidth(319, context),
                  child: Opacity(
                    opacity: 0.50,
                    child: Text(
                      widget.reservationResponse.description,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppResources.colorDark),
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveSize.calculateHeight(34, context)),
                Container(
                  padding: const EdgeInsets.only(
                    top: 28,
                    left: 28,
                    right: 28,
                    bottom: 40,
                  ),
                  decoration: const ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 318,
                        child: Text(
                          'Un mot sur ${widget.reservationResponse.guideName}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 32, color: AppResources.colorVitamine),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: 319,
                        child: Text(
                          widget.reservationResponse.aboutGuide,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorGray60),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 34),
                SizedBox(
                  width: ResponsiveSize.calculateWidth(319, context),
                  child: Text(
                    'Gallery',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: AppResources.colorDark),
                  ),
                ),
                SizedBox(height: ResponsiveSize.calculateHeight(12, context)),
                StaggeredGrid.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  children: [
                    if (widget.reservationResponse.image0 != null)
                      StaggeredGridTile.fit(
                        crossAxisCellCount: 4,
                        child: Image.network(widget.reservationResponse.image0!, fit: BoxFit.cover),
                      ),
                    if (widget.reservationResponse.image1 != null)
                      StaggeredGridTile.fit(
                        crossAxisCellCount: 4,
                        child: Image.network(widget.reservationResponse.image1!, fit: BoxFit.cover),
                      ),
                    if (widget.reservationResponse.image2 != null)
                      StaggeredGridTile.fit(
                        crossAxisCellCount: 4,
                        child: Image.network(widget.reservationResponse.image2!, fit: BoxFit.cover),
                      ),
                    if (widget.reservationResponse.image3 != null)
                      StaggeredGridTile.fit(
                        crossAxisCellCount: 4,
                        child: Image.network(widget.reservationResponse.image3!, fit: BoxFit.cover),
                      ),
                    if (widget.reservationResponse.image4 != null)
                      StaggeredGridTile.fit(
                        crossAxisCellCount: 4,
                        child: Image.network(widget.reservationResponse.image4!, fit: BoxFit.cover),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
