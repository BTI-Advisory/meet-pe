import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../resources/resources.dart';
import '../../../../utils/responsive_size.dart';

// Define the callback function type
typedef ImagePathCallback = void Function(String);

class CreateExpStep5 extends StatefulWidget {
  CreateExpStep5({super.key, required this.myMap});

  Map<String, Set<Object>> myMap = {};

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
  final List<File> _imageList = [];

  Future<void> pickImage(ImagePathCallback callback) async {
    // Your logic to pick an image goes here.
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource
            .gallery); // Use source: ImageSource.camera for taking a new picture

    if (pickedFile != null) {
      // Do something with the picked image (e.g., upload or process it)
      //File imageFile = File(pickedFile.path);
      // Add your logic here to handle the selected image


      // For demonstration purposes, I'm using a static image path.
      String imagePath = pickedFile?.path ?? '';

      setState(() {
        _imageList.add(File(imagePath));
        callback(imagePath);
      });
    }
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
              Stack(children: [
                Image.asset('images/backgroundExp4.png'),
                Positioned(
                  top: 48,
                  left: 28,
                  child: Container(
                    width: ResponsiveSize.calculateWidth(24, context),
                    height: ResponsiveSize.calculateHeight(24, context),
                    //padding: const EdgeInsets.all(10),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            ResponsiveSize.calculateCornerRadius(40, context)),
                      ),
                    ),
                    child: FloatingActionButton(
                        backgroundColor: AppResources.colorWhite,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          String.fromCharCode(CupertinoIcons.back.codePoint),
                          style: TextStyle(
                            inherit: false,
                            color: AppResources.colorVitamine,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w900,
                            fontFamily: CupertinoIcons
                                .exclamationmark_circle.fontFamily,
                            package: CupertinoIcons
                                .exclamationmark_circle.fontPackage,
                          ),
                        )),
                  ),
                ),
              ]),
              SizedBox(height: ResponsiveSize.calculateHeight(40, context)),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.calculateWidth(28, context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Étape 4 sur 8',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontSize: 10, fontWeight: FontWeight.w400),
                    ),
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
                                DottedBorder(
                                  borderType: BorderType.RRect,
                                  color: AppResources.colorGray45,
                                  radius: Radius.circular(
                                      ResponsiveSize.calculateCornerRadius(
                                          12, context)),
                                  child: GestureDetector(
                                    onTap: () {
                                      pickImage((String imagePath) {
                                        selectedImagePathPrincipal = imagePath;
                                      });
                                    },
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
                                    DottedBorder(
                                      borderType: BorderType.RRect,
                                      color: AppResources.colorGray45,
                                      radius: Radius.circular(
                                          ResponsiveSize.calculateCornerRadius(
                                              12, context)),
                                      child: GestureDetector(
                                          onTap: () {
                                            pickImage((String imagePath) {
                                              selectedImagePath1 = imagePath;
                                            });
                                          },
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
                                          )),
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
                                    DottedBorder(
                                      borderType: BorderType.RRect,
                                      color: AppResources.colorGray45,
                                      radius: Radius.circular(
                                          ResponsiveSize.calculateCornerRadius(
                                              12, context)),
                                      child: GestureDetector(
                                          onTap: () {
                                            pickImage((String imagePath) {
                                              selectedImagePath2 = imagePath;
                                            });
                                          },
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
                                          )),
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
                                DottedBorder(
                                  borderType: BorderType.RRect,
                                  color: AppResources.colorGray45,
                                  radius: Radius.circular(
                                      ResponsiveSize.calculateCornerRadius(
                                          12, context)),
                                  child: GestureDetector(
                                      onTap: () {
                                        pickImage((String imagePath) {
                                          selectedImagePath3 = imagePath;
                                        });
                                      },
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
                                      )),
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
                                DottedBorder(
                                  borderType: BorderType.RRect,
                                  color: AppResources.colorGray45,
                                  radius: Radius.circular(
                                      ResponsiveSize.calculateCornerRadius(
                                          12, context)),
                                  child: GestureDetector(
                                      onTap: () {
                                        pickImage((String imagePath) {
                                          selectedImagePath4 = imagePath;
                                        });
                                      },
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
                                      )),
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
                                DottedBorder(
                                  borderType: BorderType.RRect,
                                  color: AppResources.colorGray45,
                                  radius: Radius.circular(
                                      ResponsiveSize.calculateCornerRadius(
                                          12, context)),
                                  child: GestureDetector(
                                      onTap: () {
                                        pickImage((String imagePath) {
                                          selectedImagePath5 = imagePath;
                                        });
                                      },
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
                                      )),
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
              //Todo:
              /*TextButton(
                onPressed: () {},
                child: Text(
                  'ENREGISTRER',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),*/
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: ResponsiveSize.calculateHeight(40, context),
                        right: ResponsiveSize.calculateWidth(28, context)),
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        ),
                        onPressed: _imageList.isNotEmpty // Only enable button if _imageList is not empty
                            ? () {
                          // Handle button press action here
                        }
                            : null, // Disable button if _imageList is empty
                        child: Image.asset('images/arrowLongRight.png'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
