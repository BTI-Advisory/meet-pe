import 'package:flutter/widgets.dart';

class ResponsiveSize {

  // Adjust the width according to your scaling factor
  static double calculateWidth(double width, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return (width / 375.0) * screenWidth;
  }

  // Adjust the height according to your scaling factor
  static double calculateHeight(double height, BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return (height / 812.0) * screenHeight;
  }

  // Adjust the base size according to your scaling factor
  static double calculateTextSize(double baseSize, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double adjustedSize = (baseSize / 375.0) * screenWidth;
    return adjustedSize;
  }

  // Adjust the base cornerRedius according to your scaling factor
  static double calculateCornerRadius(double baseRadius, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Adjust the base radius according to your scaling factors for width and height
    double baseWidthFactor = 375.0;
    double baseHeightFactor = 812.0;

    double adjustedWidthRadius = (baseRadius / baseWidthFactor) * screenWidth;
    double adjustedHeightRadius = (baseRadius / baseHeightFactor) * screenHeight;

    // Use the average of adjusted width and height radii
    double adjustedRadius = (adjustedWidthRadius + adjustedHeightRadius) / 2.0;

    return adjustedRadius;
  }
}