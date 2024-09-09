import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:widget_mask/widget_mask.dart';

import '../models/guide_profile_data_response.dart';
import '../resources/resources.dart';
import '../utils/_utils.dart';
import 'event_details.dart';

class GuideProfileCard extends StatefulWidget {
  const GuideProfileCard({super.key, required this.guideProfileResponse, required this.onCardTapped});
  final GuideProfileDataResponse guideProfileResponse;
  final void Function(bool tapped) onCardTapped;

  @override
  _GuideProfileCardState createState() => _GuideProfileCardState();
}

class _GuideProfileCardState extends State<GuideProfileCard> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final customEventList = {
    DateTime.utc(2024, 9, 03): [
      Event('03 Fév.', '09:30 - 13:30'),
      Event('03 Fév.', '14:00 - 18:00'),
    ],
    DateTime.utc(2024, 9, 04): [
      Event('03 Fév.', '12:00 - 13:00'),
    ],
    // Add more custom events here
  };

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return customEventList[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onCardTapped(true); // Trigger callback with data
      },
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
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
                                        widget.guideProfileResponse.mainPhoto,
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
                                            widget.guideProfileResponse.categories[0],
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
                                            '${widget.guideProfileResponse.pricePerTraveler}€/pers',
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
                                                Image.asset(
                                                    'images/icon_verified.png'),
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
                                      if(widget.guideProfileResponse.isProfessionalGuide)
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
                          'images/background_mask.png',
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.calculateHeight(32, context)),
                      SizedBox(
                        width: ResponsiveSize.calculateWidth(319, context),
                        child: Text(
                          widget.guideProfileResponse.title,
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
                            widget.guideProfileResponse.description,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: AppResources.colorDark),
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.calculateHeight(34, context)),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 318,
                            child: Text(
                              'Un mot sur ${widget.guideProfileResponse.guideName}',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 32, color: AppResources.colorVitamine),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: 319,
                            child: Text(
                              widget.guideProfileResponse.aboutGuide,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorGray60),
                            ),
                          ),
                        ],
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
                          if (widget.guideProfileResponse.image0 != null)
                            StaggeredGridTile.fit(
                              crossAxisCellCount: 4,
                              child: Image.network(widget.guideProfileResponse.image0!, fit: BoxFit.cover),
                            ),
                          if (widget.guideProfileResponse.image1 != null)
                            StaggeredGridTile.fit(
                              crossAxisCellCount: 4,
                              child: Image.network(widget.guideProfileResponse.image1!, fit: BoxFit.cover),
                            ),
                          if (widget.guideProfileResponse.image2 != null)
                            StaggeredGridTile.fit(
                              crossAxisCellCount: 4,
                              child: Image.network(widget.guideProfileResponse.image2!, fit: BoxFit.cover),
                            ),
                          if (widget.guideProfileResponse.image3 != null)
                            StaggeredGridTile.fit(
                              crossAxisCellCount: 4,
                              child: Image.network(widget.guideProfileResponse.image3!, fit: BoxFit.cover),
                            ),
                          if (widget.guideProfileResponse.image4 != null)
                            StaggeredGridTile.fit(
                              crossAxisCellCount: 4,
                              child: Image.network(widget.guideProfileResponse.image4!, fit: BoxFit.cover),
                            ),
                        ],
                      ),
                      const SizedBox(height: 34),
                      SizedBox(
                        width: ResponsiveSize.calculateWidth(319, context),
                        child: Text(
                          'Réserve ta date',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(color: AppResources.colorDark),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: ResponsiveSize.calculateWidth(319, context),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                ResponsiveSize.calculateCornerRadius(
                                    12, context)),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: TableCalendar<Event>(
                          headerStyle: HeaderStyle(
                            titleTextStyle: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                color: AppResources.colorDark,
                                fontWeight: FontWeight.w700),
                            formatButtonShowsNext: false,
                            formatButtonVisible: false,
                            titleCentered: true,
                            headerPadding: EdgeInsets.only(
                                bottom: ResponsiveSize.calculateHeight(
                                    16, context)),
                            headerMargin: EdgeInsets.zero,
                          ),
                          firstDay: kFirstDay,
                          lastDay: kLastDay,
                          focusedDay: _focusedDay,
                          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                          calendarFormat: _calendarFormat,
                          eventLoader: _getEventsForDay,
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          onDaySelected: _onDaySelected,
                          onPageChanged: (focusedDay) {
                            _focusedDay = focusedDay;
                          },
                          calendarStyle: CalendarStyle(
                            selectedDecoration: BoxDecoration(
                              color: AppResources.colorWhite,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppResources.colorVitamine,
                                width: 1.0,
                              ),
                            ),
                            selectedTextStyle: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                fontSize: 14,
                                color: AppResources.colorVitamine),
                            markersMaxCount: 1,
                            markerDecoration: const BoxDecoration(
                              color: AppResources.colorVitamine,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        height: 350,
                        child: ValueListenableBuilder<List<Event>>(
                          valueListenable: _selectedEvents,
                          builder: (context, value, _) {
                            if (value.isEmpty) {
                              return Center(
                                child: Text('No events for this day.'),
                              );
                            } else {
                              return EventDetails(events: value);
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 28,
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppResources.colorWhite,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset('images/share.svg',),
                    ),
                  ),
                  SizedBox(width: ResponsiveSize.calculateWidth(14, context)),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppResources.colorVitamine,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset('images/heart-filled.svg',),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}