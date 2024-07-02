import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:meet_pe/models/experience_data_response.dart';
import 'package:meet_pe/screens/guideProfilPages/experiencePages/edit_about_page.dart';
import 'package:meet_pe/screens/guideProfilPages/experiencePages/edit_description_page.dart';
import 'package:widget_mask/widget_mask.dart';

import '../../../models/modify_experience_data_model.dart';
import '../../../resources/resources.dart';
import '../../../services/app_service.dart';
import '../../../utils/_utils.dart';
import '../../../widgets/_widgets.dart';
import 'edit_photo_page.dart';
import 'edit_price_page.dart';

class EditExperiencePage extends StatefulWidget {
  const EditExperiencePage({super.key, required this.experienceId, required this.isOnline});
  final int experienceId;
  final bool isOnline;

  @override
  State<EditExperiencePage> createState() => _EditExperiencePageState();
}

class _EditExperiencePageState extends State<EditExperiencePage> {
  bool onLine = true;
  late Future<ExperienceDataResponse> _experienceDataFuture;
  String selectedImagePath = 'images/imageTest.png';
  bool updateOnline = false;
  bool updatePhoto = false;
  ModifyExperienceDataModel data = ModifyExperienceDataModel();

  @override
  void initState() {
    super.initState();
    _experienceDataFuture = AppService.api.getExperienceDetail(widget.experienceId);
    onLine = widget.isOnline;
  }

  Future<void> _updateExperienceOnline(int experienceID, bool isOnline) async {
    try {
      final update = await AppService.api.updateExperienceOnline(experienceID, isOnline);
    } catch (e) {
      // Handle error
      print('Error update exp online: $e');
    }
  }

