import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:meet_pe/models/matching_api_request_builder.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:meet_pe/services/api_client.dart';
import 'package:meet_pe/utils/_utils.dart';
import 'package:meet_pe/widgets/_widgets.dart';
import 'package:meet_pe/widgets/guide_profile_card.dart';

import '../../models/experience_model.dart';
import '../../services/app_service.dart';

class MatchingPage extends StatefulWidget {
  const MatchingPage({super.key});

  @override
  State<MatchingPage> createState() => _MatchingPageState();
}

class _MatchingPageState extends State<MatchingPage> {
  late Future<List<ExperienceModel>> _matchingListFuture;

  late FocusNode _focusNode;
  late TextEditingController _textEditingController;
  bool _showButton = false;
  bool tappedScreen = false;

  @override
  void initState() {
    super.initState();
    _matchingListFuture = AppService.api.fetchExperiences(
      FiltersRequest(
        filtreDateDebut: "2024-12-24",
        filtreDateFin: "2025-12-29"
      )
    );

    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    _textEditingController = TextEditingController();
    _textEditingController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _textEditingController.removeListener(_onTextChanged);
    _textEditingController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _showButton = _focusNode.hasFocus;
    });
  }

  void _onTextChanged() {
    setState(() {
      _showButton = _focusNode.hasFocus && _textEditingController.text.isEmpty;
    });
  }

  void _onCitySelected(String? city, String? country) {
    setState(() {
      _matchingListFuture = AppService.api.fetchExperiences(
        FiltersRequest(
          filtreDateDebut: "2024-12-24",
          filtreDateFin: "2025-12-29",
          filtreVille: city,
          filtrePays: country
        ),
      );
    });
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        Future.delayed(const Duration(milliseconds: 100), () {
          setState(() {
            tappedScreen = false;
          });
        });
      },
      child: Scaffold(
        backgroundColor: AppResources.colorBeigeLight,
        body: FutureBuilder<List<ExperienceModel>>(
          future: _matchingListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('No matching experiences found.'));
            } else {
              final filteredProfiles = snapshot.data!;
              return Stack(
                children: [
                  filteredProfiles.isNotEmpty ?
                    Container(
                    width: size.width,
                    height: size.height,
                    child: AbsorbPointer(
                      absorbing: tappedScreen,
                      child: CardSwiper(
                        cardsCount: filteredProfiles.length,
                        cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                          return GuideProfileCard(
                            experienceData: filteredProfiles[index],
                            onCardTapped: (tapped) {
                              setState(() {
                                tappedScreen = tapped;
                              });
                            },
                          );
                        },
                        allowedSwipeDirection: AllowedSwipeDirection.symmetric(vertical: false, horizontal: true),
                        padding: const EdgeInsets.all(0),
                        numberOfCardsDisplayed: 1,
                      ),
                    ),
                  )
                  :
                  Center(
                    child: Text(
                      "Oups désolé ! Nous ne sommes pas encore présent dans cette ville. Stay tuned, on est déjà sur le coup pour te dénicher les meilleurs pépites de cette région 🚀",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                          color: AppResources.colorGray100),
                    ),
                  ),
                  Positioned(
                    top: 45,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 200,
                            //height: 40,
                            child: SingleChildScrollView(
                              child: NetworkSearchField(
                                controller: _textEditingController,
                                focusNode: _focusNode,
                                onCitySelected: _onCitySelected,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Container(
                            width: ResponsiveSize.calculateWidth(140, context),
                            height: ResponsiveSize.calculateHeight(40, context),
                            decoration: BoxDecoration(
                              color: AppResources.colorWhite,
                              borderRadius: BorderRadius.circular(ResponsiveSize.calculateCornerRadius(30, context)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    final result = await showModalBottomSheet<bool>(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return PositionFiltred();
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.gps_fixed, size: 20,),
                                ),
                                const VerticalDivider(
                                  color: Colors.grey, // Adjust the color to your preference
                                  thickness: 1, // Adjust the thickness as needed
                                  width: 0, // Adjust the width to control the space taken by the divider
                                  indent: 8, // Adjust the indent to control the space from the top
                                  endIndent: 8, // Adjust the endIndent to control the space from the bottom
                                ),
                                IconButton(
                                  onPressed: () async {
                                    final result = await showModalBottomSheet<bool>(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return CalendarMatching();
                                      },
                                    );
                                  },
                                  icon: Icon(Icons.date_range, size: 20,),
                                ),
                                const VerticalDivider(
                                  color: Colors.grey, // Adjust the color to your preference
                                  thickness: 1, // Adjust the thickness as needed
                                  width: 0, // Adjust the width to control the space taken by the divider
                                  indent: 8, // Adjust the indent to control the space from the top
                                  endIndent: 8, // Adjust the endIndent to control the space from the bottom
                                ),
                                IconButton(
                                  onPressed: () async {
                                    final result = await showModalBottomSheet<bool>(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return FiltredWidget();
                                      },
                                    );
                                  },
                                  icon: Icon(Icons.tune, size: 20,),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }
          }
        ),
      ),
    );
  }
}