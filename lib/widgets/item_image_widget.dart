import 'package:flutter/material.dart';

import '../resources/resources.dart';
import '../utils/responsive_size.dart';

class ItemImage extends StatefulWidget {
  final int id;
  final String text;
  final String image;
  final bool isSelected;
  final VoidCallback onTap;

  const ItemImage({
    required this.id,
    required this.text,
    required this.image,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<ItemImage> createState() => _ItemImageState();
}

class _ItemImageState extends State<ItemImage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: IntrinsicWidth(
        child: Container(
          height: ResponsiveSize.calculateHeight(40, context),
          padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.calculateWidth(16, context),
              vertical: ResponsiveSize.calculateHeight(10, context) - 3),
          decoration: BoxDecoration(
            color: widget.isSelected ? Colors.black : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(
                ResponsiveSize.calculateCornerRadius(24, context))),
            border: Border.all(color: AppResources.colorGray100),
          ),
          child: Center(
            child: Row(
              children: [
                Image.network(
                  widget.image,
                  //'https://rec1-meetpe.neway-esoft.com/svgs/${widget.image}.png',
                  width: 10,
                  height: 10,
                  color: widget.isSelected
                      ? Colors.white
                      : AppResources.colorGray100,
                ),
                SizedBox(width: ResponsiveSize.calculateWidth(4, context)),
                Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: widget.isSelected
                        ? Colors.white
                        : AppResources.colorGray100,
                    fontWeight: widget.isSelected
                        ? FontWeight.w500
                        : FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VoyageImage {
  final int id;
  final String title;
  final String image;

  VoyageImage({
    required this.id,
    required this.title,
    required this.image,
  });
}