import 'package:flutter/material.dart';

import '../theme/constants.dart';

Container iconContainer(IconData icon,
    {Color iconColor = Colors.white,
    Color? backgroundColor = AppColors.lightTeal}) {
  return Container(
    height: 30,
    width: 30,
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Icon(
      icon,
      color: iconColor,
    ),
  );
}
