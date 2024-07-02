import 'dart:io';
import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meet_pe/utils/_utils.dart';
import 'package:meet_pe/widgets/popup_view.dart';
import 'package:permission_handler/permission_handler.dart';

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
          setState(() {
            //_imageList.add(imagePath);
            imageSize = true;
            callback(imagePath);
          });
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
                                  onTap: () async {
                                    await pickImageFromGallery(context, (imagePath) {
                                      setState(() {
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
                                          await pickImageFromGallery(context, (imagePath) {
                                            setState(() {
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
                                        await pickImageFromGallery(context, (imagePath) {
                                          setState(() {
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
                                              await pickImageFromGallery(context, (imagePath) {
                                                setState(() {
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
                          onPressed: (selectedImagePathPrincipal != '' && imageSize) // Only enable button if _imageList is not empty
                              ? () {
                            _imageList.clear();
                            if(selectedImagePath1 != '') {
                              _imageList.add(selectedImagePath1);
                            }
                            if(selectedImagePath2 != '') {
                              _imageList.add(selectedImagePath2);
                            }
                            if(selectedImagePath3 != '') {
                              _imageList.add(selectedImagePath3);
                            }
                            if(selectedImagePath4 != '') {
                              _imageList.add(selectedImagePath4);
                            }
                            if(selectedImagePath5 != '') {
                              _imageList.add(selectedImagePath5);
                            }
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
