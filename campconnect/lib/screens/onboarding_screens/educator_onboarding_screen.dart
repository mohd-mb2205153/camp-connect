import 'package:campconnect/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EducatorOnboardingScreen extends ConsumerStatefulWidget {
  const EducatorOnboardingScreen({super.key});

  @override
  ConsumerState<EducatorOnboardingScreen> createState() =>
      _EducatorOnboardingScreenState();
}

class _EducatorOnboardingScreenState
    extends ConsumerState<EducatorOnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(context),
      body: Stack(
        children: [
          buildBackground(),
          Column(
            children: [
              buildHeader("Personal Information"),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: buildContent(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildContent(context) {
    return Column();
  }
}
