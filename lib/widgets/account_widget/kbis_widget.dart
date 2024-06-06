import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../resources/resources.dart';
import '../../services/app_service.dart';
import '../../utils/message.dart';
import '../../utils/responsive_size.dart';
import 'package:path/path.dart' as path;

// Define the callback function type
typedef KbisPathCallback = void Function(String);

class KbisWidget extends StatefulWidget {
  const KbisWidget({super.key, required this.onFetchUserInfo});
  final VoidCallback onFetchUserInfo;

  @override
  _KbisWidgetState createState() => _KbisWidgetState();
}

class _KbisWidgetState extends State<KbisWidget> {
  String kbis = '';
  String kbisName = '';

  Future<void> pickImage(KbisPathCallback callback, KbisPathCallback callbackName) async {
    // Your logic to pick an image goes here.
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource
            .gallery); // Use source: ImageSource.camera for taking a new picture

    if (pickedFile != null) {
      if((await pickedFile.readAsBytes()).lengthInBytes > 8388608) {
        showMessage(context, 'Oups, ta 📸 est top, mais trop lourde pour nous, 8MO max stp, 🙏🏻 Tu es le meilleur');
      } else {
        // Do something with the picked image (e.g., upload or process it)
        //File imageFile = File(pickedFile.path);
        // Add your logic here to handle the selected image

        // For demonstration purposes, I'm using a static image path.
        String imagePath = pickedFile?.path ?? '';
        String filename = path.basename(pickedFile.path);

        setState(() {
          callback(imagePath);
          callbackName(filename);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 288,
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
              'Mon KBIS',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 39),
            GestureDetector(
              onTap: () async {
                await pickImage((String imagePath) {
                  setState(() {
                    kbis = imagePath;
                  });
                }, (String filename) {
                  setState(() {
                    kbisName = filename;
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
                          kbisName.isEmpty
                              ? 'Ajouter un document'
                              : kbisName,
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
                  'ENREGISTRER',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: AppResources.colorDark),
                ),
                onPressed: () async {
                  final result = AppService.api.sendKbisFile(kbis);
                  if (await result) {
                    Navigator.pop(context);
                    showMessage(context, 'KBIS ✅');
                    await Future.delayed(const Duration(seconds: 3));
                    widget.onFetchUserInfo();
                  } else {
                    Navigator.pop(context);
                    showMessage(context, 'Problème de connexion avec le serveur, veuillez réessayer ultérieurement');
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