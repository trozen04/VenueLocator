import 'package:flutter/material.dart';

class SizeConfig {
  static late double screenWidth;
  static late double screenHeight;

  static void init(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData.size.width;
    screenHeight = mediaQueryData.size.height;
  }

  static double setWidth(double inputWidth) {
    return (inputWidth / 375.0) * screenWidth;
  }

  static double setHeight(double inputHeight) {
    return (inputHeight / 812.0) * screenHeight;
  }
}