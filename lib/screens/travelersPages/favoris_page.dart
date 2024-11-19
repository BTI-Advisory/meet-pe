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
        title: 'Balade Gourmande',
        description:
        "Je vous emmène pendant environ 2h autour du vieux port pour vous raconter des petites histoires qui ont fait la grande. On passe dans les petites rues et on découvre les petites anecdotes de la ville. Puis on finit la balade à la plage pour une dégustation de produits locaux. Avec ou sans alcool et option végétarien possible.",
        duration: '3',
        aboutGuide:
        "Je suis natif de la ville. Je souhaite vous faire avoir une expérience où vous sortirez de là et vous vous direz ''génial, pendant 1 journée j'ai eu l'impression d'être rochelais''.",
        pricePerTraveler: '32',
        numberOfTravelers: 4,
        city: '',
        address: '',
        postalCode: '',
        createdAt: '',
        updatedAt: '',
        status: 'Accepté',
        userId: 12,
        country: '',
        categories: ['Exploration Urbaine'],
        guideParticipants: [''],
        etAvecCa: [''],
        isOnline: true,
        isProfessionalGuide: true,
        guideDescription:
        "Je suis natif de la ville. Je souhaite vous faire avoir une expérience où vous sortirez de là et vous vous direz 'génial, pendant 1 journée j'ai eu l'impression d'être rochelais.'.",
        guideName: 'Alexandre',
        mainPhoto:
        'https://www.meetpe.fr//experiences/66e31d90d6015received_593085006281053.jpg',
        image0:
        'https://www.meetpe.fr//experiences/66f1cd1ab031dimage_picker_08128290-E2D7-431D-B2A2-4DA31FDCFB76-6518-0000010B90C44FC4.jpg',
        image1:
        'https://www.meetpe.fr//experiences/66c30131434bd1000000143.jpg',
      ),
      const FavorisDataResponse(
        id: 12,
        title: 'Dégustation de fromages et vins dans une cave secrète!',
        description:
        "Dans une cave secrète du 17éme siècle, au sein d'une fromagerie familiale multi-centenaire, vous savourerez une expérience unique de dégustation. Un sommelier vous présentera des vins raffinés chacun associé à un fromage artisanal affiné sur place. Les arômes et les textures s'entremêleront, révélant une harmonie parfaite des saveurs, dans une ambiance intime et authentique !",
        duration: '3',
        aboutGuide:
        "WeTasteParis, c'est Aurélien et Andrés, deux sommeliers associés, avec chacun 10 ans d'expérience dans la restauration en France et à l'étranger. Ils ont mis leur passion au service des amateurs de gastronomie afin de leur faire découvrir dans un cadre insolite et convivial les plaisirs gustatifs que Paris a à leur offrir.",
        pricePerTraveler: '85',
        numberOfTravelers: 4,
        city: '',
        address: '',
        postalCode: '',
        createdAt: '',
        updatedAt: '',
        status: 'Accepté',
        userId: 12,
        country: '',
        categories: ['Autour de la Food'],
        guideParticipants: [''],
        etAvecCa: [''],
        isOnline: true,
        isProfessionalGuide: true,
        guideDescription:
        "Lorem ipsum dolor sit amet, consectetur adipe iscijd elit, sed do eiusmod tempor incididunt ut labore etsi dolore magna aliqua. Ut enim adipsd minim estedgj veniam, quis nostrud exercitation esteil ullamco astr labor commodou consequat.",
        guideName: 'Aurelien',
        mainPhoto:
        'https://www.meetpe.fr//experiences/66b23c98a5b871000021361.jpg',
        image0:
        'https://www.meetpe.fr//experiences/66b23c98a0cab1000021364.jpg',
        image1:
        'https://www.meetpe.fr//experiences/66b23c98a374b1000021365.jpg',
        image2:
        'https://www.meetpe.fr//experiences/66b23c98a423d1000021366.jpg',
      ),
      const FavorisDataResponse(
        id: 12,
        title: 'Passion Moto',
        description:
        "Je propose une sortie Moto Trail découverte des sentiers TET en région parisienne. Basé dans le secteur 92/78 je prévois une sortie de 4h sur la sortie TET 8. Débutants ou confirmés sont bienvenus. Venez passer un moment de partage convivial et découvrez le trail moto. !",
        duration: '3',
        aboutGuide:
        "Je m'appelle Mick j'ai 40 ans passés, je suis sportif et actif, j'aime passée de bons moments et faire des rencontres en partageant ma passion.",
        pricePerTraveler: '45',
        numberOfTravelers: 4,
        city: '',
        address: '',
        postalCode: '',
        createdAt: '',
        updatedAt: '',
        status: 'Accepté',
        userId: 12,
        country: '',
        categories: ['Activités Mécaniques'],
        guideParticipants: [''],
        etAvecCa: [''],
        isOnline: true,
        isProfessionalGuide: true,
        guideDescription:
        "Lorem ipsum dolor sit amet, consectetur adipe iscijd elit, sed do eiusmod tempor incididunt ut labore etsi dolore magna aliqua. Ut enim adipsd minim estedgj veniam, quis nostrud exercitation esteil ullamco astr labor commodou consequat.",
        guideName: 'Michael',
        mainPhoto:
        'https://www.meetpe.fr//experiences/66bc9135243361000004905.jpg',
        image0:
        'https://www.meetpe.fr//experiences/66bc91352b4b71000055636.jpg',
        image1:
        'https://www.meetpe.fr//experiences/66bc91352a1021000004906.jpg',
        image2:
        'https://www.meetpe.fr//experiences/66bc9135257481000004902.jpg',
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
