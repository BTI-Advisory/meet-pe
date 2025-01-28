import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../resources/resources.dart';
import '../../services/app_service.dart';
import '../../utils/message.dart';
import '../../utils/responsive_size.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Define the callback function type
typedef OtherDocumentPathCallback = void Function(String);

class OtherDocumentWidget extends StatefulWidget {
  const OtherDocumentWidget({super.key, required this.onFetchUserInfo});
  final VoidCallback onFetchUserInfo;

  @override
  _OtherDocumentWidgetState createState() => _OtherDocumentWidgetState();
}

class _OtherDocumentWidgetState extends State<OtherDocumentWidget> {
  String otherDocument = '';
  String otherDocumentName = '';
  bool _isDropdownOpened = false;
  List<String> _categories = [];
  String _selectedCategory = "";

  Future<void> pickImage(OtherDocumentPathCallback callback, OtherDocumentPathCallback callbackName) async {
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
          showMessage(context, AppLocalizations.of(context)!.access_refuse_text);
          return;
        }
      }

      if (statuses[Permission.photos]!.isPermanentlyDenied) {
        showMessage(context, AppLocalizations.of(context)!.access_refuse_all_text);
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
            showMessage(context, AppLocalizations.of(context)!.image_size_text);
          } else {
            String imagePath = pickedFile?.path ?? '';
            String filename = path.basename(pickedFile.path);

            setState(() {
              callback(imagePath);
              callbackName(filename);
            });
          }
        } else {
          showMessage(context, AppLocalizations.of(context)!.no_image_selected_text);
        }
      } else {
        showMessage(context, AppLocalizations.of(context)!.impossible_access_text);
      }
    } else if (Platform.isAndroid) {
      // If permission is granted, proceed to pick the image
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        // Check the size of the picked image
        if ((await pickedFile.readAsBytes()).lengthInBytes > 8388608) {
          showMessage(context, AppLocalizations.of(context)!.image_size_text);
        } else {
          String imagePath = pickedFile?.path ?? '';
          String filename = path.basename(pickedFile.path);

          setState(() {
            callback(imagePath);
            callbackName(filename);
          });
        }
      } else {
        showMessage(context, AppLocalizations.of(context)!.no_image_selected_text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _categories = [AppLocalizations.of(context)!.permis_text, AppLocalizations.of(context)!.license_text, AppLocalizations.of(context)!.assurance_text, AppLocalizations.of(context)!.other_text];
    _selectedCategory = AppLocalizations.of(context)!.category_document_text;
    return Container(
      width: double.infinity,
      height: 439,
      color: AppResources.colorWhite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            Text(
              AppLocalizations.of(context)!.other_document_text,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 39),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isDropdownOpened = !_isDropdownOpened;
                });
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedCategory,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorGray60),
                      ),
                      Icon(Icons.keyboard_arrow_down, size: 24, color: Color(0xFF1C1B1F)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 1,
                    color: AppResources.colorGray15,
                  ),
                  if (_isDropdownOpened)
                    Container(
                      height: 100, // Adjust height according to your content
                      color: Colors.grey[200],
                      child: ListView.builder(
                        itemCount: _categories.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(_categories[index]),
                            visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                            onTap: () {
                              setState(() {
                                _selectedCategory = _categories[index];
                                _isDropdownOpened = false;
                              });
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 53,),
            GestureDetector(
              onTap: () async {
                await pickImage((String imagePath) {
                  setState(() {
                    otherDocument = imagePath;
                  });
                }, (String filename) {
                  setState(() {
                    otherDocumentName = filename;
                  });
                });
              },
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.add, size: 24, color: Color(0xFF1C1B1F)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          otherDocumentName.isEmpty
                              ? AppLocalizations.of(context)!.add_document_text
                              : otherDocumentName,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorGray60),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 1,
                    color: AppResources.colorGray15,
                  )
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
                    AppLocalizations.of(context)!.enregister_text,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: AppResources.colorDark),
                ),
                onPressed: () async {
                  final result = AppService.api.sendOtherDocument(_selectedCategory, otherDocument);
                  if (await result) {
                    Navigator.pop(context);
                    showMessage(context, AppLocalizations.of(context)!.add_other_document_ok_text);
                    await Future.delayed(const Duration(seconds: 3));
                    widget.onFetchUserInfo();
                  } else {
                    Navigator.pop(context);
                    showMessage(context, AppLocalizations.of(context)!.problem_server_text);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}