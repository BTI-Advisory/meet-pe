import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:meet_pe/utils/_utils.dart';
import 'package:meet_pe/widgets/_widgets.dart';
import 'package:meet_pe/widgets/guide_profile_card.dart';

import '../../models/guide_profile_data_response.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

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
  Position? _currentPosition;
  String _currentCity = '';

  @override
  void initState() {
    super.initState();
    listOfProfile = [
      const GuideProfileDataResponse(
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
      const GuideProfileDataResponse(
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
      const GuideProfileDataResponse(
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

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        print("Location permission denied");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get the city name from the position
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _currentPosition = position;
        _currentCity = placemarks.isNotEmpty
            ? placemarks[0].locality ?? "Unknown City"
            : "Unknown City";
      });
    } catch (e) {
      print(e);
    }
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
          const GuideProfileCard(
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
          )
        ];
      } else {
        cards = filteredListOfProfile.map((profile) => GuideProfileCard(guideProfileResponse: profile)).toList();
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
            child: CardSwiper(
              cardsCount: cards.length,
              cardBuilder: (context, index, percentThresholdX, percentThresholdY) => cards[index],
              allowedSwipeDirection: AllowedSwipeDirection.symmetric(vertical: false, horizontal: true),
              padding: const EdgeInsets.all(0),
              numberOfCardsDisplayed: 1,
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
                          icon: Icon(Icons.gps_fixed, size: 20,),
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
    );
  }
}