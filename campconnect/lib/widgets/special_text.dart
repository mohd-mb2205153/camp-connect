import 'package:campconnect/theme/styling_constants.dart';
import 'package:flutter/material.dart';

Widget specialText(String value) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        padding: const EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 8.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Text(
          value,
          style: getTextStyle('smallBold', color: AppColors.teal),
        ),
      ),
    ],
  );
}
