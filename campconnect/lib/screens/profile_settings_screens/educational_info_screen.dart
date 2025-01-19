import 'package:campconnect/models/student.dart';
import 'package:campconnect/models/teacher.dart';
import 'package:campconnect/models/user.dart';
import 'package:campconnect/providers/json_provider.dart';
import 'package:campconnect/providers/show_nav_bar_provider.dart';
import 'package:campconnect/theme/frosted_glass.dart';
import 'package:campconnect/theme/styling_constants.dart';
import 'package:campconnect/utils/helper_widgets.dart';
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
  List<String> selectedSubjects = [];
  dynamic
      user; //Testing for now, later we will get user that is logged in thru provider.

  final TextEditingController learningGoalsController = TextEditingController();
  final TextEditingController teachingExpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //Dummy value
    // user = Student(
    //   guardianPhoneCode: '+974',
    //   phoneCode: '+974',
    //   firstName: 'Ahmad',
    //   lastName: 'John',
    //   dateOfBirth: DateTime(2004, 11, 9),
    //   nationality: 'Iraq',
    //   primaryLanguages: ['Arabic', 'English'],
    //   countryCode: 'QA',
    //   mobileNumber: '3033067',
    //   email: 'enter@gmail.com',
    //   currentEducationLevel: 'High School',
    //   enrolledCamps: [],
    //   guardianContact: '44450699',
    //   guardianCountryCode: 'IN',
    //   preferredDistanceForCamps: '',
    //   preferredSubjects: ['Arabic', 'Art'],
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
      areasOfExpertise: [],
      availabilitySchedule: '',
      certifications: [],
      highestEducationLevel: 'High School or secondary school degree complete',
      preferredCampDuration: '',
      teachingExperience: 16,
      willingnessToTravel: '',
      createdCamps: [],
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
      selectedEducationLevel = user.highestEducationLevel;
    } else if (user is Student) {
      learningGoalsController.text = user.learningGoals;
      selectedSubjects = List<String>.from(user.preferredSubjects);
      selectedEducationLevel = user.currentEducationLevel;
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
                  .read(showNavBarNotifierProvider.notifier)
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
            child: ref.watch(subjectsProvider).when(
                  data: (subjects) {
                    return StudentEducationSection(
                      isEditing: isEditing,
                      selectedEducationLevel:
                          selectedEducationLevel ?? user.currentEducationLevel,
                      onEducationLevelSelected: (newLevel) {
                        setState(() {
                          selectedEducationLevel = newLevel;
                        });
                      },
                      user: user ?? user.preferredSubjects,
                      subjectsBuilder: (_) {
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
                                  if (!selectedSubjects
                                      .contains(subjects[index])) {
                                    selectedSubjects.add(subjects[index]);
                                  }
                                });
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      },
                      subjectsChildren: selectedSubjects
                          .map(
                            (subject) => Chip(
                              backgroundColor: AppColors.lightTeal,
                              label: Text(
                                subject,
                                style:
                                    getTextStyle('small', color: Colors.white),
                              ),
                              deleteIcon:
                                  const Icon(Icons.close, color: Colors.white),
                              onDeleted: () {
                                setState(() {
                                  selectedSubjects.remove(subject);
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
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (err, stack) => Text('Error: $err'),
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
        ? Center(
            child: SizedBox(
              height: 55,
              width: 55,
              child: Image.asset('assets/images/student_icon.png'),
            ),
          )
        : Center(
            child: SizedBox(
              height: 60,
              width: 60,
              child: Image.asset('assets/images/educator_icon.png'),
            ),
          );
  }
}

class StudentEducationSection extends ConsumerWidget {
  final bool isEditing;
  final String selectedEducationLevel;
  final Function(String) onEducationLevelSelected;
  final Student user;
  final Widget Function(BuildContext) subjectsBuilder;
  final List<Widget> subjectsChildren;

  const StudentEducationSection({
    super.key,
    required this.isEditing,
    required this.selectedEducationLevel,
    required this.onEducationLevelSelected,
    required this.user,
    required this.subjectsBuilder,
    required this.subjectsChildren,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SectionTitleWithIcon(
      icon: Icons.menu_book_rounded,
      title: 'Basic Information',
      centerTitle: true,
      child: Column(
        children: [
          isEditing
              ? Container(
                  decoration: BoxDecoration(
                    border: const Border(
                      bottom: BorderSide(color: AppColors.darkBlue, width: 1),
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
                          ref.watch(studentEducationLevelProvider).when(
                                data: (data) {
                                  return FilterDropdown(
                                    selectedFilter: selectedEducationLevel,
                                    options: data,
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
                  value: user.currentEducationLevel,
                ),
          SizedBox(
            height: 12,
          ),
          isEditing
              ? buildEditPreferredSubjects(context)
              : buildPreferedSubjects()
        ],
      ),
    );
  }

  Widget buildPreferedSubjects() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Preferred Subjects:',
              style: getTextStyle('smallBold', color: AppColors.darkBlue),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: [
              for (var subjects in user.preferredSubjects)
                buildSubjectsContainer(subjects)
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSubjectsContainer(String subjects) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightTeal,
            borderRadius: BorderRadius.circular(15),
          ),
          height: 35,
          child: Center(
            child: Text(
              '   $subjects   ',
              style: getTextStyle('small', color: AppColors.white),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        )
      ],
    );
  }

  Widget buildEditPreferredSubjects(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Preferred Subjects",
                textAlign: TextAlign.start,
                style: getTextStyle(
                  "smallBold",
                  color: AppColors.darkBlue,
                ),
              ),
            ],
          ),
          addVerticalSpace(8),
          Row(
            children: [
              Icon(Icons.book, color: Colors.grey),
              addHorizontalSpace(10),
              Text(
                "Preferred Subjects",
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
                    builder: subjectsBuilder,
                  );
                },
              ),
            ],
          ),
          const Divider(color: AppColors.lightTeal, thickness: 2),
          addVerticalSpace(8),
          Wrap(
            spacing: 8,
            children: subjectsChildren,
          ),
        ],
      ),
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
                              ref.watch(teachedEducationLevelProvider).when(
                                    data: (data) {
                                      return FilterDropdown(
                                        height: 48,
                                        selectedFilter: selectedEducationLevel,
                                        options: data,
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
                      value: user.highestEducationLevel,
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
