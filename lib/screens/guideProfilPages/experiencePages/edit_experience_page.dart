import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meet_pe/models/experience_data_response.dart';
import 'package:meet_pe/screens/guideProfilPages/experiencePages/edit_availabilities_page.dart';
import 'package:meet_pe/screens/guideProfilPages/experiencePages/edit_description_page.dart';
import 'package:widget_mask/widget_mask.dart';

import '../../../models/modify_experience_data_model.dart';
import '../../../resources/resources.dart';
import '../../../services/app_service.dart';
import '../../../utils/_utils.dart';
import '../../../widgets/_widgets.dart';
import 'edit_availabilities_range_date_page.dart';
import 'edit_language_page.dart';
import 'edit_photo_page.dart';
import 'edit_price_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditExperiencePage extends StatefulWidget {
  const EditExperiencePage({super.key, required this.experienceData});
  final ExperienceDataResponse experienceData;

  @override
  State<EditExperiencePage> createState() => _EditExperiencePageState();
}

class _EditExperiencePageState extends State<EditExperiencePage> {
  bool onLine = true;
  String selectedImagePath = 'images/imageTest.png';
  bool updateOnline = false;
  bool updatePhotoPrincipal = false;
  bool updatePhoto1 = false;
  bool updatePhoto2 = false;
  bool updatePhoto3 = false;
  bool updatePhoto4 = false;
  bool updatePhoto5= false;
  ModifyExperienceDataModel data = ModifyExperienceDataModel();

