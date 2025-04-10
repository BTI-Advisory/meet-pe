import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:meet_pe/models/matching_api_request_builder.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:meet_pe/utils/_utils.dart';
import 'package:meet_pe/widgets/_widgets.dart';
import 'package:meet_pe/widgets/guide_profile_card.dart';
import 'package:provider/provider.dart';

import '../../models/experience_model.dart';
import '../../providers/filter_provider.dart';
import '../../services/app_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MatchingPage extends StatefulWidget {
  final GlobalKey favorKey;
  final GlobalKey percentKey;
  final GlobalKey searchCityKey;
  final GlobalKey aroundMeKey;
  final GlobalKey filtersKey;

  MatchingPage({Key? key, required this.favorKey, required this.percentKey, required this.searchCityKey, required this.aroundMeKey, required this.filtersKey,}) : super(key: key);

  @override
  State<MatchingPage> createState() => _MatchingPageState();
}

class _MatchingPageState extends State<MatchingPage> {
  late Future<List<ExperienceModel>> _matchingListFuture;

  late FocusNode _focusNode;
  late TextEditingController _textEditingController;
  bool _showButton = false;
  bool tappedScreen = false;
  String _citySelected = '';
  String _countrySelected = '';

  List<ExperienceModel> filteredProfiles = [];

  @override
  void initState() {
    super.initState();

    // Initialize _matchingListFuture to prevent LateInitializationError
    _matchingListFuture = Future.value([]);

    // Restore previous city filter from Provider
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);
    final city = filterProvider.selectedCity;
    final country = filterProvider.selectedCountry;
    final lat = filterProvider.latitude;
    final lng = filterProvider.longitude;
    final radius = filterProvider.radius;

    if ((city != null && city.isNotEmpty) && (country != null && country.isNotEmpty)) {
      _textEditingController = TextEditingController(text: "$city, $country");
    } else if (lat != null && lng != null && radius != null) {
      _textEditingController = TextEditingController(text: "Autour de moi");
    } else {
      _textEditingController = TextEditingController(text: "");
    }

    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    _textEditingController.addListener(_onTextChanged);

    // Fetch experiences after restoring filters
    Future.delayed(Duration.zero, () {
      _fetchMatchingExperiences();
    });
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

