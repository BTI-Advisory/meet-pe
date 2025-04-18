import 'package:flutter/material.dart';
import 'package:meet_pe/services/app_service.dart';

import '../../models/favoris_data_response.dart';
import '../../resources/resources.dart';
import '../../utils/_utils.dart';
import 'package:meet_pe/widgets/_widgets.dart';
import 'favoris_detail_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavorisPage extends StatefulWidget {
  const FavorisPage({super.key});

  @override
  State<FavorisPage> createState() => _FavorisPageState();
}

class _FavorisPageState extends State<FavorisPage> {
  late FavorisDataResponse favorisResponse;
  TextEditingController editingController = TextEditingController();
  late List<FavorisDataResponse> initialList = [];
  late List<FavorisDataResponse> items = [];

  @override
  void initState() {
    super.initState();

    loadFavoriteExperiences();
  }

  Future<void> loadFavoriteExperiences() async {
    try {
      List<FavorisDataResponse> response = await AppService.api.getFavoriteExperience();
      setState(() {
        initialList = response;
        items = response;
      });
    } catch (e) {
      debugPrint('Error loading favorite experiences: $e');
      setState(() {
        items = []; // Fallback to an empty list
      });
    }
  }

  void filterSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        items = List.from(initialList ?? []);
      } else {
        items = items
            .where((item) =>
                item.experience.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  // Callback to remove the favorite experience
  void removeFavorite(FavorisDataResponse favoris) {
    setState(() {
      // Remove the experience from both 'items' and 'initialList'
      items.removeWhere((item) => item.id == favoris.id);
      initialList.removeWhere((item) => item.id == favoris.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: deviceSize.width,
          height: deviceSize.height,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.calculateWidth(20, context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: ResponsiveSize.calculateHeight(69, context)),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveSize.calculateWidth(5, context)),
                  child: Text(
                    AppLocalizations.of(context)!.my_favorites_text,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontSize: 32, color: AppResources.colorDark),
                  ),
                ),
                SizedBox(height: ResponsiveSize.calculateHeight(20, context)),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        spreadRadius: 0,
                        blurRadius: 50,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) {
                      filterSearchResults(value);
                    },
                    controller: editingController,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.search_experience_text,
                        hintText: AppLocalizations.of(context)!.search_experience_text,
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30.0)))
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveSize.calculateHeight(20, context)),
                Column(
                  children: (items.isEmpty)
                      ? [
                          SizedBox(
                            height:
                                ResponsiveSize.calculateHeight(150, context),
                          ),
                          Center(
                            child: Text(
                              AppLocalizations.of(context)!.no_favorites_text,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(color: AppResources.colorGray100),
                            ),
                          ),
                        ]
                      : List.generate(
                          items.length,
                          (index) => GestureDetector(
                            onTap: () async {
                              final bool? shouldRefresh = await navigateTo(
                                context,
                                    (_) => FavorisDetailPage(favorisResponse: items[index]),
                              );

                              if (shouldRefresh == true) {
                                print("Refreshing favorite experiences.");
                                await loadFavoriteExperiences(); // Reload the list
                              } else {
                                print("No refresh needed.");
                              }
                            },
                            child: FavorisCard(
                              favorisResponse: items[index],
                              onRemoveFavorite: removeFavorite, // Pass the callback
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
