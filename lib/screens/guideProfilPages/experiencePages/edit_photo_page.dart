import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../utils/_utils.dart';
import '../../../resources/resources.dart';
import '../../../widgets/_widgets.dart';

// Define the callback function type
typedef ImagePathCallback = void Function(String);

class EditPhotoPage extends StatefulWidget {
  const EditPhotoPage({super.key, required this.imagePrincipal, required this.image1, required this.image2, required this.image3, required this.image4, required this.image5});

  final String imagePrincipal;
  final String image1;
  final String image2;
  final String image3;
  final String image4;
  final String image5;

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

  bool updatePhoto1 = false;
  bool updatePhoto2 = false;
  bool updatePhoto3 = false;
  bool updatePhoto4 = false;
  bool updatePhoto5= false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> displayInfo(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Center(child: Text('Information')),
        content: const Text(
            'Ici, nous souhaitons une photo de toi avec ton plus beau sourire 😃'
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> pickImageFromGallery(BuildContext context, Function(String) callback) async {
    final picker = ImagePicker();

    if (Platform.isIOS) {
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
    } else if (Platform.isAndroid) {
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
                                    await displayInfo(context);
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
                                        /*child: selectedImagePathPrincipal.isEmpty
                                            ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(widget.imagePrincipal, fit: BoxFit.cover))
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
                                        ),*/
                                      child: selectedImagePathPrincipal.isEmpty
                                          ? ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.network(widget.imagePrincipal, fit: BoxFit.cover))
                                          : ClipRRect(
                                        borderRadius: BorderRadius.circular(ResponsiveSize.calculateCornerRadius(12, context)),
                                        child: Image.file(File(selectedImagePathPrincipal), fit: BoxFit.cover,
                                        ),
                                      ),

                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 15,
                                  right: 14,
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
                                        await displayInfo(context);
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
                              ],
                            ),
                            SizedBox(
                                width:
                                ResponsiveSize.calculateWidth(14, context)),
                            Expanded(
                              child: Column(
                                children: [
                                  ImagePickerWidget(
                                    initialImage: widget.image1,
                                    selectedImagePath: selectedImagePath1,
                                    isUpdated: updatePhoto1,
                                    onImagePicked: (imagePath) {
                                      setState(() {
                                        _imageList.add(imagePath);
                                        selectedImagePath1 = imagePath;
                                        updatePhoto1 = true;
                                      });
                                    },
                                    pickImageFunction: pickImageFromGallery,
                                    heroTag: "btn3",
                                  ),
                                  SizedBox(height: ResponsiveSize.calculateHeight(10, context)),
                                  ImagePickerWidget(
                                    initialImage: widget.image2,
                                    selectedImagePath: selectedImagePath2,
                                    isUpdated: updatePhoto2,
                                    onImagePicked: (imagePath) {
                                      setState(() {
                                        _imageList.add(imagePath);
                                        selectedImagePath2 = imagePath;
                                        updatePhoto2 = true;
                                      });
                                    },
                                    pickImageFunction: pickImageFromGallery,
                                    heroTag: "btn4",
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                            height:
                            ResponsiveSize.calculateHeight(14, context)),
                        Row(
                          children: [
                            Expanded(
                              child: ImagePickerWidget(
                                initialImage: widget.image5,
                                selectedImagePath: selectedImagePath5,
                                isUpdated: updatePhoto5,
                                onImagePicked: (imagePath) {
                                  setState(() {
                                    _imageList.add(imagePath);
                                    selectedImagePath5 = imagePath;
                                    updatePhoto5 = true;
                                  });
                                },
                                pickImageFunction: pickImageFromGallery, // Pass the function
                                heroTag: "btn7",
                              ),
                            ),
                            SizedBox(width: ResponsiveSize.calculateWidth(12, context)),
                            Expanded(
                              child: ImagePickerWidget(
                                initialImage: widget.image4,
                                selectedImagePath: selectedImagePath4,
                                isUpdated: updatePhoto4,
                                onImagePicked: (imagePath) {
                                  setState(() {
                                    _imageList.add(imagePath);
                                    selectedImagePath4 = imagePath;
                                    updatePhoto4 = true;
                                  });
                                },
                                pickImageFunction: pickImageFromGallery, // Pass the function
                                heroTag: "btn6",
                              ),
                            ),
                            SizedBox(width: ResponsiveSize.calculateWidth(12, context)),
                            Expanded(
                              child: ImagePickerWidget(
                                initialImage: widget.image3,
                                selectedImagePath: selectedImagePath3,
                                isUpdated: updatePhoto3,
                                onImagePicked: (imagePath) {
                                  setState(() {
                                    _imageList.add(imagePath);
                                    selectedImagePath3 = imagePath;
                                    updatePhoto3 = true;
                                  });
                                },
                                pickImageFunction: pickImageFromGallery, // Pass the function
                                heroTag: "btn5",
                              ),
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