    if (_textEditingController.text.isEmpty) {
      final filterProvider = Provider.of<FilterProvider>(context, listen: false);
      filterProvider.updateCity('', '');
      filterProvider.updateLocationFilters(null, null, null);
    }
  }

  void _onCitySelected(String? city, String? country) {
    if (city != null && city.isNotEmpty) {
      Provider.of<FilterProvider>(context, listen: false).updateCity(city, country ?? '');
      Provider.of<FilterProvider>(context, listen: false).updateLocationFilters(null, null, null);
      _fetchMatchingExperiences();
    }
  }

  void _fetchMatchingExperiences() async {
    final filters = Provider.of<FilterProvider>(context, listen: false);

    print("Fetching experiences with filters: ${filters.selectedCity}, ${filters.selectedCountry}, ${filters.startDate}, ${filters.endDate}");
    print("Filters: ${filters.nbAdultes}, ${filters.nbEnfants}, ${filters.nbBebes}, ${filters.prixMin}, ${filters.prixMax}, ${filters.categorie}, ${filters.langue}, ${filters.latitude}, ${filters.longitude}, ${filters.radius}");

    try {
      final experiences = await AppService.api.fetchExperiences(
        FiltersRequest(
          filtreVille: filters.selectedCity,
          filtrePays: filters.selectedCountry,
          filtreDateDebut: filters.startDate,
          filtreDateFin: filters.endDate,
          filtreNbAdult: filters.nbAdultes,
          filtreNbEnfant: filters.nbEnfants,
          filtreNbBebes: filters.nbBebes,
          filtrePrixMin: filters.prixMin,
          filtrePrixMax: filters.prixMax,
          filtreCategorie: filters.categorie,
          filtreLangue: filters.langue,
          filtreLat: filters.latitude?.toString(),
          filtreLang: filters.longitude?.toString(),
          filtreDistance: filters.radius?.toString(),
        ),
      );

      print("Received ${experiences.length} experiences");

      setState(() {
        _matchingListFuture = Future.value(experiences);
      });
    } catch (e) {
      print("Error fetching experiences: $e");
    }
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
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.no_experience_city_text,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppResources.colorGray100,
                    ),
                  ),
                ),
              );
            }

            return Stack(
              children: [
                snapshot.data!.isNotEmpty
                ? Container(
                  width: size.width,
                  height: size.height,
                  child: AbsorbPointer(
                    absorbing: tappedScreen,
                    child: Swiper(
                      itemBuilder: (BuildContext context,int index){
                        return GuideProfileCard(
                          experienceData: snapshot.data![index],
                          onCardTapped: (tapped) {
                            setState(() {
                              tappedScreen = tapped;
                            });
                          },
                          favorKey: widget.favorKey,
                          percentKey: widget.percentKey,
                        );
                      },
                      itemCount: snapshot.data!.length,
                      control: SwiperControl(),
                      fade: 1,
                      curve: Curves.ease,
                      scale: 0.8,
                      customLayoutOption: CustomLayoutOption(startIndex: -1, stateCount: 3)
                        ..addRotate([-25.0 / 180, 0.0, 25.0 / 180])
                        ..addTranslate(
                          [
                            const Offset(-350.0, 0.0),
                            Offset.zero,
                            const Offset(350.0, 0.0),
                          ],
                        ),
                    ),
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.no_experience_city_text,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppResources.colorGray100,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 45,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: ResponsiveSize.calculateWidth(200, context),
                        //height: 40,
                        child: SingleChildScrollView(
                          child: NetworkSearchField(
                            controller: _textEditingController,
                            focusNode: _focusNode,
                            onCitySelected: _onCitySelected,
                            searchCityKey: widget.searchCityKey,
                            onSubmitted: (value) {
                              _fetchMatchingExperiences(); // 👈 only triggered on keyboard submit
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: ResponsiveSize.calculateWidth(10, context),),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppResources.colorWhite,
                          borderRadius: BorderRadius.circular(ResponsiveSize.calculateCornerRadius(30, context)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              key: widget.aroundMeKey,
                              onPressed: () async {
                                final result = await showModalBottomSheet<Map<String, dynamic>>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return PositionFiltred();
                                  },
                                );
                                if (result != null) {
                                  final filterProvider = Provider.of<FilterProvider>(context, listen: false);
                                  filterProvider.updateCity("", ""); // Clear city and country
                                  filterProvider.updateLocationFilters(
                                    result['latitude'],
                                    result['longitude'],
                                    result['radius'],
                                  );
                                  _textEditingController.text = "Autour de moi";
                                  _fetchMatchingExperiences();
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
                            Row(
                              key: widget.filtersKey,
                              children: [
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
                                      if (result.containsKey('rangeStart') && result.containsKey('rangeEnd')) {
                                        Provider.of<FilterProvider>(context, listen: false).updateDateRange(
                                          result['rangeStart'],
                                          result['rangeEnd'],
                                        );
                                        _fetchMatchingExperiences();
                                      }
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
                                      final filtreNbAdultes = result['filtre_nb_adultes'] ?? "0";
                                      final filtreNbEnfants = result['filtre_nb_enfants'] ?? "0";
                                      final filtreNbBebes = result['filtre_nb_bebes'] ?? "0";
                                      final filtrePrixMin = result['filtre_prix_min'] ?? "0";
                                      final filtrePrixMax = result['filtre_prix_max'] ?? "0";
                                      final filtreCategorie = result['filtre_categorie'] ?? "";
                                      final filtreLangue = result['filtre_langue'] ?? "";

                                      Provider.of<FilterProvider>(context, listen: false).updateFilters(
                                        nbAdultes: filtreNbAdultes,
                                        nbEnfants: filtreNbEnfants,
                                        nbBebes: filtreNbBebes,
                                        prixMin: filtrePrixMin,
                                        prixMax: filtrePrixMax,
                                        categorie: filtreCategorie,
                                        langue: filtreLangue,
                                      );
                                      _fetchMatchingExperiences();
                                    }
                                  },
                                  icon: const Icon(Icons.tune, size: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        )
      ),
    );
  }
}