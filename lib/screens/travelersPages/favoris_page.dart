import 'package:flutter/material.dart';

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
  late List<FavorisDataResponse> duplicateItems;
  late List<FavorisDataResponse> items;

  @override
  void initState() {
    super.initState();
    // Initialize the list of FavorisDataResponse items
    duplicateItems = [
      const FavorisDataResponse(
        id: 12,
        title: 'Le Paris de Maria en deux lignes',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipe iscijd elit, sed do eiusmod tempor incididunt ut labore etsi dolore magna aliqua. Ut enim adipsd minim estedgj veniam, quis nostrud exercitation esteil ullamco astr labor commodou consequat.',
        duration: '3',
        aboutGuide:
            "Le Lorem Ipsum est simplement du faux texte employé dans la composition et la mise en page avant impression. Le Lorem Ipsum est le faux texte standard de l'imprimerie depuis les années 1500, quand un imprimeur anonyme assembla ensemble des morceaux de texte pour réaliser un livre spécimen de polices de texte. Il n'a pas fait que survivre cinq siècles, mais s'est aussi adapté à la bureautique informatique, sans que son contenu n'en soit modifié. Il a été popularisé dans les années 1960 grâce à la vente de feuilles Letraset contenant des passages du Lorem Ipsum, et, plus récemment, par son inclusion dans des applications de mise en page de texte, comme Aldus PageMaker.",
        pricePerTraveler: '120',
        numberOfTravelers: 4,
        city: '',
        address: '',
        postalCode: '',
        createdAt: '',
        updatedAt: '',
        status: 'Accepté',
        userId: 12,
        country: '',
        categories: ['Aventurier'],
        guideParticipants: [''],
        etAvecCa: [''],
        isOnline: true,
        isProfessionalGuide: true,
        guideDescription:
            "Lorem ipsum dolor sit amet, consectetur adipe iscijd elit, sed do eiusmod tempor incididunt ut labore etsi dolore magna aliqua. Ut enim adipsd minim estedgj veniam, quis nostrud exercitation esteil ullamco astr labor commodou consequat.",
        guideName: 'Maria',
        mainPhoto:
            'https://www.meetpe.fr//user_profile/669fc7d02049aimage_picker_D2F0CDF9-2732-4B83-B4A7-7F4C7E97C230-77723-000001233A7AAB01.jpg',
        image0:
            'https://www.meetpe.fr//user_profile/669fc7d02049aimage_picker_D2F0CDF9-2732-4B83-B4A7-7F4C7E97C230-77723-000001233A7AAB01.jpg',
      ),
      const FavorisDataResponse(
        id: 12,
        title: 'Baha experience',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipe iscijd elit, sed do eiusmod tempor incididunt ut labore etsi dolore magna aliqua. Ut enim adipsd minim estedgj veniam, quis nostrud exercitation esteil ullamco astr labor commodou consequat.',
        duration: '3',
        aboutGuide:
            "Le Lorem Ipsum est simplement du faux texte employé dans la composition et la mise en page avant impression. Le Lorem Ipsum est le faux texte standard de l'imprimerie depuis les années 1500, quand un imprimeur anonyme assembla ensemble des morceaux de texte pour réaliser un livre spécimen de polices de texte. Il n'a pas fait que survivre cinq siècles, mais s'est aussi adapté à la bureautique informatique, sans que son contenu n'en soit modifié. Il a été popularisé dans les années 1960 grâce à la vente de feuilles Letraset contenant des passages du Lorem Ipsum, et, plus récemment, par son inclusion dans des applications de mise en page de texte, comme Aldus PageMaker.",
        pricePerTraveler: '120',
        numberOfTravelers: 4,
        city: '',
        address: '',
        postalCode: '',
        createdAt: '',
        updatedAt: '',
        status: 'Accepté',
        userId: 12,
        country: '',
        categories: ['Aventurier'],
        guideParticipants: [''],
        etAvecCa: [''],
        isOnline: true,
        isProfessionalGuide: true,
        guideDescription:
            "Lorem ipsum dolor sit amet, consectetur adipe iscijd elit, sed do eiusmod tempor incididunt ut labore etsi dolore magna aliqua. Ut enim adipsd minim estedgj veniam, quis nostrud exercitation esteil ullamco astr labor commodou consequat.",
        guideName: 'Maria',
        mainPhoto:
            'https://www.meetpe.fr//user_profile/669fc7d02049aimage_picker_D2F0CDF9-2732-4B83-B4A7-7F4C7E97C230-77723-000001233A7AAB01.jpg',
        image0:
            'https://www.meetpe.fr//user_profile/669fc7d02049aimage_picker_D2F0CDF9-2732-4B83-B4A7-7F4C7E97C230-77723-000001233A7AAB01.jpg',
      ),
      const FavorisDataResponse(
        id: 12,
        title: 'Alex experience',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipe iscijd elit, sed do eiusmod tempor incididunt ut labore etsi dolore magna aliqua. Ut enim adipsd minim estedgj veniam, quis nostrud exercitation esteil ullamco astr labor commodou consequat.',
        duration: '3',
        aboutGuide:
            "Le Lorem Ipsum est simplement du faux texte employé dans la composition et la mise en page avant impression. Le Lorem Ipsum est le faux texte standard de l'imprimerie depuis les années 1500, quand un imprimeur anonyme assembla ensemble des morceaux de texte pour réaliser un livre spécimen de polices de texte. Il n'a pas fait que survivre cinq siècles, mais s'est aussi adapté à la bureautique informatique, sans que son contenu n'en soit modifié. Il a été popularisé dans les années 1960 grâce à la vente de feuilles Letraset contenant des passages du Lorem Ipsum, et, plus récemment, par son inclusion dans des applications de mise en page de texte, comme Aldus PageMaker.",
        pricePerTraveler: '120',
        numberOfTravelers: 4,
        city: '',
        address: '',
        postalCode: '',
        createdAt: '',
        updatedAt: '',
        status: 'Accepté',
        userId: 12,
        country: '',
        categories: ['Aventurier'],
        guideParticipants: [''],
        etAvecCa: [''],
        isOnline: true,
        isProfessionalGuide: true,
        guideDescription:
            "Lorem ipsum dolor sit amet, consectetur adipe iscijd elit, sed do eiusmod tempor incididunt ut labore etsi dolore magna aliqua. Ut enim adipsd minim estedgj veniam, quis nostrud exercitation esteil ullamco astr labor commodou consequat.",
        guideName: 'Maria',
        mainPhoto:
            'https://www.meetpe.fr//user_profile/669fc7d02049aimage_picker_D2F0CDF9-2732-4B83-B4A7-7F4C7E97C230-77723-000001233A7AAB01.jpg',
        image0:
            'https://www.meetpe.fr//user_profile/669fc7d02049aimage_picker_D2F0CDF9-2732-4B83-B4A7-7F4C7E97C230-77723-000001233A7AAB01.jpg',
      ),
    ];

    // Initially, display all items
    items = List.from(duplicateItems);
  }

  void filterSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        items = List.from(duplicateItems);
      } else {
        items = duplicateItems
            .where((item) =>
                item.title.toLowerCase().contains(query.toLowerCase()))
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
                  children: items.isEmpty
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
                          items.length,
                          (index) => GestureDetector(
                            onTap: () {
                              navigateTo(
                                  context,
                                  (_) => FavorisDetailPage(
                                      favorisResponse: items[index]));
                            },
                            child: FavorisCard(favorisResponse: items[index]),
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
