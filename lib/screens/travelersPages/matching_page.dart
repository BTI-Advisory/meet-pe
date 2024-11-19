import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:meet_pe/utils/_utils.dart';
import 'package:meet_pe/widgets/_widgets.dart';
import 'package:meet_pe/widgets/guide_profile_card.dart';

import '../../models/guide_profile_data_response.dart';

class MatchingPage extends StatefulWidget {
  const MatchingPage({super.key});

  @override
  State<MatchingPage> createState() => _MatchingPageState();
}

class _MatchingPageState extends State<MatchingPage> {
  late List<GuideProfileDataResponse> listOfProfile;
  late List<GuideProfileDataResponse> filteredListOfProfile;
  TextEditingController editingController = TextEditingController();
  late List<GuideProfileCard> cards;

  late FocusNode _focusNode;
  late TextEditingController _textEditingController;
  bool _showButton = false;
  bool tappedScreen = false;

  @override
  void initState() {
    super.initState();
    listOfProfile = [
      const GuideProfileDataResponse(
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
      const GuideProfileDataResponse(
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
      const GuideProfileDataResponse(
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
    filteredListOfProfile = List.from(listOfProfile);

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
      //_showButton = _focusNode.hasFocus && _textEditingController.text.isEmpty;
      _showButton = _focusNode.hasFocus;
    });
  }

  void _onTextChanged() {
    setState(() {
      _showButton = _focusNode.hasFocus && _textEditingController.text.isEmpty;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateCards();
  }

  void _updateCards() {
    setState(() {
      if (filteredListOfProfile.isEmpty) {
        cards = [
          GuideProfileCard(
            guideProfileResponse: GuideProfileDataResponse(
              id: 0,
              title: 'No results found',
              description: '',
              duration: '',
              aboutGuide: '',
              pricePerTraveler: '',
              numberOfTravelers: 0,
              city: '',
              address: '',
              postalCode: '',
              createdAt: '',
              updatedAt: '',
              status: '',
              userId: 0,
              country: '',
              categories: [],
              guideParticipants: [],
              etAvecCa: [],
              isOnline: false,
              isProfessionalGuide: false,
              guideDescription: '',
              guideName: '',
              mainPhoto: '',
              image0: '',
            ),
            onCardTapped: (profile) {
              // Handle no results card tap if needed
              print('No results card tapped');
            },
          )
        ];
      } else {
        cards = filteredListOfProfile.map((profile) => GuideProfileCard(guideProfileResponse: profile, onCardTapped: (tapped ) {
          setState(() {
            tappedScreen = tapped;
          });
          },)).toList();
      }
    });
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      setState(() {
        filteredListOfProfile = listOfProfile
            .where((profile) => profile.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
        _updateCards();
      });
    } else {
      setState(() {
        filteredListOfProfile = List.from(listOfProfile);
        _updateCards();
      });
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
        body: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height,
              child: AbsorbPointer(
                absorbing: tappedScreen,
                child: CardSwiper(
                  cardsCount: cards.length,
                  cardBuilder: (context, index, percentThresholdX, percentThresholdY) => cards[index],
                  allowedSwipeDirection: AllowedSwipeDirection.symmetric(vertical: false, horizontal: true),
                  padding: const EdgeInsets.all(0),
                  numberOfCardsDisplayed: 1,
                ),
              ),
            ),
            Positioned(
              top: 40,
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
                        ),
                      ),
                      /*child: TextField(
                        onChanged: (value) {
                          filterSearchResults(value);
                        },
                        controller: editingController,
                        decoration: const InputDecoration(
                          hintText: "Recherche des expériences",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide(color: Colors.transparent), // Default border color
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide(color: Colors.transparent), // Border color when enabled
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide(color: Colors.transparent), // Border color when focused
                          ),
                        ),
                      ),*/
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

                              if (result == true) {
                                //_scrollToEnd();
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
                              final result = await showModalBottomSheet<bool>(
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return CalendarMatching();
                                },
                              );

                              if (result == true) {
                                //_scrollToEnd();
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
                              final result = await showModalBottomSheet<bool>(
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return FiltredWidget();
                                },
                              );

                              if (result == true) {
                                //_scrollToEnd();
                              }
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
        ),
      ),
    );
  }
}