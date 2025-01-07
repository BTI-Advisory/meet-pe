import 'package:flutter/material.dart';
import 'package:meet_pe/services/app_service.dart';

import '../../models/favoris_data_response.dart';
import '../../resources/resources.dart';
import '../../utils/_utils.dart';
import 'package:meet_pe/widgets/_widgets.dart';
import 'favoris_detail_page.dart';

class FavorisPage extends StatefulWidget {
  const FavorisPage({super.key});

  @override
  State<FavorisPage> createState() => _FavorisPageState();
}

class _FavorisPageState extends State<FavorisPage> {
  late FavorisDataResponse favorisResponse;
  TextEditingController editingController = TextEditingController();
  List<FavorisDataResponse>? initialList;
  List<FavorisDataResponse>? items;

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
            ?.where((item) =>
                item.experience.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
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
                    'Mes Favoris',
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
                    decoration: const InputDecoration(
                        labelText: "Recherche des expériences",
                        hintText: "Recherche des expériences",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30.0)))
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveSize.calculateHeight(20, context)),
                Column(
                  children: (items == null)
                      ? [
                          SizedBox(
                            height:
                                ResponsiveSize.calculateHeight(150, context),
                          ),
                          Center(
                            child: Text(
                              "Aucun favoris ? \nN’hésite pas à en ajouter ! ",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(color: AppResources.colorGray100),
                            ),
                          ),
                        ]
                      : List.generate(
                          items!.length,
                          (index) => GestureDetector(
                            onTap: () {
                              navigateTo(
                                  context,
                                  (_) => FavorisDetailPage(
                                      favorisResponse: items![index]));
                            },
                            child: FavorisCard(favorisResponse: items![index]),
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
