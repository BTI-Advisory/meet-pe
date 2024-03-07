import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meet_pe/models/experience_data_response.dart';
import 'package:widget_mask/widget_mask.dart';

import '../../../resources/resources.dart';
import '../../../services/app_service.dart';
import '../../../utils/_utils.dart';
import '../../../widgets/themed/ep_app_bar.dart';

class EditExperiencePage extends StatefulWidget {
  const EditExperiencePage({super.key, required this.experienceId, required this.isOnline, required this.price});
  final int experienceId;
  final bool isOnline;
  final double price;

  @override
  State<EditExperiencePage> createState() => _EditExperiencePageState();
}

class _EditExperiencePageState extends State<EditExperiencePage> {
  bool onLine = true;
  late TextEditingController _textEditingControllerDescription;
  String? validationMessageDescription = '';
  bool isFormValid = false;
  double valueSlider = 30;
  late Future<ExperienceDataResponse> _experienceDataFuture;
  String selectedImagePath = 'images/imageTest.png';
  bool updateOnline = false;
  bool updateDescription = false;
  bool updatePhoto = false;
  bool updatePrices = false;

  @override
  void initState() {
    super.initState();
    _experienceDataFuture = AppService.api.getExperienceDetail(widget.experienceId);
    onLine = widget.isOnline;
    valueSlider = widget.price;
    _textEditingControllerDescription = TextEditingController();
    _textEditingControllerDescription.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textEditingControllerDescription.removeListener(_onTextChanged);
    _textEditingControllerDescription.dispose();
  }

  void _onTextChanged() {
    setState(() {
      //_showButton = _textEditingControllerName.text.isEmpty;
    });
  }

  void updateFormValidity() {
    setState(() {
      isFormValid =
          validationMessageDescription == null;
    });
  }

  void updatePrice(double value) {
    setState(() {
      valueSlider = value;
      //bloc.updateDuration(value); // Call the method to update duration in bloc
    });
  }

  Future<void> _updateExperienceOnline(int experienceID, bool isOnline) async {
    try {
      final update = await AppService.api.updateExperienceOnline(experienceID, isOnline);
    } catch (e) {
      // Handle error
      print('Error update exp online: $e');
    }
  }

  Future<void> _updateExperienceDescription(int experienceID, String description) async {
    try {
      final update = await AppService.api.updateExperienceDescription(experienceID, description);
    } catch (e) {
      // Handle error
      print('Error update exp description: $e');
    }
  }

  Future<void> _updateExperiencePrice(int experienceID, int price) async {
    try {
      final update = await AppService.api.updateExperiencePrice(experienceID, price);
    } catch (e) {
      // Handle error
      print('Error update exp price: $e');
    }
  }

