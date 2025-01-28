import 'dart:convert';

import 'package:campconnect/models/camp.dart';
import 'package:campconnect/providers/camp_provider.dart';
import 'package:campconnect/providers/teacher_provider.dart';
import 'package:campconnect/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:campconnect/theme/constants.dart';
import 'package:campconnect/utils/helper_widgets.dart';

import '../../providers/loggedinuser_provider.dart';
import '../../providers/show_nav_bar_provider.dart';

class AddCampScreen extends ConsumerStatefulWidget {
  final String location;
  const AddCampScreen({super.key, required this.location});

  @override
  ConsumerState<AddCampScreen> createState() => _AddCampScreenState();
}

class _AddCampScreenState extends ConsumerState<AddCampScreen> {
  bool isStudent = false;
  bool isTeacher = false;
  dynamic loggedUser;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final statusOfResourcesController = TextEditingController();

  final FocusNode campNameFocus = FocusNode();
  final FocusNode campDescriptionFocus = FocusNode();
  final FocusNode campStatusOfResourcesFocus = FocusNode();

  String? locationString;
  List<String>? latlng;
  double? latitude;
  double? longitude;
  LatLng? location;
  String? address;

  late List<String> additionalSupports = [];
  List<String> selectedAdditionalSupports = [];
  late List<String> educationalLevelOptions = [];
  List<String> selectedEducationalLevels = [];

  late List<String> languageOptions = [];
  List<String> selectedLanguages = [];

  @override
  void initState() {
    super.initState();
    locationString = widget.location;
    latlng = locationString!.split("|");
    latitude = double.parse(latlng![0]);
    longitude = double.parse(latlng![1]);
    address = latlng![2];
    location = LatLng(latitude!, longitude!);
    loadAdditionalSupports();
    loadEducationalLevels();
    loadLanguages();
    initializeUserDetails();
    Future.microtask(() {
      ref.read(showNavBarNotifierProvider.notifier).showBottomNavBar(false);
    });
  }

  void initializeUserDetails() {
    Future.microtask(() {
      final userNotifier = ref.read(loggedInUserNotifierProvider.notifier);

      loggedUser = userNotifier.teacher;

      ref.read(showNavBarNotifierProvider.notifier).showBottomNavBar(true);

      setState(() {});
    });
  }

  Future<void> loadAdditionalSupports() async {
    try {
      final data = await DefaultAssetBundle.of(context)
          .loadString("assets/data/additional_support.json");
      final parsedData = json.decode(data) as Map<String, dynamic>;
      additionalSupports = (parsedData["additionalSupport"] as List<dynamic>)
          .map<String>((e) => e["label"] as String)
          .toList();
      setState(() {});
    } catch (error) {
      debugPrint("Error loading additional supports data: $error");
    }
  }

  Future<void> loadEducationalLevels() async {
    try {
      final data = await DefaultAssetBundle.of(context)
          .loadString("assets/data/education_level.json");
      educationalLevelOptions = List<String>.from(json.decode(data) as List);
      setState(() {});
    } catch (error) {
      debugPrint("Error loading educational levels data: $error");
    }
  }

  Future<void> loadLanguages() async {
    try {
      final langJson = await DefaultAssetBundle.of(context)
          .loadString("assets/data/lang.json");
      languageOptions = (json.decode(langJson) as List)
          .map((item) => item["name"] as String)
          .toList();
      setState(() {});
    } catch (error) {
      debugPrint("Error loading languages data: $error");
    }
  }

