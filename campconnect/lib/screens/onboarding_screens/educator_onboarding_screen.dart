import 'dart:convert';
import 'package:campconnect/utils/helper_widgets.dart';
import 'package:flutter/cupertino.dart';
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
  final TextEditingController txtCertificationsController =
      TextEditingController();

  final List<String> certifications = [];
  final List<String> areasOfExpertise = [];
  final PageController pageController = PageController();

  String highestEducationLevel = "Select Education Level";
  List<String> educationLevels = [];

  int teachingExperience = 0;

  String willingnessToTravel = "Select Distance";
  String availabilitySchedule = "Select Time";
  String preferredCampDuration = "Select Duration";
  List<String> campDurations = [];

  @override
  void initState() {
    super.initState();
    loadDropdownData();
  }

  Future<void> loadDropdownData() async {
    try {
      final educationLevelData = await DefaultAssetBundle.of(context)
          .loadString("assets/data/teacher_education_level.json");
      final parsedEducationLevels = json.decode(educationLevelData) as Map;
      educationLevels = parsedEducationLevels['concept']
          .map<String>((e) => e['display'])
          .toList();

      final campDurationData = await DefaultAssetBundle.of(context)
          .loadString("assets/data/preferred_camp_duration.json");
      campDurations = List<String>.from(json.decode(campDurationData));

      setState(() {});
    } catch (error) {
      debugPrint("Error loading dropdown data: $error");
    }
  }

  @override
  void dispose() {
    txtCertificationsController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: false,
        appBar: buildAppBar(context),
        body: Column(
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                children: [
                  buildFirstPage(),
                  buildSecondPage(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed:
                        pageController.hasClients && pageController.page! > 0
                            ? () {
                                pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease,
                                );
                              }
                            : null,
                    child: const Text("BACK"),
                  ),
                  ElevatedButton(
                    onPressed:
                        pageController.hasClients && pageController.page! < 1
                            ? () {
                                pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease,
                                );
                              }
                            : null,
                    child: Text(
                        pageController.hasClients && pageController.page == 1
                            ? "FINISH"
                            : "NEXT"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildFirstPage() {
    return Column(
      children: [
        buildHeader("Educational Background", ""),
        addVerticalSpace(24),
        buildEducationLevelPicker(),
        addVerticalSpace(24),
        buildCertificationsInput(),
        addVerticalSpace(24),
        buildTeachingExperiencePicker(),
        addVerticalSpace(24),
        buildAreasOfExpertiseInput(),
      ],
    );
  }

  Widget buildSecondPage() {
    return Column(
      children: [
        buildHeader("Preferences", ""),
        addVerticalSpace(24),
        buildWillingnessToTravelPicker(),
        addVerticalSpace(24),
        buildAvailabilityPicker(),
        addVerticalSpace(24),
        buildCampDurationPicker(),
      ],
    );
  }

  Widget buildEducationLevelPicker() {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          builder: (_) {
            return buildManualCupertinoPicker(
              title: "Select Education Level",
              items: educationLevels,
              onSelected: (index) {
                setState(() {
                  highestEducationLevel = educationLevels[index];
                });
              },
            );
          },
        );
      },
      child: buildDecoratedInput(highestEducationLevel, Icons.school),
    );
  }

  Widget buildCertificationsInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: txtCertificationsController,
          decoration: InputDecoration(
            hintText: "Add Certification",
          ),
          onSubmitted: (value) {
            setState(() {
              certifications.add(value);
              txtCertificationsController.clear();
            });
          },
        ),
        Wrap(
          spacing: 8,
          children: certifications
              .map(
                (cert) => Chip(
                  label: Text(cert),
                  onDeleted: () {
                    setState(() {
                      certifications.remove(cert);
                    });
                  },
                ),
              )
              .toList(),
        )
      ],
    );
  }

  Widget buildTeachingExperiencePicker() {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          builder: (_) {
            return buildManualCupertinoPicker(
              title: "Select Experience (Years)",
              items: List.generate(31, (index) => "$index years"),
              onSelected: (index) {
                setState(() {
                  teachingExperience = index;
                });
              },
            );
          },
        );
      },
      child: buildDecoratedInput("$teachingExperience years", Icons.history),
    );
  }

  Widget buildAreasOfExpertiseInput() {
    return FutureBuilder<String>(
      future: DefaultAssetBundle.of(context)
          .loadString("assets/data/subjects.json"),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        final subjects = List<String>.from(json.decode(snapshot.data!));

        return Wrap(
          spacing: 8,
          children: subjects.map((subject) {
            final isSelected = areasOfExpertise.contains(subject);
            return FilterChip(
              label: Text(subject),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    areasOfExpertise.add(subject);
                  } else {
                    areasOfExpertise.remove(subject);
                  }
                });
              },
            );
          }).toList(),
        );
      },
    );
  }

  Widget buildWillingnessToTravelPicker() {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          builder: (_) {
            return buildManualCupertinoPicker(
              title: "Select Distance",
              items: List.generate(6, (index) => "${index * 5} km"),
              onSelected: (index) {
                setState(() {
                  willingnessToTravel = "${index * 5} km";
                });
              },
            );
          },
        );
      },
      child: buildDecoratedInput(willingnessToTravel, Icons.place),
    );
  }

  Widget buildAvailabilityPicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("From:"),
        Text("To:"),
      ],
    );
  }

  Widget buildCampDurationPicker() {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          builder: (_) {
            return buildManualCupertinoPicker(
              title: "Select Camp Duration",
              items: campDurations,
              onSelected: (index) {
                setState(() {
                  preferredCampDuration = campDurations[index];
                });
              },
            );
          },
        );
      },
      child: buildDecoratedInput(preferredCampDuration, Icons.schedule),
    );
  }

  Widget buildManualCupertinoPicker({
    required String title,
    required List<String> items,
    required ValueChanged<int> onSelected,
  }) {
    int tempIndex = 0;
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              CupertinoButton(
                child: const Text("Confirm"),
                onPressed: () {
                  onSelected(tempIndex);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          SizedBox(
            height: 250,
            child: CupertinoPicker(
              itemExtent: 32,
              onSelectedItemChanged: (index) {
                tempIndex = index;
              },
              children: items
                  .map((item) => Text(
                        item,
                        style: const TextStyle(fontSize: 16),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