  Future<void> _updateExperienceImage(int experienceID, String pathImage) async {
    try {
      final update = await AppService.api.updateExperienceImage(experienceID, pathImage);
    } catch (e) {
      // Handle error
      print('Error update exp image: $e');
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

  Future<void> pickImage() async {
    // Your logic to pick an image goes here.
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource
            .gallery); // Use source: ImageSource.camera for taking a new picture

    if (pickedFile != null) {
      // Do something with the picked image (e.g., upload or process it)
      //File imageFile = File(pickedFile.path);
      // Add your logic here to handle the selected image
    }
    // For demonstration purposes, I'm using a static image path.
    String imagePath = pickedFile?.path ?? '';

    setState(() {
      selectedImagePath = imagePath;
    });
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
                                height: 576,
                                child: Stack(
                                  children: [
                                    /// Image principal
                                    Positioned(
                                      left: -36,
                                      top: 0,
                                      child: Container(
                                        width: ResponsiveSize.calculateWidth(
                                            427, context),
                                        height: 592,
                                        child: updatePhoto ? Image.asset(selectedImagePath, fit: BoxFit.cover) : Image.network(experienceData.photoPrincipal.photoUrl, fit: BoxFit.cover)
                                      ),
                                    ),

                                    /// Shadow bottom
                                    Positioned(
                                      left: 0,
                                      top: 60,
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
                                      child: editButton(onTap: () {
                                        print('Edit image');
                                        pickImage();
                                        updatePhoto = true;
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
                                                  '${valueSlider.toInt()}€/pers',
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
                                              child: editButton(onTap: () {
                                                print('Edit price');
                                                showModalBottomSheet<void>(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    builder: (BuildContext context) {
                                                      return Padding(
                                                        padding: EdgeInsets.only(
                                                            bottom: MediaQuery.of(context).viewInsets.bottom),
                                                        child: StatefulBuilder(
                                                          builder: (BuildContext context,
                                                              StateSetter setState) {
                                                            return Container(
                                                              width: double.infinity,
                                                              height: 357,
                                                              color: AppResources.colorWhite,
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 28),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: <Widget>[
                                                                    const SizedBox(height: 39),
                                                                    Text(
                                                                      'Prix de l’experience',
                                                                      style: Theme.of(context).textTheme.headlineMedium,
                                                                    ),
                                                                    const SizedBox(height: 57),
                                                                    Slider(
                                                                      value: valueSlider,
                                                                      min: 30,
                                                                      max: 500,
                                                                      divisions: 10,
                                                                      label: '${valueSlider.round().toString()} €',
                                                                      onChanged: (double value) {
                                                                        setState(() {
                                                                          valueSlider = value;
                                                                          updatePrice(value);
                                                                        });
                                                                      },
                                                                    ),
                                                                    SizedBox(
                                                                        height: ResponsiveSize.calculateHeight(33, context)),
                                                                    Container(
                                                                      width: double.infinity,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                        children: [
                                                                          Text(
                                                                            'Prix conseillé dans cette catégorie',
                                                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 10, fontWeight: FontWeight.w400, color: AppResources.colorGray60),
                                                                          ),
                                                                          Text(
                                                                            ' 30 €',
                                                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 10, fontWeight: FontWeight.w400, color: AppResources.colorDark),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    const SizedBox(height: 53),
                                                                    Container(
                                                                      width: ResponsiveSize.calculateWidth(319, context),
                                                                      height: ResponsiveSize.calculateHeight(44, context),
                                                                      child: TextButton(
                                                                        style: ButtonStyle(
                                                                          padding:
                                                                          MaterialStateProperty.all<EdgeInsets>(
                                                                              EdgeInsets.symmetric(
                                                                                  horizontal: ResponsiveSize.calculateWidth(24, context), vertical: ResponsiveSize.calculateHeight(12, context))),
                                                                          backgroundColor: MaterialStateProperty.all(
                                                                              Colors.transparent),
                                                                          shape: MaterialStateProperty.all<
                                                                              RoundedRectangleBorder>(
                                                                            RoundedRectangleBorder(
                                                                              side: BorderSide(width: 1, color: AppResources.colorDark),
                                                                              borderRadius: BorderRadius.circular(40),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        child: Text(
                                                                          'ENREGISTRER',
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyLarge
                                                                              ?.copyWith(color: AppResources.colorDark),
                                                                        ),
                                                                        onPressed: () async {
                                                                          updatePrices = true;
                                                                          Navigator.pop(context);
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    }
                                                );
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
                                  experienceData.description,
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
                              child: editButton(onTap: () {
                                print('Edit description');
                                showModalBottomSheet<void>(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context).viewInsets.bottom),
                                        child: StatefulBuilder(
                                          builder: (BuildContext context,
                                              StateSetter setState) {
                                            return Container(
                                              width: double.infinity,
                                              height: 432,
                                              color: AppResources.colorWhite,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 28),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    const SizedBox(height: 39),
                                                    Text(
                                                      'Description de l’experience',
                                                      style: Theme.of(context).textTheme.headlineMedium,
                                                    ),
                                                    Column(
                                                      children: [
                                                        TextFormField(
                                                          controller: _textEditingControllerDescription,
                                                          keyboardType: TextInputType.multiline,
                                                          textInputAction: TextInputAction.newline,
                                                          //textInputAction: TextInputAction.done,
                                                          maxLines: null,
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .bodyMedium
                                                              ?.copyWith(color: AppResources.colorDark),
                                                          decoration: InputDecoration(
                                                            filled: false,
                                                            hintText: 'Description',
                                                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                                                            contentPadding: EdgeInsets.only(
                                                                top: ResponsiveSize.calculateHeight(20, context),
                                                                bottom:
                                                                ResponsiveSize.calculateHeight(10, context)),
                                                            // Adjust padding
                                                            suffix: SizedBox(
                                                                height:
                                                                ResponsiveSize.calculateHeight(10, context)),
                                                            enabledBorder: const UnderlineInputBorder(
                                                              borderSide:
                                                              BorderSide(color: AppResources.colorGray15),
                                                            ),
                                                            focusedBorder: const UnderlineInputBorder(
                                                              borderSide:
                                                              BorderSide(color: AppResources.colorGray15),
                                                            ),
                                                            errorBorder: const UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.red),
                                                            ),
                                                          ),
                                                          autofocus: true,
                                                          //onFieldSubmitted: (value) => validate(),
                                                          validator: AppResources.validatorNotEmpty,
                                                          //onSaved: (value) => bloc.name = value,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              validationMessageDescription =
                                                                  AppResources.validatorNotEmpty(value);
                                                              updateFormValidity();
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 53),
                                                    Container(
                                                      width: ResponsiveSize.calculateWidth(319, context),
                                                      height: ResponsiveSize.calculateHeight(44, context),
                                                      child: TextButton(
                                                        style: ButtonStyle(
                                                          padding:
                                                          MaterialStateProperty.all<EdgeInsets>(
                                                              EdgeInsets.symmetric(
                                                                  horizontal: ResponsiveSize.calculateWidth(24, context), vertical: ResponsiveSize.calculateHeight(12, context))),
                                                          backgroundColor: MaterialStateProperty.all(
                                                              Colors.transparent),
                                                          shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                              side: BorderSide(width: 1, color: AppResources.colorDark),
                                                              borderRadius: BorderRadius.circular(40),
                                                            ),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          'ENREGISTRER',
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .bodyLarge
                                                              ?.copyWith(color: AppResources.colorDark),
                                                        ),
                                                        onPressed: () async {
                                                          updateDescription = true;
                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }
                                );
                              }),
                            )
                          ],
                        ),
                        const SizedBox(height: 27),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(
                              horizontal: ResponsiveSize.calculateWidth(22, context)),
                          width: double.infinity,
                          child: Image.asset('images/play-wave.png'),
                        ),
                        const SizedBox(height: 34),
                        SizedBox(
                          width: ResponsiveSize.calculateWidth(319, context),
                          child: Text(
                            'Gallery',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: AppResources.colorDark),
                          ),
                        ),
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
                            onPressed: () {
                              if(updateDescription) {
                                _updateExperienceDescription(widget.experienceId, _textEditingControllerDescription.text);
                              }
                              if(updateOnline) {
                                _updateExperienceOnline(widget.experienceId, onLine);
                              }
                              if(updatePrices) {
                                _updateExperiencePrice(widget.experienceId, valueSlider.toInt());
                              }
                              if(updatePhoto) {
                                _updateExperienceImage(widget.experienceId, selectedImagePath);
                              }
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