  Future<void> _deleteExperience(int experienceID) async {
    try {
      final delete = await AppService.api.deleteExperience(experienceID);
    } catch (e) {
      // Handle error
      print('Error update exp image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EpAppBar(
        title: 'Mode Edition',
        actions: [
          Text(
              onLine ? 'En ligne' : 'Hors ligne',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 12, color: AppResources.colorDark)),
          Switch.adaptive(
            value: onLine,
            activeColor: AppResources.colorVitamine,
            onChanged: (bool value) {
              setState(() {
                onLine = value;
                updateOnline = true;
              });
            },
          )
        ],
      ),
      body: FutureBuilder<ExperienceDataResponse>(
        future: _experienceDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final experienceData = snapshot.data!;
            return Stack(children: [
              SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-0.00, -1.00),
                      end: Alignment(0, 1),
                      colors: [Color(0x00F8F3EC), AppResources.colorBeigeLight],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        WidgetMask(
                          blendMode: BlendMode.srcATop,
                          childSaveLayer: true,
                          mask: Stack(
                            children: [
                              Container(
                                width: ResponsiveSize.calculateWidth(375, context),
                                height: ResponsiveSize.calculateHeight(576, context),
                                child: Stack(
                                  children: [
                                    /// Image principal
                                    Positioned(
                                      left: -36,
                                      top: 0,
                                      bottom: 0,
                                      child: Container(
                                        width: ResponsiveSize.calculateWidth(
                                            427, context),
                                        height: 592,
                                        child: updatePhoto ? Image.asset(data.imagePrincipale ?? selectedImagePath, fit: BoxFit.cover) : Image.network(experienceData.photoPrincipal.photoUrl, fit: BoxFit.cover)
                                      ),
                                    ),

                                    /// Shadow bottom
                                    Positioned(
                                      left: 0,
                                      top: 60,
                                      bottom: 0,
                                      child: Container(
                                        width: ResponsiveSize.calculateWidth(
                                            375, context),
                                        height: 532,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment(-0.00, -1.00),
                                            end: Alignment(0, 1),
                                            colors: [
                                              Colors.black.withOpacity(0),
                                              Colors.black
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    /// Edit picture button
                                    Positioned(
                                      top: 280,
                                      right: 28,
                                      child: editButton(onTap: () async {
                                        print('Edit image');
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const EditPhotoPage()),
                                        );
                                        if (result != null) {
                                          setState(() {
                                            if (result.containsKey('image_principale')) {
                                              data.imagePrincipale = result['image_principale'];
                                              updatePhoto = true;
                                            }
                                            if (result.containsKey('image_0')) {
                                              data.image1 = result['image_0'];
                                            }
                                            if (result.containsKey('image_1')) {
                                              data.image2 = result['image_1'];
                                            }
                                            if (result.containsKey('image_2')) {
                                              data.image3 = result['image_2'];
                                            }
                                            if (result.containsKey('image_3')) {
                                              data.image4 = result['image_3'];
                                            }
                                            if (result.containsKey('image_4')) {
                                              data.image5 = result['image_4'];
                                            }
                                            print('Return photo $result');
                                          });
                                        }
                                      }),
                                    ),
                                  ],
                                ),
                              ),

                              ///bloc info in the bottom
                              Positioned(
                                top: 425,
                                left: 28,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Recommandé à',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                          color: AppResources.colorBeigeLight),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '88 %',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                              fontSize: 32,
                                              color:
                                              AppResources.colorBeigeLight),
                                        ),
                                        SizedBox(
                                            width: ResponsiveSize.calculateWidth(
                                                11, context)),
                                        Container(
                                          width: ResponsiveSize.calculateWidth(
                                              85, context),
                                          height: 28,
                                          decoration: ShapeDecoration(
                                            color: AppResources.colorVitamine,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  ResponsiveSize
                                                      .calculateCornerRadius(
                                                      20, context)),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              experienceData.categorie[0],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(
                                                  fontSize: 12,
                                                  color: AppResources.colorWhite),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width: ResponsiveSize.calculateWidth(
                                                11, context)),
                                        Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Container(
                                              width: ResponsiveSize.calculateWidth(
                                                  85, context),
                                              height: 28,
                                              decoration: ShapeDecoration(
                                                color: AppResources.colorWhite,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(
                                                      ResponsiveSize
                                                          .calculateCornerRadius(
                                                          20, context)),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '${data.prixParVoyageur ?? experienceData.prixParVoyageur}€/pers',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.copyWith(
                                                      fontSize: 12,
                                                      color:
                                                      AppResources.colorDark),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: -18,
                                              right: 10,
                                              child: editButton(onTap: () async {
                                                print('Edit price');
                                                final result = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => const EditPricePage()),
                                                );
                                                if (result != null) {
                                                  setState(() {
                                                    if (result.containsKey('prix_par_voyageur')) {
                                                      data.prixParVoyageur = result['prix_par_voyageur'] as int?;
                                                    }
                                                    if (result.containsKey('discount_kids_between_2_and_12')) {
                                                      data.discountKidsBetween2And12 = result['discount_kids_between_2_and_12'];
                                                    }
                                                    if (result.containsKey('max_number_of_persons')) {
                                                      data.numberVoyageur = result['max_number_of_persons'];
                                                    }
                                                    if (result.containsKey('price_group_prive')) {
                                                      data.priceGroupPrive = result['price_group_prive'];
                                                    }
                                                  });
                                                }
                                              }),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        IntrinsicWidth(
                                          child: Container(
                                            height: 28,
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                ResponsiveSize.calculateWidth(
                                                    12, context)),
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(20)),
                                              border: Border.all(
                                                  color:
                                                  AppResources.colorBeigeLight),
                                            ),
                                            child: Center(
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                      'images/icon_verified.png'),
                                                  SizedBox(
                                                      width: ResponsiveSize
                                                          .calculateWidth(
                                                          4, context)),
                                                  Text(
                                                    'Vérifié',
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.copyWith(
                                                      color: AppResources
                                                          .colorBeigeLight,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width: ResponsiveSize.calculateWidth(
                                                8, context)),
                                        if(experienceData.guideIsPro)
                                        IntrinsicWidth(
                                          child: Container(
                                            height: 28,
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                ResponsiveSize.calculateWidth(
                                                    12, context)),
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(20)),
                                              border: Border.all(
                                                  color:
                                                  AppResources.colorBeigeLight),
                                            ),
                                            child: Center(
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                      'images/icon_badge.png'),
                                                  SizedBox(
                                                      width: ResponsiveSize
                                                          .calculateWidth(
                                                          4, context)),
                                                  Text(
                                                    'Pro',
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.copyWith(
                                                      color: AppResources
                                                          .colorBeigeLight,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        if(experienceData.guideIsPro)
                                        SizedBox(
                                            width: ResponsiveSize.calculateWidth(
                                                8, context)),
                                        IntrinsicWidth(
                                          child: Container(
                                            height: 28,
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                ResponsiveSize.calculateWidth(
                                                    12, context)),
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(20)),
                                              border: Border.all(
                                                  color:
                                                  AppResources.colorBeigeLight),
                                            ),
                                            child: Center(
                                              child: Row(
                                                children: [
                                                  Image.asset('images/icon_star.png'),
                                                  SizedBox(
                                                      width: ResponsiveSize
                                                          .calculateWidth(
                                                          4, context)),
                                                  Text(
                                                    '4,75/5 (120)',
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.copyWith(
                                                      color: AppResources
                                                          .colorBeigeLight,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'images/background_mask.png',
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: ResponsiveSize.calculateWidth(319, context),
                          child: Text(
                            experienceData.title,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                fontSize: 32, color: AppResources.colorDark),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            SizedBox(
                              width: ResponsiveSize.calculateWidth(319, context),
                              child: Opacity(
                                opacity: 0.50,
                                child: Text(
                                  data.description ?? experienceData.description,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppResources.colorDark),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: editButton(onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => EditDescriptionPage()),
                                );
                                if (result != null) {
                                  setState(() {
                                    data.description = result;
                                    print('Return description $result');
                                  });
                                }
                              }),
                            )
                          ],
                        ),
                        const SizedBox(height: 63),
                        Container(
                          padding: const EdgeInsets.only(
                            top: 28,
                            left: 28,
                            right: 28,
                            bottom: 40,
                          ),
                          decoration: const ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 318,
                                child: Text(
                                  'Un mot sur ${experienceData.nameGuide}',
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 32, color: AppResources.colorVitamine),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  SizedBox(
                                    width: 319,
                                    child: Text(
                                      data.aboutGuide ?? experienceData.aboutGuide,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorGray60),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: editButton(onTap: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const EditAboutPage()),
                                      );
                                      if (result != null) {
                                        setState(() {
                                          data.aboutGuide = result;
                                          print('Return about $result');
                                        });
                                      }
                                    }),
                                  )
                                ]
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 34),
                        StaggeredGrid.count(
                          crossAxisCount: 4,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          children: [
                            if (updatePhoto ? data.image1 != null : experienceData.image0 != null)
                              StaggeredGridTile.count(
                                crossAxisCellCount: 4,
                                mainAxisCellCount: 2,
                                child: updatePhoto ? Image.asset(data.image1 ?? selectedImagePath, fit: BoxFit.cover) : Image.network(experienceData.image0?.photoUrl ?? '', fit: BoxFit.cover),
                              ),
                            if (updatePhoto ? data.image2 != null : experienceData.image1 != null)
                              StaggeredGridTile.count(
                                crossAxisCellCount: 4,
                                mainAxisCellCount: 2,
                                child: updatePhoto ? Image.asset(data.image2 ?? selectedImagePath, fit: BoxFit.cover) : Image.network(experienceData.image1?.photoUrl ?? '', fit: BoxFit.cover),
                              ),
                            if (updatePhoto ? data.image3 != null : experienceData.image2 != null)
                              StaggeredGridTile.count(
                                crossAxisCellCount: 4,
                                mainAxisCellCount: 2,
                                child: updatePhoto ? Image.asset(data.image3 ?? selectedImagePath, fit: BoxFit.cover) : Image.network(experienceData.image2?.photoUrl ?? '', fit: BoxFit.cover),
                              ),
                            if (updatePhoto ? data.image4 != null : experienceData.image3 != null)
                              StaggeredGridTile.count(
                                crossAxisCellCount: 4,
                                mainAxisCellCount: 2,
                                child: updatePhoto ? Image.asset(data.image4 ?? selectedImagePath, fit: BoxFit.cover) : Image.network(experienceData.image3?.photoUrl ?? '', fit: BoxFit.cover),
                              ),
                            if (updatePhoto ? data.image5 != null : experienceData.image4 != null)
                              StaggeredGridTile.count(
                                crossAxisCellCount: 4,
                                mainAxisCellCount: 2,
                                child: updatePhoto ? Image.asset(data.image5 ?? selectedImagePath, fit: BoxFit.cover) : Image.network(experienceData.image4?.photoUrl ?? '', fit: BoxFit.cover),
                              ),
                          ],
                        ),
                        const SizedBox(height: 70),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 13.0),
                  color: Colors.white,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: ResponsiveSize.calculateWidth(160, context),
                          height: 44,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.symmetric(
                                      horizontal:
                                      ResponsiveSize.calculateWidth(24, context),
                                      vertical: 12)),
                              backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                  return AppResources.colorWhite;
                                },
                              ),
                              shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                            ),
                            onPressed: () {
                              _deleteExperience(widget.experienceId);
                              Navigator.pop(context);
                            },
                            child: Text(
                              'SUPPRIMER',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: AppResources.colorVitamine),
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                        Container(
                          width: ResponsiveSize.calculateWidth(160, context),
                          height: 44,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.symmetric(
                                      horizontal:
                                      ResponsiveSize.calculateWidth(24, context),
                                      vertical: 12)),
                              backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                  return AppResources.colorVitamine;
                                },
                              ),
                              shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              data.experienceId = widget.experienceId;
                              //data.title = 'Le Paris de Maria en deux lignes ';
                              await AppService.api.updateDataExperience(data);
                              Navigator.maybePop(context);
                            },
                            child: Text(
                              'ENREGISTRER',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: AppResources.colorWhite),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ]);
          }
        },
      )
    );
  }
}

class editButton extends StatelessWidget {
  const editButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        padding: const EdgeInsets.all(10),
        decoration: ShapeDecoration(
          color: AppResources.colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x19FF4D00),
              blurRadius: 3,
              offset: Offset(0, 1),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x16FF4D00),
              blurRadius: 5,
              offset: Offset(0, 5),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x0CFF4D00),
              blurRadius: 6,
              offset: Offset(0, 10),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x02FF4D00),
              blurRadius: 7,
              offset: Offset(0, 18),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x00FF4D00),
              blurRadius: 8,
              offset: Offset(0, 29),
              spreadRadius: 0,
            )
          ],
        ),
        child: Image.asset('images/pen_icon.png'),
      ),
    );
  }
}
