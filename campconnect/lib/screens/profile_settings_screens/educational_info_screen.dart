import 'package:campconnect/models/student.dart';
import 'package:campconnect/models/teacher.dart';
import 'package:campconnect/models/user.dart';
import 'package:campconnect/providers/json_provider.dart';
import 'package:campconnect/providers/show_bot_nav_provider.dart';
import 'package:campconnect/theme/frosted_glass.dart';
import 'package:campconnect/theme/styling_constants.dart';
import 'package:campconnect/widgets/details_row.dart';
import 'package:campconnect/widgets/edit_screen_fields.dart';
import 'package:campconnect/widgets/filter_dropdown.dart';
import 'package:campconnect/widgets/section_title_with_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EducationalInfoScreen extends ConsumerStatefulWidget {
  const EducationalInfoScreen({super.key});

  @override
  ConsumerState<EducationalInfoScreen> createState() => _EducationalInfoState();
}

class _EducationalInfoState extends ConsumerState<EducationalInfoScreen> {
  bool isEditing = false;
  String? selectedEducationLevel;
  dynamic
      user; //Testing for now, later we will get user that is logged in thru provider.

  final TextEditingController learningGoalsController = TextEditingController();
  final TextEditingController teachingExpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //Dummy value
    // user = Student(
    //   firstName: 'Ahmad',
    //   lastName: 'John',
    //   dateOfBirth: DateTime(2004, 11, 9),
    //   nationality: 'Iraq',
    //   primaryLanguages: ['Arabic', 'English'],
    //   countryCode: 'QA',
    //   mobileNumber: '3033067',
    //   email: 'enter@gmail.com',
    //   currentEducationLevel: 'High School',
    //   currentLocation: '',
    //   enrolledCamps: [],
    //   guardianContact: '44450699',
    //   guardianCountryCode: 'IN',
    //   preferredDistanceForCamps: '',
    //   preferredSubjects: [],
    //   learningGoals: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit,',
    //   specialNeeds: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
    // );

