import 'package:campconnect/widgets/section_title_with_icon.dart';
import 'package:flutter/material.dart';

class DetailsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const DetailsSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SectionTitleWithIcon(
        icon: icon,
        title: title,
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
