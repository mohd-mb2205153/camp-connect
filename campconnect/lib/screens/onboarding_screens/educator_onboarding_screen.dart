import 'dart:convert';
import 'package:campconnect/routes/app_router.dart';
import 'package:campconnect/utils/helper_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../providers/show_nav_bar_provider.dart';
import '../../theme/constants.dart';

class EducatorOnboardingScreen extends ConsumerStatefulWidget {
  const EducatorOnboardingScreen({super.key});

  @override
  ConsumerState<EducatorOnboardingScreen> createState() =>
      _EducatorOnboardingScreenState();
}

class _EducatorOnboardingScreenState
    extends ConsumerState<EducatorOnboardingScreen> {
  TimeOfDay fromTime = TimeOfDay.now();
  TimeOfDay toTime = TimeOfDay.fromDateTime(
    DateTime.now().add(const Duration(hours: 1)),
  );
  final TextEditingController txtCertificationsController =
      TextEditingController();

  final FocusNode certificationFocus = FocusNode();

  final List<String> certifications = [];
  final List<String> areasOfExpertise = [];
  final PageController pageController = PageController();

  int currentPage = 0;
  String highestEducationLevel = "Select Education Level";
  List<String> educationLevels = [];

  int teachingExperience = 0;

  String willingnessToTravel = "Select Distance";
  String availabilitySchedule = "Select Time";
  String preferredCampDuration = "Select Duration";
  List<String> campDurations = [];
  List<String> subjects = [];

  @override
  void initState() {
    super.initState();
    ref.read(showNavBarNotifierProvider.notifier);
    loadDropdownData();
  }

  Future<void> loadDropdownData() async {
    try {
      final educationLevelData = await DefaultAssetBundle.of(context)
          .loadString("assets/data/teacher_education_level.json");
      final parsedEducationLevels = json.decode(educationLevelData) as Map;
      educationLevels = (parsedEducationLevels['concept'] as List)
          .map<String>((e) => e['display'] as String)
          .toList();

      final campDurationData = await DefaultAssetBundle.of(context)
          .loadString("assets/data/preferred_camp_duration.json");
      campDurations = List<String>.from(json.decode(campDurationData));

      final subjectsData = await DefaultAssetBundle.of(context)
          .loadString("assets/data/subjects.json");
      subjects = List<String>.from(json.decode(subjectsData));

      setState(() {});
    } catch (error) {
      debugPrint("Error loading dropdown data: $error");
    }
  }

  @override
  void dispose() {
    txtCertificationsController.dispose();
    certificationFocus.dispose();
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
        extendBodyBehindAppBar: true,
        appBar: buildAppBar(context),
        body: Column(
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
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
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: currentPage > 0
                          ? () {
                              pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        disabledForegroundColor: Colors.transparent,
                        disabledBackgroundColor: Colors.transparent,
                      ),
                      child: Text(
                        "BACK",
                        style: getTextStyle(
                          "small",
                          color: currentPage > 0
                              ? Colors.grey
                              : Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: pageController,
                    count: 2,
                    effect: const WormEffect(
                      dotHeight: 6,
                      dotWidth: 6,
                      spacing: 8,
                      dotColor: Colors.grey,
                      activeDotColor: AppColors.lightTeal,
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        if (currentPage < 1) {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        } else {
                          ref
                              .read(showNavBarNotifierProvider.notifier)
                              .setActiveBottomNavBar(0);
                          context.goNamed(AppRouter.home.name);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                      ),
                      child: Text(
                        currentPage < 1 ? "NEXT" : "FINISH",
                        style: getTextStyle(
                          "small",
                          color: AppColors.lightTeal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFirstPage() {
    return Column(
      children: [
        buildHeader(
          "Educational Background",
          "Tell us about your qualifications and areas of expertise.",
        ),
        addVerticalSpace(64),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            height: 400,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildEducationLevelPicker(),
                  addVerticalSpace(24),
                  buildCertificationsInput(),
                  addVerticalSpace(24),
                  buildTeachingExperiencePicker(),
                  addVerticalSpace(24),
                  buildAreasOfExpertiseInput(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSecondPage() {
    return Column(
      children: [
        buildHeader(
          "Your Preferences",
          "Help us understand your needs to create the best experience.",
        ),
        addVerticalSpace(64),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              buildWillingnessToTravelPicker(),
              addVerticalSpace(24),
              buildAvailabilityPicker(),
              addVerticalSpace(24),
              buildCampDurationPicker(),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildAreasOfExpertiseInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Areas of Expertise",
              textAlign: TextAlign.start,
              style: getTextStyle("small", color: AppColors.lightTeal),
            ),
          ],
        ),
        addVerticalSpace(8),
        Row(
          children: [
            Icon(Icons.book, color: Colors.grey),
            addHorizontalSpace(10),
            Text(
              "Areas of Expertise",
              style: getTextStyle('medium', color: Colors.grey),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.grey),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  builder: (_) {
                    return ListView.builder(
                      itemCount: subjects.length,
                      itemBuilder: (_, index) {
                        return ListTile(
                          title: Text(
                            subjects[index],
                            style: getTextStyle("small"),
                          ),
                          onTap: () {
                            setState(() {
                              if (!areasOfExpertise.contains(subjects[index])) {
                                areasOfExpertise.add(subjects[index]);
                              }
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
        const Divider(color: AppColors.lightTeal, thickness: 2),
        addVerticalSpace(8),
        Wrap(
          spacing: 8,
          children: areasOfExpertise
              .map(
                (expertise) => Chip(
                  backgroundColor: AppColors.lightTeal,
                  label: Text(
                    expertise,
                    style: getTextStyle('small', color: Colors.white),
                  ),
                  deleteIcon: const Icon(Icons.close, color: Colors.white),
                  onDeleted: () {
                    setState(() {
                      areasOfExpertise.remove(expertise);
                    });
                  },
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget buildEducationLevelPicker() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Educational Attainment",
              textAlign: TextAlign.start,
              style: getTextStyle("small", color: AppColors.lightTeal),
            ),
          ],
        ),
        addVerticalSpace(8),
        GestureDetector(
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
        ),
      ],
    );
  }

  Widget buildCertificationsInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Relevant Certifications",
              textAlign: TextAlign.start,
              style: getTextStyle("small", color: AppColors.lightTeal),
            ),
          ],
        ),
        addVerticalSpace(8),
        buildTextField(
          controller: txtCertificationsController,
          hintText: "Add Certification",
          keyboardType: TextInputType.text,
          focusNode: certificationFocus,
          suffixIcon: IconButton(
            icon: Icon(Icons.add, color: Colors.grey),
            onPressed: () {
              final value = txtCertificationsController.text.trim();
              if (value.isNotEmpty) {
                setState(() {
                  certifications.add(value);
                  txtCertificationsController.clear();
                });
                certificationFocus.unfocus();
              }
            },
          ),
        ),
        addVerticalSpace(8),
        Wrap(
          spacing: 8,
          children: certifications
              .map(
                (cert) => Chip(
                  backgroundColor: AppColors.lightTeal,
                  label: Text(
                    cert,
                    style: getTextStyle('small', color: Colors.white),
                  ),
                  deleteIcon: const Icon(Icons.close, color: Colors.white),
                  onDeleted: () {
                    setState(() {
                      certifications.remove(cert);
                    });
                  },
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget buildTeachingExperiencePicker() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Years of Experience",
              textAlign: TextAlign.start,
              style: getTextStyle("small", color: AppColors.lightTeal),
            ),
          ],
        ),
        addVerticalSpace(8),
        GestureDetector(
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
          child:
              buildDecoratedInput("$teachingExperience years", Icons.history),
        ),
      ],
    );
  }

  Widget buildWillingnessToTravelPicker() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Willingness to Travel",
              textAlign: TextAlign.start,
              style: getTextStyle("small", color: AppColors.lightTeal),
            ),
          ],
        ),
        addVerticalSpace(8),
        GestureDetector(
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
        ),
      ],
    );
  }

  Widget buildAvailabilityPicker() {
    void showHourPicker(BuildContext context, bool isFrom) {
      showCupertinoModalPopup(
        context: context,
        builder: (_) {
          return Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                addVerticalSpace(8),
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
                        setState(() {
                          if (isFrom) {
                            if (toTime.hour <= fromTime.hour) {
                              toTime = TimeOfDay(
                                hour: (fromTime.hour + 1) % 24,
                                minute: 0,
                              );
                            }
                          } else {
                            if (toTime.hour <= fromTime.hour) {
                              toTime = TimeOfDay(
                                hour: (fromTime.hour + 1) % 24,
                                minute: 0,
                              );
                            }
                          }
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 250,
                  child: CupertinoPicker(
                    itemExtent: 32,
                    onSelectedItemChanged: (selectedHour) {
                      setState(() {
                        if (isFrom) {
                          fromTime = TimeOfDay(hour: selectedHour, minute: 0);
                        } else {
                          toTime = TimeOfDay(hour: selectedHour, minute: 0);
                        }
                      });
                    },
                    children: List.generate(
                      24,
                      (hour) => Text(
                        "$hour:00",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Availability Schedule (Contact Times)",
              textAlign: TextAlign.start,
              style: getTextStyle("small", color: AppColors.lightTeal),
            ),
          ],
        ),
        addVerticalSpace(8),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => showHourPicker(context, true),
                child: buildDecoratedInput(
                  "${fromTime.hour}:00",
                  Icons.access_time,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () => showHourPicker(context, false),
                child: buildDecoratedInput(
                  "${toTime.hour}:00",
                  Icons.access_time,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildCampDurationPicker() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Preferred Camp Duration",
              textAlign: TextAlign.start,
              style: getTextStyle("small", color: AppColors.lightTeal),
            ),
          ],
        ),
        addVerticalSpace(8),
        GestureDetector(
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
        ),
      ],
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
