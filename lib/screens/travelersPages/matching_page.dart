import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:meet_pe/widgets/guide_profile_card.dart';

import '../../models/guide_profile_data_response.dart';
import '../../services/app_service.dart';

class MatchingPage extends StatefulWidget {
  const MatchingPage({super.key});

  @override
  State<MatchingPage> createState() => _MatchingPageState();
}

class _MatchingPageState extends State<MatchingPage> {
  late List<GuideProfileDataResponse> listOfProfile;

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
  }

  late List<GuideProfileCard> cards;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cards = listOfProfile.map((profile) => GuideProfileCard(guideProfileResponse: profile)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: CardSwiper(
          cardsCount: cards.length,
          cardBuilder: (context, index, percentThresholdX, percentThresholdY) => cards[index],
          allowedSwipeDirection: AllowedSwipeDirection.symmetric(vertical: false, horizontal: true),
          padding: const EdgeInsets.all(0),
        ),
      ),
    );
  }
}