    user = Teacher(
      firstName: 'Mark',
      lastName: 'Johnny',
      dateOfBirth: DateTime(1987, 11, 9),
      nationality: 'USA',
      primaryLanguages: ['English'],
      countryCode: 'QA',
      mobileNumber: '30993067',
      phoneCode: '+974',
      email: 'mark@gmail.com',
      enrolledCamps: [],
      areasOfExpertise: [],
      availabilitySchedule: '',
      certifications: [],
      highestEducationLevel: 'Master Degree',
      preferredCampDuration: '',
      teachingExperience: 16,
      willingnessToTravel: '',
    );
  }

  @override
  void dispose() {
    teachingExpController.dispose();
    learningGoalsController.dispose();
    super.dispose();
  }

  void initializeControllers(user) {
    if (user is Teacher) {
      teachingExpController.text = user.teachingExperience.toString();
    } else if (user is Student) {
      learningGoalsController.text = user.learningGoals;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          ref.read(showBotNavNotifierProvider.notifier).showBottomNavBar(true);
          Navigator.of(context).pop(result);
        }
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 5,
          title: isEditing
              ? Text(
                  "Editing Educational Info",
                )
              : Text(
                  "Educational Information",
                ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              ref
                  .read(showBotNavNotifierProvider.notifier)
                  .showBottomNavBar(true);
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: Icon(isEditing ? Icons.done : Icons.edit),
              onPressed: () {
                setState(() {
                  if (isEditing) {
                    // UPDATE USER
                  }
                  isEditing = !isEditing;
                  if (isEditing) {
                    initializeControllers(user);
                  }
                });
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: 75,
                      height: 75,
                      decoration: const BoxDecoration(
                        color: AppColors.darkTeal,
                        shape: BoxShape.circle,
                      ),
                      child: buildIcon(user!),
                    ),
                  ),
                  Text(
                    user.role.toUpperCase(),
                    style: getTextStyle('largeBold', color: AppColors.teal),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (user.role == 'student') buildStudentInfo(),
                  if (user.role == 'teacher') buildTeacherInfo(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildStudentInfo() {
    return Column(
      children: [
        FrostedGlassBox(
          boxWidth: double.infinity,
          isCurved: true,
          boxChild: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StudentEducationSection(
              isEditing: isEditing,
              selectedEducationLevel:
                  selectedEducationLevel ?? user.currentEducationLevel,
              onEducationLevelSelected: (newLevel) {
                setState(() {
                  selectedEducationLevel = newLevel;
                });
              },
              user: user!,
            ),
          ),
        ),
        const SizedBox(height: 20),
        FrostedGlassBox(
          boxWidth: double.infinity,
          isCurved: true,
          boxChild: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LearningGoalsSection(
              isEditing: isEditing,
              controller: learningGoalsController,
              user: user,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTeacherInfo() {
    return FrostedGlassBox(
      boxWidth: double.infinity,
      isCurved: true,
      boxChild: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TeacherEducationSection(
          isEditing: isEditing,
          controller: teachingExpController,
          selectedEducationLevel:
              selectedEducationLevel ?? user.highestEducationLevel,
          onEducationLevelSelected: (newLevel) {
            setState(() {
              selectedEducationLevel = newLevel;
            });
          },
          user: user!,
        ),
      ),
    );
  }

  Widget buildIcon(User user) {
    return user.role == 'student'
        ? Stack(
            children: [
              Center(
                child: const Icon(
                  Icons.person_2_rounded,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              Positioned(
                bottom: 10,
                left: 40,
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: AppColors.darkBeige,
                  size: 20,
                ),
              ),
            ],
          )
        : Stack(
            children: [
              Center(
                child: const Icon(
                  Icons.person_2_rounded,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              Positioned(
                bottom: 10,
                left: 40,
                child: const Icon(
                  Icons.school_rounded,
                  color: AppColors.darkBeige,
                  size: 20,
                ),
              ),
            ],
          );
  }
}

class StudentEducationSection extends ConsumerWidget {
  final bool isEditing;
  final String selectedEducationLevel;
  final Function(String) onEducationLevelSelected;
  final Student user;

  const StudentEducationSection({
    super.key,
    required this.isEditing,
    required this.selectedEducationLevel,
    required this.onEducationLevelSelected,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SectionTitleWithIcon(
          icon: Icons.menu_book_rounded,
          title: 'Basic Information',
          child: Column(
            children: [
              isEditing
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        height: 48,
                        width: MediaQuery.of(context).size.width * .8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Education Level",
                              style: getTextStyle('smallBold',
                                  color: AppColors.darkBlue),
                            ),
                            ref.watch(educationLevelProvider).when(
                                  data: (data) {
                                    List<String> filteredList =
                                        data.sublist(0, 3);
                                    return FilterDropdown(
                                      selectedFilter: selectedEducationLevel,
                                      options: filteredList,
                                      onSelected: (String? newLevel) {
                                        if (newLevel != null) {
                                          onEducationLevelSelected(newLevel);
                                        }
                                      },
                                    );
                                  },
                                  loading: () =>
                                      const CircularProgressIndicator(),
                                  error: (err, stack) => Text('Error: $err'),
                                ),
                          ],
                        ),
                      ),
                    )
                  : DetailsRow(
                      label: "Education Level",
                      value: selectedEducationLevel,
                      divider: false,
                    ),
            ],
          ),
        )
      ],
    );
  }
}

class TeacherEducationSection extends ConsumerWidget {
  final bool isEditing;
  final String selectedEducationLevel;
  final Function(String) onEducationLevelSelected;
  final TextEditingController controller;
  final Teacher user;

  const TeacherEducationSection({
    super.key,
    required this.isEditing,
    required this.selectedEducationLevel,
    required this.onEducationLevelSelected,
    required this.controller,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SectionTitleWithIcon(
          icon: Icons.school_rounded,
          title: 'Basic Information',
          child: Column(
            children: [
              isEditing
                  ? Container(
                      decoration: BoxDecoration(
                        border: const Border(
                          bottom:
                              BorderSide(color: AppColors.darkBlue, width: 1),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: SizedBox(
                          height: 48,
                          width: MediaQuery.of(context).size.width * .8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Highest Degree",
                                style: getTextStyle('smallBold',
                                    color: AppColors.darkBlue),
                              ),
                              ref.watch(educationLevelProvider).when(
                                    data: (data) {
                                      List<String> filteredList =
                                          data.sublist(2, 6);
                                      return FilterDropdown(
                                        selectedFilter: selectedEducationLevel,
                                        options: filteredList,
                                        onSelected: (String? newLevel) {
                                          if (newLevel != null) {
                                            onEducationLevelSelected(newLevel);
                                          }
                                        },
                                      );
                                    },
                                    loading: () =>
                                        const CircularProgressIndicator(),
                                    error: (err, stack) => Text('Error: $err'),
                                  ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : DetailsRow(
                      label: "Highest Degree",
                      value: selectedEducationLevel,
                    ),
              DetailsRow(
                label: "Teaching Experience",
                value: user.teachingExperience.toString(),
                controller: isEditing ? controller : null,
                editWidth: 165,
                keyboardType: TextInputType.number,
                divider: false,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class LearningGoalsSection extends StatelessWidget {
  final bool isEditing;
  final TextEditingController controller;
  final Student user;

  const LearningGoalsSection({
    super.key,
    required this.isEditing,
    required this.controller,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return DetailsSection(
      title: "Learning Goals",
      icon: Icons.emoji_events,
      children: [
        if (isEditing)
          EditScreenTextField(
            label: 'Learning Goal',
            controller: controller,
            width: MediaQuery.of(context).size.width,
          ),
        if (!isEditing)
          Text(
            user.learningGoals,
            style: getTextStyle('small', color: AppColors.darkBlue),
          ),
      ],
    );
  }
}

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
