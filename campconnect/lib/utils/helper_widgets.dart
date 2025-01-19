import 'package:campconnect/theme/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

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
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
    ),
    style: getTextStyle(
      'medium',
      color: focusNode.hasFocus ? AppColors.lightTeal : Colors.grey,
    ),
  );
}

Widget buildTextArea({
  required TextEditingController controller,
  required String hintText,
  TextInputType? keyboardType,
  int maxLines = 1,
  Widget? suffixIcon,
  Icon? prefixIcon,
  required FocusNode focusNode,
}) {
  return TextField(
    controller: controller,
    keyboardType: keyboardType,
    focusNode: focusNode,
    maxLines: maxLines,
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
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
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

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    scrolledUnderElevation: 0.0,
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: AppColors.lightTeal),
      onPressed: () => context.pop(),
    ),
  );
}

Widget buildHeader(String header, String? subheader) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(24, 120, 24, 0),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: getTextStyle('largeBold', color: AppColors.lightTeal),
          ),
          SizedBox(height: 8),
          if (subheader != null)
            Text(
              subheader,
              style: getTextStyle('small', color: AppColors.lightTeal),
            ),
        ],
      ),
    ),
  );
}

Widget buildDecoratedInput(String text, IconData icon) {
  return InputDecorator(
    decoration: buildInputDecoration(""),
    child: Row(
      children: [
        Icon(icon, color: Colors.grey),
        addHorizontalSpace(8),
        Expanded(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: getTextStyle(
              'medium',
              color: Colors.grey,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildBackground(String background) {
  return Positioned.fill(
    child: Image.asset(
      'assets/images/$background.png',
      fit: BoxFit.cover,
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
