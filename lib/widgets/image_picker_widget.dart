import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../resources/resources.dart';
import '../utils/responsive_size.dart';

class ImagePickerWidget extends StatelessWidget {
  final String initialImage;
  final String selectedImagePath;
  final bool isUpdated;
  final Function(String) onImagePicked;
  final Function(BuildContext, Function(String)) pickImageFunction; // Add this
  final String heroTag;

  const ImagePickerWidget({
    Key? key,
    required this.initialImage,
    required this.selectedImagePath,
    required this.isUpdated,
    required this.onImagePicked,
    required this.pickImageFunction, // Add this
    required this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () async {
            pickImageFunction(context, onImagePicked); // Use the function
          },
          child: DottedBorder(
            borderType: BorderType.RRect,
            color: AppResources.colorGray45,
            radius: Radius.circular(
                ResponsiveSize.calculateCornerRadius(12, context)),
            child: Container(
              width: ResponsiveSize.calculateWidth(98, context),
              height: ResponsiveSize.calculateHeight(98, context),
              child: Builder(
                builder: (context) {
                  if (!isUpdated) {
                    return initialImage.isNotEmpty
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        initialImage,
                        fit: BoxFit.cover,
                      ),
                    )
                        : const Icon(
                      Icons.add,
                      color: AppResources.colorGray60,
                    );
                  } else {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(selectedImagePath),
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 8,
          right: 7,
          child: Visibility(
            visible: initialImage.isNotEmpty || selectedImagePath.isNotEmpty,
            child: Container(
              width: ResponsiveSize.calculateWidth(24, context),
              height: ResponsiveSize.calculateHeight(24, context),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      ResponsiveSize.calculateCornerRadius(40, context)),
                ),
              ),
              child: FloatingActionButton(
                heroTag: heroTag,
                backgroundColor: AppResources.colorWhite,
                onPressed: () async {
                  pickImageFunction(context, onImagePicked); // Use the function
                },
                child: Image.asset('images/pen_icon.png'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
