import 'dart:convert';

import 'package:campconnect/models/student.dart';
import 'package:campconnect/repositories/camp_connect_repo.dart';
import 'package:campconnect/routes/app_router.dart';
import 'package:campconnect/services/auth_services.dart';
import 'package:campconnect/theme/constants.dart';
import 'package:campconnect/utils/helper_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../models/user.dart';
import '../../providers/show_nav_bar_provider.dart';

class StudentOnboardingScreen extends ConsumerStatefulWidget {
  final User user;

  const StudentOnboardingScreen({super.key, required this.user});

  @override
  ConsumerState<StudentOnboardingScreen> createState() =>
      _StudentOnboardingScreenState();
}

class _StudentOnboardingScreenState
    extends ConsumerState<StudentOnboardingScreen> {
  late Student student;

  Student initializeStudent(User user) {
    final student = Student(
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      dateOfBirth: user.dateOfBirth,
      nationality: user.nationality,
      primaryLanguages: user.primaryLanguages,
      phoneCode: user.phoneCode,
      mobileNumber: user.mobileNumber,
      email: user.email,
      currentEducationLevel: '',
      guardianContact: '',
      guardianPhoneCode: '',
      preferredDistanceForCamps: '',
      preferredSubjects: [],
    );
    return student;
  }

  final TextEditingController txtEmergencyPhoneNumberController =
      TextEditingController();
  final TextEditingController txtSpecialNeedsController =
      TextEditingController();
  final TextEditingController txtLearningGoalsController =
      TextEditingController();

  String emergencyUserPhoneCode = '';

  final FocusNode emergencyPhoneFocus = FocusNode();
  final FocusNode specialNeedsFocus = FocusNode();
  final FocusNode learningGoalsFocus = FocusNode();

  final PageController pageController = PageController();

  int currentPage = 0;
  String selectedEducationLevel = "Select Level";
  List<String> educationLevels = [];
  List<String> subjects = [];
  List<String> selectedSubjects = [];
  String selectedDistance = "Select Distance";

  @override
  void initState() {
    super.initState();
    ref.read(showNavBarNotifierProvider.notifier);
    student = initializeStudent(widget.user);
    loadDetailsData();
  }

  Future<void> loadDetailsData() async {
    try {
      final educationLevelData = await DefaultAssetBundle.of(context)
          .loadString("assets/data/education_level.json");
      educationLevels =
          List<String>.from(json.decode(educationLevelData) as List);

      final subjectsData = await DefaultAssetBundle.of(context)
          .loadString("assets/data/subjects.json");
      subjects = List<String>.from(json.decode(subjectsData) as List);

      setState(() {});
    } catch (error) {
      debugPrint("Error loading dropdown data: $error");
    }
  }

  @override
  void dispose() {
    txtEmergencyPhoneNumberController.dispose();
    txtSpecialNeedsController.dispose();
    txtLearningGoalsController.dispose();
    emergencyPhoneFocus.dispose();
    specialNeedsFocus.dispose();
    learningGoalsFocus.dispose();
    pageController.dispose();
    super.dispose();
  }

  bool isAllFilled() {
    return txtEmergencyPhoneNumberController.text.trim().isNotEmpty &&
        emergencyUserPhoneCode.isNotEmpty &&
        selectedEducationLevel != "Select Level" &&
        selectedSubjects.isNotEmpty &&
        selectedDistance != "Select Distance";
  }

  void handleRegisterStudent() async {
    void showCustomSnackBar(String message,
        {Color? backgroundColor, IconData? icon}) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.create(
          message: message,
          backgroundColor: backgroundColor,
          icon: icon,
        ),
      );
    }

    if (!isAllFilled()) {
      showCustomSnackBar(
        'All fields are required. Please complete the form.',
        backgroundColor: AppColors.orange,
        icon: Icons.error,
      );
      return;
    }

    try {
      final authService = AuthService();
      final firebaseUser = await authService.signup(
        email: widget.user.email,
        password: widget.user.password,
        firstName: widget.user.firstName,
        lastName: widget.user.lastName,
      );

      final updatedStudent = student.copyWith(
        guardianContact: txtEmergencyPhoneNumberController.text.trim(),
        guardianPhoneCode: emergencyUserPhoneCode,
        specialNeeds: txtSpecialNeedsController.text.trim(),
        learningGoals: txtLearningGoalsController.text.trim(),
        currentEducationLevel: selectedEducationLevel,
        preferredSubjects: selectedSubjects,
        preferredDistanceForCamps: selectedDistance,
      );

      final repo = CampConnectRepo(
        studentsRef: FirebaseFirestore.instance.collection('students'),
        teachersRef: FirebaseFirestore.instance.collection('teachers'),
        campsRef: FirebaseFirestore.instance.collection('camps'),
        classesRef: FirebaseFirestore.instance.collection('classes'),
      );

      await repo.addStudent(updatedStudent);

      showCustomSnackBar("You have registered successfully!",
          icon: Icons.check_circle);

      ref.read(showNavBarNotifierProvider.notifier).setActiveBottomNavBar(0);
      context.goNamed(AppRouter.home.name);
    } catch (error) {
      showCustomSnackBar("There has been an error with your registration.",
          icon: Icons.error);
    }
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
                  FirstPageContent(
                    emergencyPhoneField: buildEmergencyPhoneField(),
                    specialNeedsField: buildSpecialNeedsField(),
                  ),
                  SecondPageContent(
                    selectedEducationLevel: selectedEducationLevel,
                    onEducationLevelChanged: (level) {
                      setState(() {
                        selectedEducationLevel = level;
                      });
                    },
                    educationLevels: educationLevels,
                    subjects: subjects,
                    selectedSubjects: selectedSubjects,
                    onSubjectsChanged: (subject) {
                      setState(() {
                        if (selectedSubjects.contains(subject)) {
                          selectedSubjects.remove(subject);
                        } else {
                          selectedSubjects.add(subject);
                        }
                      });
                    },
                    learningGoalsField: buildLearningGoalsField(),
                  ),
                  ThirdPageContent(
                    selectedDistance: selectedDistance,
                    onDistanceChanged: (distance) {
                      setState(() {
                        selectedDistance = distance;
                      });
                    },
                  ),
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
                    count: 3,
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
                        if (currentPage < 2) {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        } else {
                          handleRegisterStudent();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                      ),
                      child: Text(
                        currentPage < 2 ? "NEXT" : "FINISH",
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

  Widget buildEmergencyPhoneField() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Emergency Phone",
              textAlign: TextAlign.start,
              style: getTextStyle("small", color: AppColors.lightTeal),
            ),
          ],
        ),
        addVerticalSpace(8),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                showCountryPicker(
                  context: context,
                  useSafeArea: true,
                  showPhoneCode: true,
                  onSelect: (Country country) {
                    setState(() {
                      emergencyUserPhoneCode = '+${country.phoneCode}';
                    });
                  },
                  countryListTheme: CountryListThemeData(
                    bottomSheetHeight: screenHeight(context) * .7,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),
                  showSearch: false,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.lightTeal,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      emergencyUserPhoneCode.isNotEmpty
                          ? "+$emergencyUserPhoneCode"
                          : "Phone Code",
                      style: getTextStyle("smallBold", color: Colors.white),
                    ),
                    addHorizontalSpace(8),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: buildTextField(
                controller: txtEmergencyPhoneNumberController,
                focusNode: emergencyPhoneFocus,
                keyboardType: TextInputType.phone,
                hintText: 'Phone Number',
                prefixIcon: const Icon(Icons.emergency, color: Colors.grey),
              ),
            ),
          ],
        ),
        addVerticalSpace(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              textAlign: TextAlign.end,
              wrapText(
                  "* If you are below 15, we need your parent or guardian's number",
                  40),
              style: getTextStyle("small", color: AppColors.lightTeal),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSpecialNeedsField() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Special Needs",
              textAlign: TextAlign.start,
              style: getTextStyle("small", color: AppColors.lightTeal),
            ),
          ],
        ),
        addVerticalSpace(8),
        buildTextArea(
          controller: txtSpecialNeedsController,
          hintText: "Enter Special Needs",
          prefixIcon: const Icon(Icons.accessibility_new, color: Colors.grey),
          focusNode: specialNeedsFocus,
          keyboardType: TextInputType.text,
        ),
        addVerticalSpace(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              textAlign: TextAlign.end,
              wrapText(
                  "* Providing this information will help us tailor the experience to your needs",
                  40),
              style: getTextStyle("small", color: AppColors.lightTeal),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildLearningGoalsField() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Learning Goals",
              textAlign: TextAlign.start,
              style: getTextStyle("small", color: AppColors.lightTeal),
            ),
          ],
        ),
        addVerticalSpace(8),
        buildTextArea(
          controller: txtLearningGoalsController,
          hintText: "Enter Goals",
          prefixIcon: const Icon(Icons.star, color: Colors.grey),
          focusNode: learningGoalsFocus,
          keyboardType: TextInputType.text,
        ),
        addVerticalSpace(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              textAlign: TextAlign.end,
              wrapText(
                  "* Sharing your learning goals helps us create a personalized learning experience",
                  33),
              style: getTextStyle("small", color: AppColors.lightTeal),
            ),
          ],
        ),
      ],
    );
  }
}

