import 'package:campconnect/theme/styling_constants.dart';
import 'package:flutter/material.dart';

class SectionTitleWithIcon extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  final bool centerTitle;

  const SectionTitleWithIcon({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment:
              centerTitle ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: AppColors.darkBlue,
            ),
            const SizedBox(width: 8, height: 8),
            Text(
              title,
              style: getTextStyle('mediumBold', color: AppColors.darkBlue),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
