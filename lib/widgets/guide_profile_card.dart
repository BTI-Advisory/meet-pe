import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:widget_mask/widget_mask.dart';

import '../models/experience_model.dart';
import '../resources/resources.dart';
import '../screens/travelersPages/all_reviews_page.dart';
import '../services/app_service.dart';
import '../utils/_utils.dart';
import '../widgets/_widgets.dart';
import 'animated_icon_button.dart';
import 'event_details.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GuideProfileCard extends StatefulWidget {
  const GuideProfileCard({super.key, required this.experienceData, required this.onCardTapped, required this.favorKey, required this.percentKey});
  final ExperienceModel experienceData;
  final void Function(bool tapped) onCardTapped;
  final GlobalKey favorKey;
  final GlobalKey percentKey;

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

  @override
  void didUpdateWidget(GuideProfileCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if the experience data has changed
    if (widget.experienceData != oldWidget.experienceData) {
      // Repopulate the event list
      _populateEventListFromPlanning();

      // Update the events for the selected day
      _selectedEvents.value = _getEventsForDay(_selectedDay!);
    }
  }

  /// Populate the custom event list from planning data
  void _populateEventListFromPlanning() {
    // Clear the existing events
    _customEventList.clear();

    // Extract planning from the API response
    final planningList = widget.experienceData.experience.planning;

    if (planningList != null) {
      // Loop through all schedules within the planning
      for (final planning in planningList) {
        final startDate = DateTime.parse(planning.startDate);

        // Only add events to the startDate
        for (final schedule in planning.schedules) {
          final event = Event(
            startDate.toIso8601String(),
            '${schedule.startTime} - ${schedule.endTime}',
          );

          // Add the event only to the startDate
          _customEventList.putIfAbsent(startDate, () => []).add(event);
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
                              //width: ResponsiveSize.calculateWidth(375, context),
                              //height: ResponsiveSize.calculateHeight(576, context),
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
                              left: 28,
                              bottom: 60,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.recommended_to_text,
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
                                        key: widget.percentKey,
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
                                            '${double.parse(widget.experienceData.experience.prixParVoyageur ?? '0').toInt()}€/pers',
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
                                                  AppLocalizations.of(context)!.verified_text,
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
                                            padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(12, context)),
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                                              border: Border.all(color: AppResources.colorBeigeLight),
                                            ),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset('images/emoji_language.svg'),
                                                  SizedBox(width: ResponsiveSize.calculateWidth(4, context)),
                                                  ...widget.experienceData.experience.languages.map((url) {
                                                    return Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                      child: Text(
                                                        url.svg,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(fontSize: 20),
                                                      ),
                                                    );
                                                  }).toList(),
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
                                          padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(12, context)),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                                            border: Border.all(color: AppResources.colorBeigeLight),
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.pin_drop,
                                                  color: AppResources.colorWhite,
                                                  size: 20.0,
                                                ),
                                                SizedBox(width: ResponsiveSize.calculateWidth(4, context)),
                                                SizedBox(
                                                  width: ResponsiveSize.calculateWidth(70, context),
                                                  child: Text(
                                                    widget.experienceData.experience.ville!.capitalized,
                                                    textAlign: TextAlign.center,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.copyWith(
                                                      color: AppResources
                                                          .colorBeigeLight,
                                                      fontSize: 12,
                                                    ),
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
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(28, context)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.experienceData.experience.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(fontSize: 32, color: AppResources.colorDark),
                              ),
                              SizedBox(height: ResponsiveSize.calculateHeight(20, context)),
                              Opacity(
                                opacity: 0.50,
                                child: Text(
                                  widget.experienceData.experience.description,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppResources.colorDark),
                                ),
                              ),
                              SizedBox(height: ResponsiveSize.calculateHeight(34, context)),
                              if(widget.experienceData.experience.typeVoyageur.isNotEmpty || widget.experienceData.experience.options.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.category_detail_text,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(color: AppResources.colorDark),
                                    ),
                                    SizedBox(height: ResponsiveSize.calculateHeight(20, context)),
                                    Wrap(
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
                                                      SvgPicture.network(item.svg, height: 16.0, width: 16.0, fit: BoxFit.cover, color: AppResources.colorDark),
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
                                                      SvgPicture.network(item.svg, height: 16.0, width: 16.0, fit: BoxFit.cover, color: AppResources.colorDark),
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
                                    ),
                                    SizedBox(height: ResponsiveSize.calculateHeight(34, context)),
                                  ],
                                ),
                              Text(
                                '${AppLocalizations.of(context)!.word_for_text} ${widget.experienceData.experience.nameGuide}',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppResources.colorVitamine),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                widget.experienceData.experience.descriptionGuide,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorGray60),
                              ),
                              const SizedBox(height: 40),
                              Text(
                                AppLocalizations.of(context)!.price_experience_text,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(color: AppResources.colorDark),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.price_adult_text,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: AppResources.colorDark.withOpacity(0.5)),
                                  ),
                                  Text(
                                    "${double.parse(widget.experienceData.experience.prixParVoyageur ?? '0').toInt()} €",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(color: AppResources.colorDark),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              if (widget.experienceData.experience.discountKids == "1")
                                Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.price_kids_text,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: AppResources.colorDark.withOpacity(0.5)),
                                  ),
                                  Text(
                                    "${widget.experienceData.experience.prixParEnfant} €",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(color: AppResources.colorDark),
                                  ),
                                ],
                              ),
                                const SizedBox(height: 12),
                              if (widget.experienceData.experience.supportGroupPrive == "1")
                                Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${AppLocalizations.of(context)!.price_group_match_1_text} ${widget.experienceData.experience.maxNbVoyageur} ${AppLocalizations.of(context)!.price_group_match_2_text}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: AppResources.colorDark.withOpacity(0.5)),
                                  ),
                                  Text(
                                    "${widget.experienceData.experience.prixParGroup} €",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(color: AppResources.colorDark),
                                  ),
                                ],
                              ),
                                const SizedBox(height: 12),
                              Container(
                                height: 1,
                                color: AppResources.colorGray15,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                AppLocalizations.of(context)!.gallery_text,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(color: AppResources.colorDark),
                              ),
                              SizedBox(height: ResponsiveSize.calculateHeight(12, context)),
                            ],
                          ),
                        ),
                      ),
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
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(28, context)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 34),
                              Text(
                                AppLocalizations.of(context)!.reserve_date_text,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(color: AppResources.colorDark),
                              ),
                              const SizedBox(height: 12),
                              Container(
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
                                  locale: 'fr_FR',
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
                                child: ValueListenableBuilder<List<Event>>(
                                  valueListenable: _selectedEvents,
                                  builder: (context, value, _) {
                                    if (value.isEmpty) {
                                      return Center(
                                        child: Text(AppLocalizations.of(context)!.no_events_text),
                                      );
                                    } else {
                                      return EventDetails(events: value, experienceData: widget.experienceData.experience,);
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(height: 47),
                              if (widget.experienceData.experience.reviews.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.reviews_community_text,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(color: AppResources.colorDark),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Text(
                                            widget.experienceData.experience.reviewsAVG,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(color: Colors.black.withOpacity(0.5))
                                        ),
                                        SizedBox(width: ResponsiveSize.calculateWidth(4, context)),
                                        SvgPicture.asset('images/match.svg', color: AppResources.colorVitamine, width: 16, height: 16),
                                        SizedBox(width: ResponsiveSize.calculateWidth(4, context)),
                                        Text(
                                            "(${widget.experienceData.experience.reviews.length} ${AppLocalizations.of(context)!.reviews_text})",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(color: Colors.black.withOpacity(0.5))
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    ReviewsItemWidget(reviews: widget.experienceData.experience.reviews.take(3).toList()),
                                    const SizedBox(height: 19),
                                    Container(
                                      width: double.infinity,
                                      height: 44,
                                      child: TextButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                          MaterialStateProperty.all(Colors.transparent),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              side: const BorderSide(
                                                width: 1,
                                                color: AppResources.colorDark,
                                              ),
                                              borderRadius: BorderRadius.circular(40),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          navigateTo(context, (_) => AllReviewsPage(reviews: widget.experienceData.experience.reviews, reviewsAVG: widget.experienceData.experience.reviewsAVG));
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!.see_all_reviews_text,
                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                              color: AppResources.colorDark),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 38),
                                  ],
                                )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 28,
              child: Container(
                key: widget.favorKey,
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppResources.colorVitamine,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: AnimatedIconButton(
                  onPressed: () {
                    AppService.api.setFavoriteExperience(
                      int.parse(widget.experienceData.experience.id),
                      "add",
                      "${widget.experienceData.weightedMatchScore}",
                      context,
                    );
                  },
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}