  void addCamp() {
    if (nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        selectedEducationalLevels.isNotEmpty) {
      final newCamp = Camp(
        name: nameController.text,
        educationLevel: selectedEducationalLevels,
        description: descriptionController.text,
        latitude: latitude!,
        longitude: longitude!,
        statusOfResources: statusOfResourcesController.text,
        additionalSupport: selectedAdditionalSupports,
        languages: selectedLanguages,
      );

      try {
        ref.read(campProviderNotifier.notifier).addCamp(newCamp, loggedUser.id);

        if (loggedUser != null) {
          ref
              .read(teacherProviderNotifier.notifier)
              .addCampToTeacher(loggedUser, newCamp);
        }

        ref.read(showNavBarNotifierProvider.notifier).showBottomNavBar(true);
        ref.read(showNavBarNotifierProvider.notifier).setActiveBottomNavBar(1);

        context.goNamed(AppRouter.map.name);
      } catch (e) {
        customSnackbar(message: "Failed to add camp: $e", icon: Icons.error);
      }
    } else {
      customSnackbar(
          message: "Please fill in all required fields.", icon: Icons.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          ref.read(showNavBarNotifierProvider.notifier).showBottomNavBar(true);
          Navigator.of(context).pop(result);
        }
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: AppColors.lightTeal,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              ref
                  .read(showNavBarNotifierProvider.notifier)
                  .showBottomNavBar(true);
              context.pop();
            },
          ),
          title: Text(
            'Add Camp Details',
            style: getTextStyle("mediumBold", color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                addVerticalSpace(12),
                Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Camp Name",
                              textAlign: TextAlign.start,
                              style: getTextStyle("small",
                                  color: AppColors.lightTeal),
                            ),
                          ],
                        ),
                        buildTextField(
                          controller: nameController,
                          hintText: "Enter Camp Name",
                          focusNode: campNameFocus,
                          prefixIcon: Icon(
                            Icons.add_home,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                addVerticalSpace(12),
                Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Camp Description",
                              textAlign: TextAlign.start,
                              style: getTextStyle("small",
                                  color: AppColors.lightTeal),
                            ),
                          ],
                        ),
                        buildTextArea(
                          controller: descriptionController,
                          hintText: "Enter camp details here",
                          focusNode: campDescriptionFocus,
                          prefixIcon: Icon(
                            Icons.assignment,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                addVerticalSpace(12),
                buildEducationLevelsPicker(),
                addVerticalSpace(12),
                Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Status of Resources",
                              textAlign: TextAlign.start,
                              style: getTextStyle("small",
                                  color: AppColors.lightTeal),
                            ),
                          ],
                        ),
                        buildTextArea(
                          controller: statusOfResourcesController,
                          hintText: "Enter the status of resources",
                          focusNode: campStatusOfResourcesFocus,
                          prefixIcon: Icon(
                            Icons.water,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                addVerticalSpace(12),
                buildAdditionalSupportPicker(),
                addVerticalSpace(12),
                buildLanguages(),
                addVerticalSpace(16),
                Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          if (nameController.text.isNotEmpty &&
                              descriptionController.text.isNotEmpty &&
                              selectedEducationalLevels.isNotEmpty) {
                            addCamp();
                            ref
                                .read(showNavBarNotifierProvider.notifier)
                                .showBottomNavBar(true);
                            ref
                                .read(showNavBarNotifierProvider.notifier)
                                .setActiveBottomNavBar(1);
                          } else {
                            customSnackbar(
                                message: "Please fill in all required fields.",
                                icon: Icons.error);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightTeal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12), // Padding
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // Rounded corners
                          ),
                          elevation: 4, // Shadow elevation
                        ),
                        child: Text(
                          "Add Camp",
                          style: getTextStyle("medium", color: Colors.white),
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEducationalLevelPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.language, color: Colors.grey),
            addHorizontalSpace(10),
            Text(
              "Add Educational Levels",
              style: getTextStyle('medium', color: Colors.grey),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.grey,
              ),
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
                      itemCount: educationalLevelOptions.length,
                      itemBuilder: (_, index) {
                        return ListTile(
                          title: Text(
                            educationalLevelOptions[index],
                            style: getTextStyle("small"),
                          ),
                          onTap: () {
                            setState(() {
                              if (!selectedEducationalLevels
                                  .contains(educationalLevelOptions[index])) {
                                selectedEducationalLevels
                                    .add(educationalLevelOptions[index]);
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
        const Divider(
          color: AppColors.lightTeal,
          thickness: 2,
        ),
        addVerticalSpace(8),
        Wrap(
          spacing: 8,
          children: selectedEducationalLevels
              .map(
                (level) => Chip(
                  backgroundColor: AppColors.lightTeal,
                  label: Text(
                    level,
                    style: getTextStyle('small', color: Colors.white),
                  ),
                  deleteIcon: const Icon(Icons.close, color: Colors.white),
                  onDeleted: () {
                    setState(() {
                      selectedEducationalLevels.remove(level);
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

  Widget buildEducationLevelsPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Education Levels",
              textAlign: TextAlign.start,
              style: getTextStyle("small", color: AppColors.lightTeal),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.book, color: Colors.grey),
            const SizedBox(width: 10),
            Text(
              "Education Levels",
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
                      itemCount: educationalLevelOptions.length,
                      itemBuilder: (_, index) {
                        return ListTile(
                          title: Text(
                            educationalLevelOptions[index],
                            style: getTextStyle("small"),
                          ),
                          onTap: () {
                            setState(() {
                              if (!selectedEducationalLevels
                                  .contains(educationalLevelOptions[index])) {
                                selectedEducationalLevels
                                    .add(educationalLevelOptions[index]);
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
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: selectedEducationalLevels
              .map(
                (subject) => Chip(
                  backgroundColor: AppColors.lightTeal,
                  label: Text(
                    subject,
                    style: getTextStyle('small', color: Colors.white),
                  ),
                  deleteIcon: const Icon(Icons.close, color: Colors.white),
                  onDeleted: () {
                    setState(() {
                      selectedEducationalLevels.remove(subject);
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

  Widget buildAdditionalSupportPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Additional Supports",
              textAlign: TextAlign.start,
              style: getTextStyle("small", color: AppColors.lightTeal),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.book, color: Colors.grey),
            const SizedBox(width: 10),
            Text(
              "Additional Supports",
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
                      itemCount: additionalSupports.length,
                      itemBuilder: (_, index) {
                        return ListTile(
                          title: Text(
                            additionalSupports[index],
                            style: getTextStyle("small"),
                          ),
                          onTap: () {
                            setState(() {
                              if (!selectedAdditionalSupports
                                  .contains(additionalSupports[index])) {
                                selectedAdditionalSupports
                                    .add(additionalSupports[index]);
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
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: selectedAdditionalSupports
              .map(
                (subject) => Chip(
                  backgroundColor: AppColors.lightTeal,
                  label: Text(
                    subject,
                    style: getTextStyle('small', color: Colors.white),
                  ),
                  deleteIcon: const Icon(Icons.close, color: Colors.white),
                  onDeleted: () {
                    setState(() {
                      selectedAdditionalSupports.remove(subject);
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

  Widget buildLanguages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Add Languages",
                  textAlign: TextAlign.start,
                  style: getTextStyle("small", color: AppColors.lightTeal),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.language, color: Colors.grey),
                addHorizontalSpace(10),
                Text(
                  "Add Languages",
                  style: getTextStyle('medium', color: Colors.grey),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.grey,
                  ),
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
                          itemCount: languageOptions.length,
                          itemBuilder: (_, index) {
                            return ListTile(
                              title: Text(
                                languageOptions[index],
                                style: getTextStyle("small"),
                              ),
                              onTap: () {
                                setState(() {
                                  if (!selectedLanguages
                                      .contains(languageOptions[index])) {
                                    selectedLanguages
                                        .add(languageOptions[index]);
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
            const Divider(
              color: AppColors.lightTeal,
              thickness: 2,
            ),
          ],
        ),
        addVerticalSpace(8),
        Wrap(
          spacing: 8,
          children: selectedLanguages
              .map(
                (language) => Chip(
                  backgroundColor: AppColors.lightTeal,
                  label: Text(
                    language,
                    style: getTextStyle('small', color: Colors.white),
                  ),
                  deleteIcon: const Icon(Icons.close, color: Colors.white),
                  onDeleted: () {
                    setState(() {
                      selectedLanguages.remove(language);
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
}