  @override
  void initState() {
    super.initState();
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

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirmation_text),
          content: Text(AppLocalizations.of(context)!.confirmation_desc_text),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.cancel_text),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.delete_text),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                _deleteExperience(int.parse(widget.experienceData.id)); // Delete the experience
                Navigator.maybePop(context); // Navigate back if possible
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EpAppBar(
        title: AppLocalizations.of(context)!.edit_mode_text,
        ///Todo: Remove comment and const
        /*actions: [
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
        ],*/
      ),
      body: Stack(children: [
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
                          //width: ResponsiveSize.calculateWidth(375, context),
                          //height: ResponsiveSize.calculateHeight(576, context),
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
                                    child: updatePhotoPrincipal ? Image.asset(data.imagePrincipale ?? selectedImagePath, fit: BoxFit.cover) : Image.network(widget.experienceData.photoprincipal.photoUrl, fit: BoxFit.cover)
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
                                child: editButton(
                                    onTap: () async {
                                      print('Edit image');
                                      final photos = widget.experienceData.photos ?? [];

                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditPhotoPage(
                                            imagePrincipal: widget.experienceData.photoprincipal.photoUrl,
                                            image1: photos.length > 0 ? photos[0].photoUrl ?? '' : '',
                                            image2: photos.length > 1 ? photos[1].photoUrl ?? '' : '',
                                            image3: photos.length > 2 ? photos[2].photoUrl ?? '' : '',
                                            image4: photos.length > 3 ? photos[3].photoUrl ?? '' : '',
                                            image5: photos.length > 4 ? photos[4].photoUrl ?? '' : '',
                                          ),
                                        ),
                                      );

                                      if (result != null) {
                                        setState(() {
                                          if (result.containsKey('image_principale')) {
                                            data.imagePrincipale = result['image_principale'];
                                            updatePhotoPrincipal = true;
                                          }
                                          if (result.containsKey('image_0')) {
                                            data.image1 = result['image_0'];
                                            updatePhoto1 = true;
                                          }
                                          if (result.containsKey('image_1')) {
                                            data.image2 = result['image_1'];
                                            updatePhoto2 = true;
                                          }
                                          if (result.containsKey('image_2')) {
                                            data.image3 = result['image_2'];
                                            updatePhoto3 = true;
                                          }
                                          if (result.containsKey('image_3')) {
                                            data.image4 = result['image_3'];
                                            updatePhoto4 = true;
                                          }
                                          if (result.containsKey('image_4')) {
                                            data.image5 = result['image_4'];
                                            updatePhoto5 = true;
                                          }
                                          print('Return photo $result');
                                        });
                                      }
                                    }
                                ),
                              ),
                            ],
                          ),
                        ),

                        ///bloc info in the top
                        Positioned(
                          top: 15,
                          left: 64,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: AppResources.colorVitamine),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_month, color: AppResources.colorVitamine,),
                                const SizedBox(width: 12,),
                                Column(
                                  children: [
                                    Text(
                                        AppLocalizations.of(context)!.proposed_text,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(fontWeight: FontWeight.w400, color: AppResources.colorVitamine)
                                    ),
                                    Text(
                                        AppLocalizations.of(context)!.day_short_text,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(fontWeight: FontWeight.w700, color: AppResources.colorVitamine)
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12,),
                                editButton(
                                  onTap: () async {
                                    print('Edit availabilities');
                                    print(widget.experienceData.duree);
                                    print('Edit availabilities');

                                    if(widget.experienceData.duree != "2 jours" && widget.experienceData.duree != "7 jours") {
                                      // Navigate to the EditAvailabilitiesPage and wait for the result
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditAvailabilitiesPage(
                                            planning: widget.experienceData.planning,
                                          ),
                                        ),
                                      );

                                      // Check if the result is not null and is of type ModifyExperienceDataModel
                                      if (result != null && result is ModifyExperienceDataModel) {
                                        // Update the state with the returned availabilities data
                                        setState(() {
                                          data.horaires = result.horaires;
                                        });
                                      }
                                    } else {
                                      // Navigate to the EditAvailabilitiesPage and wait for the result
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditAvailabilitiesRangeDatePage(
                                            planning: widget.experienceData.planning,
                                            duration: widget.experienceData.duree!,
                                          ),
                                        ),
                                      );

                                      // Check if the result is not null and is of type ModifyExperienceDataModel
                                      if (result != null && result is ModifyExperienceDataModel) {
                                        // Update the state with the returned availabilities data
                                        setState(() {
                                          data.horaires = result.horaires;
                                        });
                                      }
                                    }
                                  },
                                ),

                              ],
                            ),
                          ),
                        ),

                        ///bloc info in the bottom
                        Positioned(
                          left: 28,
                          bottom: 60,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 28,
                                    padding: const EdgeInsets.symmetric(horizontal: 14),
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
                                        widget.experienceData.categories[0].choix,
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
                                            '${data.prixParVoyageur ?? widget.experienceData.prixParVoyageur}€/pers',
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
                                                data.discountKidsBetween2And12 = result['discount_kids_between_2_and_12'].toString();
                                              }
                                              if (result.containsKey('max_group_size')) {
                                                data.maxNumberOfPersons = result['max_group_size'];
                                              }
                                              if (result.containsKey('price_group_prive')) {
                                                data.priceGroupPrive = result['price_group_prive'];
                                              }
                                              if (result.containsKey('support_group_prive')) {
                                                data.supportGroupPrive = result['support_group_prive'].toString();
                                              }
                                            });
                                          }
                                        }),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
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
                                            SvgPicture.asset('images/icon_verified.svg'),
                                            SizedBox(
                                                width: ResponsiveSize
                                                    .calculateWidth(
                                                    4, context)),
                                            Text(
                                              AppLocalizations.of(context)!.verified_text,
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
                                  Stack(
                                      clipBehavior: Clip.none,
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
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset('images/emoji_language.svg'),
                                                    SizedBox(width: ResponsiveSize.calculateWidth(4, context)),
                                                    ...widget.experienceData.languages.map((url) {
                                                      return Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                        child: Text(
                                                          url.svg,
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .bodyMedium
                                                              ?.copyWith(fontSize: 20),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        Positioned(
                                          top: -10,
                                          right: -15,
                                          child: editButton(onTap: () async {
                                            final result = await Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => const EditLanguagePage()),
                                            );
                                            if (result != null) {
                                              setState(() {
                                                data.experienceLanguages = result;
                                                print('Return about $result');
                                              });
                                            }
                                          }),
                                        )
                                      ]
                                  ),
                                  ///Todo remove comment when avis is ready
                                  /*if(experienceData.isProfessionalGuide)
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
                                        ),*/
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'images/background_mask1.png',
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: ResponsiveSize.calculateWidth(319, context),
                    child: Text(
                      widget.experienceData.title,
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
                            data.description ?? widget.experienceData.description,
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
                            '${AppLocalizations.of(context)!.word_for_text} ${widget.experienceData.nameGuide}',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 32, color: AppResources.colorVitamine),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: 319,
                          child: Text(
                            widget.experienceData.descriptionGuide ?? "",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorGray60),
                          ),
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
                      if (updatePhoto1
                          ? data.image1 != null
                          : widget.experienceData.photos.isNotEmpty &&
                          (widget.experienceData.photos[0].photoUrl ?? '').isNotEmpty)
                        StaggeredGridTile.fit(
                          crossAxisCellCount: 4,
                          child: updatePhoto1
                              ? Image.asset(data.image1 ?? selectedImagePath, fit: BoxFit.cover)
                              : Image.network(widget.experienceData.photos[0]!.photoUrl, fit: BoxFit.cover),
                        ),
                      if (updatePhoto2
                          ? data.image2 != null
                          : widget.experienceData.photos.length > 1 &&
                          (widget.experienceData.photos[1].photoUrl ?? '').isNotEmpty)
                        StaggeredGridTile.fit(
                          crossAxisCellCount: 4,
                          child: updatePhoto2
                              ? Image.asset(data.image2 ?? selectedImagePath, fit: BoxFit.cover)
                              : Image.network(widget.experienceData.photos[1]!.photoUrl, fit: BoxFit.cover),
                        ),
                      if (updatePhoto3
                          ? data.image3 != null
                          : widget.experienceData.photos.length > 2 &&
                          (widget.experienceData.photos[2].photoUrl ?? '').isNotEmpty)
                        StaggeredGridTile.fit(
                          crossAxisCellCount: 4,
                          child: updatePhoto3
                              ? Image.asset(data.image3 ?? selectedImagePath, fit: BoxFit.cover)
                              : Image.network(widget.experienceData.photos[2]!.photoUrl, fit: BoxFit.cover),
                        ),
                      if (updatePhoto4
                          ? data.image4 != null
                          : widget.experienceData.photos.length > 3 &&
                          (widget.experienceData.photos[3].photoUrl ?? '').isNotEmpty)
                        StaggeredGridTile.fit(
                          crossAxisCellCount: 4,
                          child: updatePhoto4
                              ? Image.asset(data.image4 ?? selectedImagePath, fit: BoxFit.cover)
                              : Image.network(widget.experienceData.photos[3]!.photoUrl, fit: BoxFit.cover),
                        ),
                      if (updatePhoto5
                          ? data.image5 != null
                          : widget.experienceData.photos.length > 4 &&
                          (widget.experienceData.photos[4].photoUrl ?? '').isNotEmpty)
                        StaggeredGridTile.fit(
                          crossAxisCellCount: 4,
                          child: updatePhoto5
                              ? Image.asset(data.image5 ?? selectedImagePath, fit: BoxFit.cover)
                              : Image.network(widget.experienceData.photos[4]!.photoUrl, fit: BoxFit.cover),
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
                        //_deleteExperience(widget.experienceId);
                        //Navigator.maybePop(context);
                        _showConfirmationDialog(context);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.delete_up_text,
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
                        await AppService.api.updateDataExperience(int.parse(widget.experienceData.id), data);
                        Navigator.maybePop(context);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.enregister_text,
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
      ])
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
