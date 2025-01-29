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
  bool readOnly = false,
  required FocusNode focusNode,
}) {
  return TextField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: obscureText,
    focusNode: focusNode,
    readOnly: readOnly,
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
        addHorizontalSpace(12),
        Icon(icon, color: Colors.grey),
        addHorizontalSpace(12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
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
        ),
      ],
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

Widget buildBackground(String background) {
  return Positioned.fill(
    child: Image.asset(
      'assets/images/$background.png',
      fit: BoxFit.cover,
    ),
  );
}

void showCustomSnackBar(
    {required String message,
    Color? backgroundColor,
    IconData? icon,
    required BuildContext context}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: getTextStyle(
                "small",
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor ?? Colors.orange,
    ),
  );
}

class ConfirmationDialog extends StatelessWidget {
  final String type;
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final bool showSnackBar;

  const ConfirmationDialog({
    super.key,
    required this.type,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.showSnackBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 0, 36, 39).withOpacity(0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Text(
        title,
        style: getTextStyle(
          "mediumBold",
          color: Colors.white,
        ),
      ),
      content: Text(
        content,
        style: getTextStyle(
          "small",
          color: Colors.white70,
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            'Cancel',
            style: getTextStyle("smallBold", color: AppColors.lightTeal),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            'Confirm',
            style: getTextStyle("smallBold", color: AppColors.lightTeal),
          ),
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
            showSnackBar
                ? ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '$type details have been updated.',
                        style: getTextStyle('small', color: AppColors.white),
                      ),
                      duration: const Duration(seconds: 3),
                      backgroundColor: AppColors.teal,
                    ),
                  )
                : null;
          },
        ),
      ],
    );
  }
}

class Assets {
  static const _imagesBasePath = "assets/images/";
  static String image(String fileName) => '$_imagesBasePath$fileName';

  static const _dataBasePath = "assets/data/";
  static String data(String fileName) => '$_dataBasePath$fileName';
}

double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;

Widget errorWidget(AsyncSnapshot<dynamic> snapshot) {
  return Text(
    '${snapshot.error.toString()} - Refresh Page.',
    style: getTextStyle(
      'medium',
      color: AppColors.white,
    ),
  );
}

Widget loadingWidget(
    {required AsyncSnapshot<dynamic> snapshot, required String label}) {
  return Center(
    child: Text(
      'Loading $label...',
      style: getTextStyle('medium', color: AppColors.white),
    ),
  );
}
