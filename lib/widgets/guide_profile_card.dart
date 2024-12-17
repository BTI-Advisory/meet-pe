import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:widget_mask/widget_mask.dart';

import '../models/experience_model.dart';
import '../resources/resources.dart';
import '../utils/_utils.dart';
import 'event_details.dart';

class GuideProfileCard extends StatefulWidget {
  const GuideProfileCard({super.key, required this.experienceData, required this.onCardTapped});
  final ExperienceModel experienceData;
  final void Function(bool tapped) onCardTapped;

  @override
  _GuideProfileCardState createState() => _GuideProfileCardState();
}

class _GuideProfileCardState extends State<GuideProfileCard> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, List<Event>> _customEventList = {};

  @override
  void initState() {
    super.initState();

    // Initialize selected day and events
    _selectedDay = _focusedDay;

    // Populate _customEventList with planning data from API
    _populateEventListFromPlanning();

    // Initialize the ValueNotifier with events for the current selected day
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  /// Populate the custom event list from planning data
  void _populateEventListFromPlanning() {
    // Extract planning from the API response
    final planningList = widget.experienceData.experience.planning;

    if (planningList != null) {
      // Loop through all schedules within the planning
      for (final planning in planningList) {
        final startDate = DateTime.parse(planning.startDate);
        final endDate = DateTime.parse(planning.endDate);

        // Iterate through the range of dates from startDate to endDate
        for (DateTime currentDate = startDate;
        currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate);
        currentDate = currentDate.add(const Duration(days: 1))) {
          // Map each schedule to the current date
          for (final schedule in planning.schedules) {
            final event = Event(
              currentDate.toIso8601String(),
              '${schedule.startTime} - ${schedule.endTime}',
            );

            // If the date already has events, append the new one; otherwise, create a new list
            if (_customEventList.containsKey(currentDate)) {
              _customEventList[currentDate]!.add(event);
            } else {
              _customEventList[currentDate] = [event];
            }
          }
        }
      }
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _customEventList[DateTime(day.year, day.month, day.day)] ?? [];
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
                                      width: ResponsiveSize.calculateWidth(427, context),
                                      height: ResponsiveSize.calculateHeight(592, context),
                                      child: Image.network(
                                        widget.experienceData.experience.photoprincipal.photoUrl,
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
                                        '${widget.experienceData.weightedMatchScore} %',
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
                                            widget.experienceData.experience.categories[0].choix,
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
                                            '${widget.experienceData.experience.prixParVoyageur}€/pers',
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
                                                  SvgPicture.asset('images/emoji_language.svg'),
                                                  SizedBox(width: ResponsiveSize.calculateWidth(4, context)),
                                                  ...widget.experienceData.experience.languages.map((url) {
                                                    return Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                      child: Image.network(
                                                        url.svg,
                                                        height: 20.0,
                                                        width: 20.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    );
                                                  }).toList(),
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
                          widget.experienceData.experience.title,
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
                            widget.experienceData.experience.description,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: AppResources.colorDark),
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.calculateHeight(34, context)),
                      SizedBox(
                        width: 319,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: ResponsiveSize.calculateWidth(8, context), // Horizontal spacing between items
                          runSpacing: ResponsiveSize.calculateHeight(12, context), // Vertical spacing between lines
                          children: [
                            ...widget.experienceData.experience.typeVoyageur.map((item) {
                              return IntrinsicWidth(
                                child: Container(
                                  height: 40,
                                  padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(12, context)),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                    border: Border.all(color: AppResources.colorDark),
                                  ),
                                  child: Row(
                                    children: [
                                      if (item.svg.isNotEmpty)
                                        Image.network(item.svg, height: 16.0, width: 16.0, fit: BoxFit.cover),
                                      if (item.svg.isNotEmpty)
                                        SizedBox(width: ResponsiveSize.calculateWidth(4, context)),
                                      Text(
                                        item.choix,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: AppResources.colorDark),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                            ...widget.experienceData.experience.options.map((item) {
                              return IntrinsicWidth(
                                child: Container(
                                  height: 40,
                                  padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(12, context)),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                    border: Border.all(color: AppResources.colorDark),
                                  ),
                                  child: Row(
                                    children: [
                                      if (item.svg.isNotEmpty)
                                        Image.network(item.svg, height: 16.0, width: 16.0, fit: BoxFit.cover),
                                      if (item.svg.isNotEmpty)
                                        SizedBox(width: ResponsiveSize.calculateWidth(4, context)),
                                      Text(
                                        item.choix,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: AppResources.colorDark),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ]
                        )
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
                              'Un mot sur ${widget.experienceData.experience.nameGuide}',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 32, color: AppResources.colorVitamine),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: 319,
                            child: Text(
                              widget.experienceData.experience.descriptionGuide,
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
                        children: widget.experienceData.experience.photos.map((photo) {
                          if (photo.photoUrl != null && photo.photoUrl.isNotEmpty) {
                            return StaggeredGridTile.fit(
                              crossAxisCellCount: 4,
                              child: Image.network(photo.photoUrl, fit: BoxFit.cover),
                            );
                          } else {
                            return const SizedBox.shrink(); // Return an empty widget if photoUrl is null or empty
                          }
                        }).toList(),
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