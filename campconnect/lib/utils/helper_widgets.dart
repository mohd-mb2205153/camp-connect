import 'package:campconnect/theme/styling_constants.dart';
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

Widget buildTextField({
  required TextEditingController controller,
  required String hintText,
  TextInputType? keyboardType,
  bool obscureText = false,
  Widget? suffixIcon,
  Icon? prefixIcon,
  required FocusNode focusNode,
}) {
  return TextField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: obscureText,
    focusNode: focusNode,
    decoration: InputDecoration(
      hintText: hintText,
      prefixIcon: prefixIcon,
      hintStyle: const TextStyle(color: Colors.grey),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.lightTeal, width: 2),
      ),
      suffixIcon: suffixIcon,
    ),
    style: getTextStyle(
      'medium',
      color: focusNode.hasFocus ? AppColors.lightTeal : Colors.grey,
    ),
  );
}

InputDecoration buildInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(
      color: Colors.grey,
      overflow: TextOverflow.ellipsis,
    ),
    isDense: true,
    hintMaxLines: 1,
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.lightTeal, width: 2),
    ),
  );
}

class Assets {
  static const _imagesBasePath = "assets/images/";
  static String image(String fileName) => '$_imagesBasePath$fileName';

  static const _dataBasePath = "assets/data/";
  static String data(String fileName) => '$_dataBasePath$fileName';
}

double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
