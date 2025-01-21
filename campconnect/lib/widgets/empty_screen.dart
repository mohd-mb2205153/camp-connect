import 'package:flutter/material.dart';

import '../theme/constants.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.info_outline,
            color: const Color.fromARGB(179, 245, 245, 245),
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            "This screen is currently empty.",
            style: getTextStyle("medium",
                color: const Color.fromARGB(179, 245, 245, 245)),
          ),
        ],
      ),
    );
  }
}
