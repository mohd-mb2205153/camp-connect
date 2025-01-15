import 'package:flutter/material.dart';

Widget addVerticalSpace(double height) {
  return SizedBox(
    height: height,
  );
}

Widget addHorizontalSpace(double width) {
  return SizedBox(
    width: width,
  );
}

class Assets {
  static const _imagesBasePath = "campconnect/assets/images/";
  static String image(String fileName) => '$_imagesBasePath$fileName';

  static const _dataBasePath = "campconnect/assets/";
  static String data(String fileName) => '$_dataBasePath$fileName';
}

double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
