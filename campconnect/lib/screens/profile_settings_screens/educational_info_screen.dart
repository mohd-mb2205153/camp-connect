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
  User?
      user; //Testing for now, later we will get user that is logged in thru provider.

  final TextEditingController learningGoalsController = TextEditingController();
  final TextEditingController teachingExpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //Dummy value
    user = User(
      firstName: 'Ahmad',
      lastName: 'John',
      dateOfBirth: DateTime(2004, 11, 9),
      nationality: 'Iraq',
      primaryLanguages: ['Arabic', 'English'],
      countryCode: 'QA',
      mobileNumber: '3033067',
      email: 'enter@gmail.com',
      role: 'Student',
    );
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
                  isEditing = !isEditing;
                  if (isEditing) {
                    // initializeControllers(customer);
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
                    user!.role,
                    style: getTextStyle('largeBold', color: AppColors.darkBlue),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (user?.role == 'Student') buildStudentInfo(),
                  if (user?.role == 'Teacher') buildTeacherInfo(),
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
                  selectedEducationLevel ?? 'Primary School', //Dummy
              onEducationLevelSelected: (newLevel) {
                setState(() {
                  selectedEducationLevel = newLevel;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (user?.role == 'Student')
          FrostedGlassBox(
            boxWidth: double.infinity,
            isCurved: true,
            boxChild: Padding(
              padding: const EdgeInsets.all(16.0),
              child: LearningGoalsSection(
                isEditing: isEditing,
                controller: learningGoalsController,
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
              selectedEducationLevel ?? 'Bachelor Degree', //Dummy
          onEducationLevelSelected: (newLevel) {
            setState(() {
              selectedEducationLevel = newLevel;
            });
          },
        ),
      ),
    );
  }

  Widget buildIcon(User user) {
    return user.role == 'Student'
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
  // final User user;

  const StudentEducationSection({
    super.key,
    required this.isEditing,
    required this.selectedEducationLevel,
    required this.onEducationLevelSelected,
    // required this.user,
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
                      ),
                    )
                  : DetailsRow(
                      label: "Education Level",
                      value: selectedEducationLevel,
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
  // final User user;

  const TeacherEducationSection({
    super.key,
    required this.isEditing,
    required this.selectedEducationLevel,
    required this.onEducationLevelSelected,
    required this.controller,
    // required this.user,
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
                value: '2 year(s)', //Dummy
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
  // final User user;

  const LearningGoalsSection({
    super.key,
    required this.isEditing,
    required this.controller,
    // required this.user,
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
          //Dummy
          Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'),
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
