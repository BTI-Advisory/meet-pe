import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../utils/_utils.dart';
import '../../../resources/resources.dart';

// Define the callback function type
typedef ImagePathCallback = void Function(String);

class EditPhotoPage extends StatefulWidget {
  const EditPhotoPage({super.key});

  @override
  State<EditPhotoPage> createState() => _EditPhotoPageState();
}

class _EditPhotoPageState extends State<EditPhotoPage> {

  String selectedImagePathPrincipal = '';
  String selectedImagePath1 = '';
  String selectedImagePath2 = '';
  String selectedImagePath3 = '';
  String selectedImagePath4 = '';
  String selectedImagePath5 = '';
  final List<dynamic> _imageList = [];
  bool imageSize = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> pickImageFromGallery(BuildContext context, Function(String) callback) async {
    final picker = ImagePicker();

    // Request permissions for photos and access only photos added in future
    Map<Permission, PermissionStatus> statuses = await [
      Permission.photos,
      Permission.photosAddOnly,
    ].request();

    // Check the status of the photos permission
    if (statuses[Permission.photos]!.isDenied) {
      // Permission was denied, so request again
      statuses[Permission.photos] = await Permission.photos.request();

      if (statuses[Permission.photos]!.isDenied) {
        showMessage(context, "L'autorisation d'accéder aux photos est refusée. Veuillez l'activer à partir des paramètres.");
        return;
      }
    }

    if (statuses[Permission.photos]!.isPermanentlyDenied) {
      showMessage(context, "L'autorisation d'accéder aux photos est définitivement refusée. Veuillez l'activer à partir des paramètres.");
      // Optionally, you could navigate the user to the app settings:
      // openAppSettings();
      return;
    }

    if (statuses[Permission.photos]!.isGranted) {
      // If permission is granted, proceed to pick the image
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        // Check the size of the picked image
        if ((await pickedFile.readAsBytes()).lengthInBytes > 8388608) {
          showMessage(context, 'Oups, ta 📸 est top, mais trop lourde pour nous, 8MO max stp 🙏🏻');
        } else {
          // Process the image
          String imagePath = pickedFile.path;

          // Update the UI and invoke the callback
          callback(imagePath);
        }
      } else {
        showMessage(context, 'Aucune image sélectionnée.');
      }
    } else {
      showMessage(context, "Impossible d'accéder aux photos. Veuillez vérifier vos paramètres d'autorisation.");
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
            colors: [Color(0xFFF3F3F3), Colors.white],
            stops: [0.0, 1.0],
          ),
        ),
        child: Stack(
          children: <Widget>[
            // Main content with scroll capability
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 48),
                    SizedBox(
                      width: ResponsiveSize.calculateWidth(24, context),
                      height: ResponsiveSize.calculateHeight(24, context),
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
                            fontFamily: CupertinoIcons.exclamationmark_circle.fontFamily,
                            package: CupertinoIcons.exclamationmark_circle.fontPackage,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),
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
                                  onTap: () async {
                                    pickImageFromGallery(context, (imagePath) {
                                      setState(() {
                                        _imageList.add(imagePath); // Assuming _imageList is a List<String> in your state
                                        selectedImagePathPrincipal = imagePath;
                                      });
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
                                        onPressed: () async {
                                          pickImageFromGallery(context, (imagePath) {
                                            setState(() {
                                              _imageList.add(imagePath); // Assuming _imageList is a List<String> in your state
                                              selectedImagePathPrincipal = imagePath;
                                            });
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
                                      onTap: () async {
                                        pickImageFromGallery(context, (imagePath) {
                                          setState(() {
                                            _imageList.add(imagePath); // Assuming _imageList is a List<String> in your state
                                            selectedImagePath1 = imagePath;
                                          });
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
                                            onPressed: () async {
                                              pickImageFromGallery(context, (imagePath) {
                                                setState(() {
                                                  _imageList.add(imagePath); // Assuming _imageList is a List<String> in your state
                                                  selectedImagePath1 = imagePath;
                                                });
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
                                      onTap: () async {
                                        pickImageFromGallery(context, (imagePath) {
                                          setState(() {
                                            _imageList.add(imagePath); // Assuming _imageList is a List<String> in your state
                                            selectedImagePath2 = imagePath;
                                          });
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
                                            onPressed: () async {
                                              pickImageFromGallery(context, (imagePath) {
                                                setState(() {
                                                  _imageList.add(imagePath); // Assuming _imageList is a List<String> in your state
                                                  selectedImagePath2 = imagePath;
                                                });
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
                                  onTap: () async {
                                    pickImageFromGallery(context, (imagePath) {
                                      setState(() {
                                        _imageList.add(imagePath); // Assuming _imageList is a List<String> in your state
                                        selectedImagePath3 = imagePath;
                                      });
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
                                        onPressed: () async {
                                          pickImageFromGallery(context, (imagePath) {
                                            setState(() {
                                              _imageList.add(imagePath); // Assuming _imageList is a List<String> in your state
                                              selectedImagePath3 = imagePath;
                                            });
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
                                  onTap: () async {
                                    pickImageFromGallery(context, (imagePath) {
                                      setState(() {
                                        _imageList.add(imagePath); // Assuming _imageList is a List<String> in your state
                                        selectedImagePath4 = imagePath;
                                      });
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
                                        onPressed: () async {
                                          pickImageFromGallery(context, (imagePath) {
                                            setState(() {
                                              _imageList.add(imagePath); // Assuming _imageList is a List<String> in your state
                                              selectedImagePath4 = imagePath;
                                            });
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
                                  onTap: () async {
                                    pickImageFromGallery(context, (imagePath) {
                                      setState(() {
                                        _imageList.add(imagePath); // Assuming _imageList is a List<String> in your state
                                        selectedImagePath5 = imagePath;
                                      });
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
                                        onPressed: () async {
                                          pickImageFromGallery(context, (imagePath) {
                                            setState(() {
                                              _imageList.add(imagePath); // Assuming _imageList is a List<String> in your state
                                              selectedImagePath5 = imagePath;
                                            });
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
                    ), // Additional space to account for button
                  ],
                ),
              ),
            ),
            // Bottom button
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 20), // Add some bottom margin for padding
                child: SizedBox(
                  width: ResponsiveSize.calculateWidth(319, context),
                  height: ResponsiveSize.calculateHeight(44, context),
                  child: TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(
                              horizontal: ResponsiveSize.calculateWidth(24, context),
                              vertical: ResponsiveSize.calculateHeight(12, context))),
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: AppResources.colorDark),
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                    child: Text(
                      'ENREGISTRER',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppResources.colorDark),
                    ),
                    onPressed: () {
                      // Create a map and add only non-null entries.
                      Map<String, String?> resultMap = {};

                      // Check each field and add it to the map if it's not null.
                      if (selectedImagePathPrincipal != '') {
                        resultMap['image_principale'] = selectedImagePathPrincipal;
                      }
                      if (selectedImagePath1 != '') {
                        resultMap['image_0'] = selectedImagePath1;
                      }
                      if (selectedImagePath2 != '') {
                        resultMap['image_1'] = selectedImagePath2;
                      }
                      if (selectedImagePath3 != '') {
                        resultMap['image_2'] = selectedImagePath3;
                      }
                      if (selectedImagePath4 != '') {
                        resultMap['image_3'] = selectedImagePath4;
                      }
                      if (selectedImagePath5 != '') {
                        resultMap['image_4'] = selectedImagePath5;
                      }
                      Navigator.pop(context, resultMap);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}