import 'package:flutter/material.dart';
const String google_api_key = "AIzaSyCMX24A8UlDx3KUNqHSXZdwB1MB-pd1Bfo";
class AppColors {
  static const lightTeal = Color(0xFF36B6B6);
  static const teal = Color(0xFF009999);
  static const darkTeal = Color(0xFF00646E);
  static const grey = Color(0xFF889BAA);
  static const beige = Color(0xFFCCCCCC);
  static const darkBeige = Color(0xFFABAA96);
  static const white = Color(0xFFFFFFFF);
  static const blue = Color(0xFF50BED7);
  static const darkBlue = Color(0xFF005F87);
  static const orange = Color.fromARGB(255, 239, 148, 57);
}

class AppTextStyles {
  static const smallLight = TextStyle(
      fontFamily: 'DMSans', fontSize: 14, fontWeight: FontWeight.w100);
  static const mediumLight = TextStyle(
      fontFamily: 'DMSans', fontSize: 18, fontWeight: FontWeight.w100);
  static const largeLight = TextStyle(
      fontFamily: 'DMSans', fontSize: 22, fontWeight: FontWeight.w100);
  static const xlargeLight = TextStyle(
      fontFamily: 'DMSans', fontSize: 28, fontWeight: FontWeight.w100);
  static const xxlargeLight = TextStyle(
      fontFamily: 'DMSans', fontSize: 36, fontWeight: FontWeight.w100);

  static const small = TextStyle(
      fontFamily: 'DMSans', fontSize: 14, fontWeight: FontWeight.normal);
  static const medium = TextStyle(
      fontFamily: 'DMSans', fontSize: 18, fontWeight: FontWeight.normal);
  static const large = TextStyle(
      fontFamily: 'DMSans', fontSize: 22, fontWeight: FontWeight.normal);
  static const xlarge = TextStyle(
      fontFamily: 'DMSans', fontSize: 28, fontWeight: FontWeight.normal);
  static const xxlarge = TextStyle(
      fontFamily: 'DMSans', fontSize: 36, fontWeight: FontWeight.normal);

  static const smallBold = TextStyle(
      fontFamily: 'DMSans', fontSize: 14, fontWeight: FontWeight.w700);
  static const mediumBold = TextStyle(
      fontFamily: 'DMSans', fontSize: 18, fontWeight: FontWeight.w700);
  static const largeBold = TextStyle(
      fontFamily: 'DMSans', fontSize: 22, fontWeight: FontWeight.w700);
  static const xlargeBold = TextStyle(
      fontFamily: 'DMSans', fontSize: 28, fontWeight: FontWeight.w700);
  static const xxlargeBold = TextStyle(
      fontFamily: 'DMSans', fontSize: 36, fontWeight: FontWeight.w700);
}

TextStyle getTextStyle(String size, {Color? color}) {
  const textStyles = {
    'smallLight': AppTextStyles.smallLight,
    'mediumLight': AppTextStyles.mediumLight,
    'largeLight': AppTextStyles.largeLight,
    'xlargeLight': AppTextStyles.xlargeLight,
    'xxlargeLight': AppTextStyles.xxlargeLight,
    'small': AppTextStyles.small,
    'medium': AppTextStyles.medium,
    'large': AppTextStyles.large,
    'xlarge': AppTextStyles.xlarge,
    'xxlarge': AppTextStyles.xxlarge,
    'smallBold': AppTextStyles.smallBold,
    'mediumBold': AppTextStyles.mediumBold,
    'largeBold': AppTextStyles.largeBold,
    'xlargeBold': AppTextStyles.xlargeBold,
    'xxlargeBold': AppTextStyles.xxlargeBold,
  };
  return textStyles[size]?.copyWith(color: color ?? Colors.black) ??
      TextStyle(color: color ?? Colors.black);
}

  // static Color getStatusColor(String status) {
  //   switch (status) {
  //     case 'Awaiting':
  //       return Colors.yellow;
  //     case 'Deposited':
  //       return AppColors.grey;
  //     case 'Cashed':
  //       return Colors.green;
  //     default:
  //       return Colors.red;
  //   }
  // }