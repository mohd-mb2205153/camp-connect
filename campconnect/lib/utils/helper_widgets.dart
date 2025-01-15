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

String wrapText(String text, int maxCharsPerLine) {
  final words = text.split(' ');
  StringBuffer buffer = StringBuffer();
  int currentLineLength = 0;

  for (var word in words) {
    if (currentLineLength + word.length + 1 > maxCharsPerLine) {
      buffer.write('\n');
      currentLineLength = 0;
    }
    buffer.write(word + ' ');
    currentLineLength += word.length + 1;
  }

  return buffer.toString().trim();
}

class Assets {
  static const _imagesBasePath = "assets/images/";
  static String image(String fileName) => '$_imagesBasePath$fileName';

  static const _dataBasePath = "assets/data/";
  static String data(String fileName) => '$_dataBasePath$fileName';
}

double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
