import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:meet_pe/models/matching_api_request_builder.dart';
import 'package:meet_pe/resources/_resources.dart';
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
    _matchingListFuture = AppService.api.fetchExperiences(FiltersRequest());

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
                                    final result = await showModalBottomSheet<Map<String, dynamic>>(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return PositionFiltred();
                                      },
                                    );
                                    if (result != null) {
                                      setState(() {
                                        _textEditingController.text = "";
                                        double latitude = result['latitude'];
                                        double longitude = result['longitude'];
                                        int radius = result['radius'];

                                        _matchingListFuture = AppService.api.fetchExperiences(
                                          FiltersRequest(
                                            filtreLat: latitude.toString(),
                                            filtreLang: longitude.toString(),
                                            filtreDistance: radius.toString()
                                          ),
                                        );
                                      });
                                    }
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
                                    final result = await showModalBottomSheet<Map<String, String>>(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return CalendarMatching();
                                      },
                                    );
                                    if (result != null) {
                                      setState(() {
                                        if (result.containsKey('rangeStart') && result.containsKey('rangeEnd')) {
                                          // Handle range selection
                                          final rangeStart = result['rangeStart'];
                                          final rangeEnd = result['rangeEnd'];
                                          print('Selected Range: $rangeStart to $rangeEnd');
                                          _matchingListFuture = AppService.api.fetchExperiences(
                                            FiltersRequest(
                                              filtreDateDebut: rangeStart,
                                              filtreDateFin: rangeEnd,
                                            ),
                                          );
                                        }
                                      });
                                    }
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
                                    final result = await showModalBottomSheet<Map<String, String>>(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return const FiltredWidget();
                                      },
                                    );

                                    if (result != null) {
                                      setState(() {
                                        // Extract values with fallback to defaults
                                        final filtreNbAdultes = result['filtre_nb_adultes'] ?? "0";
                                        final filtreNbEnfants = result['filtre_nb_enfants'] ?? "0";
                                        final filtreNbBebes = result['filtre_nb_bebes'] ?? "0";
                                        final filtrePrixMin = result['filtre_prix_min'] ?? "0";
                                        final filtrePrixMax = result['filtre_prix_max'] ?? "0";
                                        final filtreCategorie = result['filtre_categorie'] ?? "";
                                        final filtreLangue = result['filtre_langue'] ?? "";

                                        // Make API call with filters
                                        _matchingListFuture = AppService.api.fetchExperiences(
                                          FiltersRequest(
                                            filtreNbAdult: filtreNbAdultes,
                                            filtreNbEnfant: filtreNbEnfants,
                                            filtreNbBebes: filtreNbBebes,
                                            filtrePrixMin: filtrePrixMin,
                                            filtrePrixMax: filtrePrixMax,
                                            filtreCategorie: filtreCategorie,
                                            filtreLangue: filtreLangue,
                                          ),
                                        );
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.tune, size: 20),
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