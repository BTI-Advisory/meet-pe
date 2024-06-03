import 'dart:io';
import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meet_pe/utils/_utils.dart';
import 'package:meet_pe/widgets/popup_view.dart';

import '../../../../resources/resources.dart';
import '../../../../utils/responsive_size.dart';
import '../../../../utils/utils.dart';
import 'create_exp_step6.dart';

// Define the callback function type
typedef ImagePathCallback = void Function(String);

class CreateExpStep5 extends StatefulWidget {
  CreateExpStep5({super.key, required this.name, required this.description, required this.idExperience});

  final String name;
  final String description;
  final int idExperience;

  @override
  State<CreateExpStep5> createState() => _CreateExpStep5State();
}

class _CreateExpStep5State extends State<CreateExpStep5> {
  String selectedImagePathPrincipal = '';
  String selectedImagePath1 = '';
  String selectedImagePath2 = '';
  String selectedImagePath3 = '';
  String selectedImagePath4 = '';
  String selectedImagePath5 = '';
  final List<dynamic> _imageList = [];
  bool imageSize = false;

  Future<void> pickImage(ImagePathCallback callback) async {
    // Your logic to pick an image goes here.
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource
            .gallery); // Use source: ImageSource.camera for taking a new picture

    if (pickedFile != null) {
      if((await pickedFile.readAsBytes()).lengthInBytes > 8388608) {
        imageSize = false;
        showMessage(context, 'La taille de photo ne doit pas passe 8 MB');
      } else {
        // Do something with the picked image (e.g., upload or process it)
        //File imageFile = File(pickedFile.path);
        // Add your logic here to handle the selected image

        // For demonstration purposes, I'm using a static image path.
        String imagePath = pickedFile?.path ?? '';

        setState(() {
          _imageList.add(imagePath);
          imageSize = true;
          callback(imagePath);
        });
      }
    }
  }

  String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppResources.colorGray5, AppResources.colorWhite],
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'images/backgroundExp4.png',
                width: double.infinity,
                fit: BoxFit.fill,
                height: ResponsiveSize.calculateHeight(190, context),
              ),
              SizedBox(height: ResponsiveSize.calculateHeight(40, context)),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.calculateWidth(28, context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Étape 4 sur 9',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    fontSize: 10, fontWeight: FontWeight.w400),
                          ),
                          const PopupView(contentTitle: "Capture l'Action 💥 /  Montre l'Authenticité 🌟 / Explore la Diversité 🌈 / Joue avec la Lumière ☀️ et Engage tes futurs Participants 🎉 \n\nN’oublie jamais la way of life de Meet People lors du choix de tes photos 📸, du partage, des échanges et des sourires !\n ",)
                        ]),
                    SizedBox(
                        height: ResponsiveSize.calculateHeight(8, context)),
                    Text(
                      'Photos de l’expérience',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(
                        height: ResponsiveSize.calculateHeight(16, context)),
                    Text(
                      'Plonge-nous dans ton univers et fais-nous rêver ! Quoi de mieux que des photos pour mettre en avant ton expérience ?',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(
                        height: ResponsiveSize.calculateHeight(22, context)),
                    Column(
                      children: [
                        Row(
                          children: [
                            Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    pickImage((String imagePath) {
                                      selectedImagePathPrincipal = imagePath;
                                    });
                                  },
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    color: AppResources.colorGray45,
                                    radius: Radius.circular(
                                        ResponsiveSize.calculateCornerRadius(
                                            12, context)),
                                    child: Container(
                                        width: ResponsiveSize.calculateWidth(
                                            206, context),
                                        height: ResponsiveSize.calculateHeight(
                                            206, context),
                                        child: selectedImagePathPrincipal
                                                .isEmpty
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.add,
                                                    color: AppResources
                                                        .colorGray60,
                                                  ),
                                                  Text(
                                                    'Photo principale',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.copyWith(
                                                            color: AppResources
                                                                .colorGray60),
                                                  ),
                                                  Text(
                                                    'Fais nous ton plus beau \nsourire 😉',
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                  ),
                                                ],
                                              )
                                            : ClipRRect(
                                                borderRadius: BorderRadius
                                                    .circular(ResponsiveSize
                                                        .calculateCornerRadius(
                                                            12, context)),
                                                child: Image.file(
                                                  File(
                                                      selectedImagePathPrincipal),
                                                  fit: BoxFit.cover,
                                                ),
                                              )),
                                  ),
                                ),
                                Positioned(
                                  bottom: 15,
                                  right: 14,
                                  child: Visibility(
                                    visible:
                                        selectedImagePathPrincipal.isNotEmpty,
                                    child: Container(
                                      width: ResponsiveSize.calculateWidth(
                                          24, context),
                                      height: ResponsiveSize.calculateHeight(
                                          24, context),
                                      //padding: const EdgeInsets.all(10),
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              ResponsiveSize
                                                  .calculateCornerRadius(
                                                      40, context)),
                                        ),
                                      ),
                                      child: FloatingActionButton(
                                        heroTag: "btn2",
                                        backgroundColor:
                                            AppResources.colorWhite,
                                        onPressed: () {
                                          pickImage((String imagePath) {
                                            selectedImagePathPrincipal =
                                                imagePath;
                                          });
                                        },
                                        child:
                                            Image.asset('images/pen_icon.png'),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                width:
                                    ResponsiveSize.calculateWidth(14, context)),
                            Expanded(
                              child: Column(
                                children: [
                                  Stack(children: [
                                    GestureDetector(
                                      onTap: () {
                                        pickImage((String imagePath) {
                                          selectedImagePath1 = imagePath;
                                        });
                                      },
                                      child: DottedBorder(
                                        borderType: BorderType.RRect,
                                        color: AppResources.colorGray45,
                                        radius: Radius.circular(
                                            ResponsiveSize.calculateCornerRadius(
                                                12, context)),
                                        child: Container(
                                          width:
                                              ResponsiveSize.calculateWidth(
                                                  98, context),
                                          height:
                                              ResponsiveSize.calculateHeight(
                                                  98, context),
                                          child: selectedImagePath1.isEmpty
                                              ? const Icon(
                                                  Icons.add,
                                                  color: AppResources
                                                      .colorGray60,
                                                )
                                              : ClipRRect(
                                                  borderRadius: BorderRadius
                                                      .circular(ResponsiveSize
                                                          .calculateCornerRadius(
                                                              12, context)),
                                                  child: Image.file(
                                                    File(selectedImagePath1),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 8,
                                      right: 7,
                                      child: Visibility(
                                        visible: selectedImagePath1.isNotEmpty,
                                        child: Container(
                                          width: ResponsiveSize.calculateWidth(
                                              24, context),
                                          height:
                                              ResponsiveSize.calculateHeight(
                                                  24, context),
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(ResponsiveSize
                                                      .calculateCornerRadius(
                                                          40, context)),
                                            ),
                                          ),
                                          child: FloatingActionButton(
                                            heroTag: "btn3",
                                            backgroundColor:
                                                AppResources.colorWhite,
                                            onPressed: () {
                                              pickImage((String imagePath) {
                                                selectedImagePath1 = imagePath;
                                              });
                                            },
                                            child: Image.asset(
                                                'images/pen_icon.png'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                  SizedBox(
                                      height: ResponsiveSize.calculateHeight(
                                          10, context)),
                                  Stack(children: [
                                    GestureDetector(
                                      onTap: () {
                                        pickImage((String imagePath) {
                                          selectedImagePath2 = imagePath;
                                        });
                                      },
                                      child: DottedBorder(
                                        borderType: BorderType.RRect,
                                        color: AppResources.colorGray45,
                                        radius: Radius.circular(
                                            ResponsiveSize.calculateCornerRadius(
                                                12, context)),
                                        child: Container(
                                          width:
                                              ResponsiveSize.calculateWidth(
                                                  98, context),
                                          height:
                                              ResponsiveSize.calculateHeight(
                                                  98, context),
                                          child: selectedImagePath2.isEmpty
                                              ? const Icon(
                                                  Icons.add,
                                                  color: AppResources
                                                      .colorGray60,
                                                )
                                              : ClipRRect(
                                                  borderRadius: BorderRadius
                                                      .circular(ResponsiveSize
                                                          .calculateCornerRadius(
                                                              12, context)),
                                                  child: Image.file(
                                                    File(selectedImagePath2),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 8,
                                      right: 7,
                                      child: Visibility(
                                        visible: selectedImagePath2.isNotEmpty,
                                        child: Container(
                                          width: ResponsiveSize.calculateWidth(
                                              24, context),
                                          height:
                                              ResponsiveSize.calculateHeight(
                                                  24, context),
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(ResponsiveSize
                                                      .calculateCornerRadius(
                                                          40, context)),
                                            ),
                                          ),
                                          child: FloatingActionButton(
                                            heroTag: "btn4",
                                            backgroundColor:
                                                AppResources.colorWhite,
                                            onPressed: () {
                                              pickImage((String imagePath) {
                                                selectedImagePath2 = imagePath;
                                              });
                                            },
                                            child: Image.asset(
                                                'images/pen_icon.png'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height:
                                ResponsiveSize.calculateHeight(14, context)),
                        Row(
                          children: [
                            Expanded(
                              child: Stack(children: [
                                GestureDetector(
                                  onTap: () {
                                    pickImage((String imagePath) {
                                      selectedImagePath3 = imagePath;
                                    });
                                  },
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    color: AppResources.colorGray45,
                                    radius: Radius.circular(
                                        ResponsiveSize.calculateCornerRadius(
                                            12, context)),
                                    child: Container(
                                      width: ResponsiveSize.calculateWidth(
                                          98, context),
                                      height: ResponsiveSize.calculateHeight(
                                          98, context),
                                      child: selectedImagePath3.isEmpty
                                          ? const Icon(
                                              Icons.add,
                                              color: AppResources.colorGray60,
                                            )
                                          : ClipRRect(
                                              borderRadius: BorderRadius
                                                  .circular(ResponsiveSize
                                                      .calculateCornerRadius(
                                                          12, context)),
                                              child: Image.file(
                                                File(selectedImagePath3),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 8,
                                  right: 7,
                                  child: Visibility(
                                    visible: selectedImagePath3.isNotEmpty,
                                    child: Container(
                                      width: ResponsiveSize.calculateWidth(
                                          24, context),
                                      height: ResponsiveSize.calculateHeight(
                                          24, context),
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              ResponsiveSize
                                                  .calculateCornerRadius(
                                                      40, context)),
                                        ),
                                      ),
                                      child: FloatingActionButton(
                                        heroTag: "btn5",
                                        backgroundColor:
                                            AppResources.colorWhite,
                                        onPressed: () {
                                          pickImage((String imagePath) {
                                            selectedImagePath3 = imagePath;
                                          });
                                        },
                                        child:
                                            Image.asset('images/pen_icon.png'),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                            SizedBox(
                                width:
                                    ResponsiveSize.calculateWidth(12, context)),
                            Expanded(
                              child: Stack(children: [
                                GestureDetector(
                                  onTap: () {
                                    pickImage((String imagePath) {
                                      selectedImagePath4 = imagePath;
                                    });
                                  },
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    color: AppResources.colorGray45,
                                    radius: Radius.circular(
                                        ResponsiveSize.calculateCornerRadius(
                                            12, context)),
                                    child: Container(
                                      width: ResponsiveSize.calculateWidth(
                                          98, context),
                                      height: ResponsiveSize.calculateHeight(
                                          98, context),
                                      child: selectedImagePath4.isEmpty
                                          ? const Icon(
                                              Icons.add,
                                              color: AppResources.colorGray60,
                                            )
                                          : ClipRRect(
                                              borderRadius: BorderRadius
                                                  .circular(ResponsiveSize
                                                      .calculateCornerRadius(
                                                          12, context)),
                                              child: Image.file(
                                                File(selectedImagePath4),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 8,
                                  right: 7,
                                  child: Visibility(
                                    visible: selectedImagePath4.isNotEmpty,
                                    child: Container(
                                      width: ResponsiveSize.calculateWidth(
                                          24, context),
                                      height: ResponsiveSize.calculateHeight(
                                          24, context),
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              ResponsiveSize
                                                  .calculateCornerRadius(
                                                      40, context)),
                                        ),
                                      ),
                                      child: FloatingActionButton(
                                        heroTag: "btn6",
                                        backgroundColor:
                                            AppResources.colorWhite,
                                        onPressed: () {
                                          pickImage((String imagePath) {
                                            selectedImagePath4 = imagePath;
                                          });
                                        },
                                        child:
                                            Image.asset('images/pen_icon.png'),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                            SizedBox(
                                width:
                                    ResponsiveSize.calculateWidth(12, context)),
                            Expanded(
                              child: Stack(children: [
                                GestureDetector(
                                  onTap: () {
                                    pickImage((String imagePath) {
                                      selectedImagePath5 = imagePath;
                                    });
                                  },
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    color: AppResources.colorGray45,
                                    radius: Radius.circular(
                                        ResponsiveSize.calculateCornerRadius(
                                            12, context)),
                                    child: Container(
                                      width: ResponsiveSize.calculateWidth(
                                          98, context),
                                      height: ResponsiveSize.calculateHeight(
                                          98, context),
                                      child: selectedImagePath5.isEmpty
                                          ? const Icon(
                                              Icons.add,
                                              color: AppResources.colorGray60,
                                            )
                                          : ClipRRect(
                                              borderRadius: BorderRadius
                                                  .circular(ResponsiveSize
                                                      .calculateCornerRadius(
                                                          12, context)),
                                              child: Image.file(
                                                File(selectedImagePath5),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 8,
                                  right: 7,
                                  child: Visibility(
                                    visible: selectedImagePath5.isNotEmpty,
                                    child: Container(
                                      width: ResponsiveSize.calculateWidth(
                                          24, context),
                                      height: ResponsiveSize.calculateHeight(
                                          24, context),
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              ResponsiveSize
                                                  .calculateCornerRadius(
                                                      40, context)),
                                        ),
                                      ),
                                      child: FloatingActionButton(
                                        heroTag: "btn7",
                                        backgroundColor:
                                            AppResources.colorWhite,
                                        onPressed: () {
                                          pickImage((String imagePath) {
                                            selectedImagePath5 = imagePath;
                                          });
                                        },
                                        child:
                                            Image.asset('images/pen_icon.png'),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: ResponsiveSize.calculateHeight(40, context),
                        left: ResponsiveSize.calculateWidth(28, context),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'ENREGISTRER',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: AppResources.colorGray45),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: ResponsiveSize.calculateHeight(40, context),
                        right: ResponsiveSize.calculateWidth(28, context),
                      ),
                      child: Container(
                        width: ResponsiveSize.calculateWidth(151, context),
                        height: ResponsiveSize.calculateHeight(44, context),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.symmetric(
                                    horizontal: ResponsiveSize.calculateHeight(
                                        24, context),
                                    vertical: ResponsiveSize.calculateHeight(
                                        10, context))),
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return AppResources
                                      .colorGray15; // Change to your desired grey color
                                }
                                return AppResources
                                    .colorVitamine; // Your enabled color
                              },
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                          ),
                          onPressed: (_imageList
                                  .isNotEmpty && imageSize) // Only enable button if _imageList is not empty
                              ? () {
                                  navigateTo(
                                      context,
                                      (_) => CreateExpStep6(
                                          photo: selectedImagePathPrincipal,
                                          imageArray: _imageList,
                                          idExperience: widget.idExperience,
                                          name: widget.name,
                                          description: widget.description,
                                      ));
                                }
                              : null, // Disable button if _imageList is empty
                          child: Image.asset('images/arrowLongRight.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