class FirstPageContent extends StatelessWidget {
  final Widget emergencyPhoneField;
  final Widget specialNeedsField;

  const FirstPageContent({
    super.key,
    required this.emergencyPhoneField,
    required this.specialNeedsField,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildHeader("Before we get started...",
            "Provide essential details to ensure your safety and comfort."),
        addVerticalSpace(64),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            child: Column(
              children: [
                emergencyPhoneField,
                addVerticalSpace(24),
                specialNeedsField,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SecondPageContent extends StatelessWidget {
  final String selectedEducationLevel;
  final ValueChanged<String> onEducationLevelChanged;
  final List<String> educationLevels;
  final List<String> subjects;
  final List<String> selectedSubjects;
  final ValueChanged<String> onSubjectsChanged;
  final Widget learningGoalsField;

  const SecondPageContent({
    super.key,
    required this.selectedEducationLevel,
    required this.onEducationLevelChanged,
    required this.educationLevels,
    required this.subjects,
    required this.selectedSubjects,
    required this.onSubjectsChanged,
    required this.learningGoalsField,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildHeader(
          "Education Details",
          "Tell us about your educational background and preferences.",
        ),
        addVerticalSpace(64),
        SizedBox(
          height: 420,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildEducationalLevel(context),
                addVerticalSpace(24),
                buildPreferredSubjects(context),
                addVerticalSpace(24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: learningGoalsField,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPreferredSubjects(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Preferred Subjects",
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
                "Select Subjects",
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
                              if (!selectedSubjects.contains(subjects[index])) {
                                onSubjectsChanged(subjects[index]);
                              }
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
            children: selectedSubjects
                .map(
                  (subject) => Chip(
                    backgroundColor: AppColors.lightTeal,
                    label: Text(
                      subject,
                      style: getTextStyle('small', color: Colors.white),
                    ),
                    deleteIcon: const Icon(Icons.close, color: Colors.white),
                    onDeleted: () {
                      onSubjectsChanged(subject);
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
      ),
    );
  }

  Widget buildEducationalLevel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Educational Level",
                textAlign: TextAlign.start,
                style: getTextStyle("small", color: AppColors.lightTeal),
              ),
            ],
          ),
          addVerticalSpace(8),
          GestureDetector(
            onTap: () => showCupertinoModalPopup(
              context: context,
              builder: (_) {
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
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 250,
                        child: CupertinoPicker(
                          itemExtent: 32,
                          onSelectedItemChanged: (index) {
                            onEducationLevelChanged(educationLevels[index]);
                          },
                          children: educationLevels
                              .map((level) => Text(
                                    level,
                                    style: getTextStyle('medium',
                                        color: Colors.black),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            child: buildDecoratedInput(selectedEducationLevel, Icons.school),
          ),
          addVerticalSpace(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                textAlign: TextAlign.end,
                wrapText("* Help us offer better learning for you", 40),
                style: getTextStyle("small", color: AppColors.lightTeal),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ThirdPageContent extends StatelessWidget {
  final String selectedDistance;
  final ValueChanged<String> onDistanceChanged;

  const ThirdPageContent({
    super.key,
    required this.selectedDistance,
    required this.onDistanceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildHeader("Camp Preferences",
            "Let us know your preferred distance for camps."),
        addVerticalSpace(64),
        buildPreferredDistance(context),
      ],
    );
  }

  Widget buildPreferredDistance(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Preferred Distance to Camps",
                textAlign: TextAlign.start,
                style: getTextStyle("small", color: AppColors.lightTeal),
              ),
            ],
          ),
          addVerticalSpace(8),
          GestureDetector(
            onTap: () => showCupertinoModalPopup(
              context: context,
              builder: (_) {
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
                              onDistanceChanged("${tempIndex * 5} km");
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
                          children: List.generate(
                            5,
                            (index) => Text(
                              "${index * 5} km",
                              style:
                                  getTextStyle('medium', color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            child: buildDecoratedInput(selectedDistance, Icons.straighten),
          ),
          addVerticalSpace(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                textAlign: TextAlign.end,
                wrapText(
                    "* Indicating your preferred distance helps us find options near you",
                    38),
                style: getTextStyle("small", color: AppColors.lightTeal),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
