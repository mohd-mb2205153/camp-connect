import 'dart:convert';

import 'package:campconnect/models/class.dart';
import 'package:campconnect/models/teacher.dart';
import 'package:campconnect/providers/class_provider.dart';
import 'package:campconnect/providers/loggedinuser_provider.dart';
import 'package:campconnect/providers/show_nav_bar_provider.dart';
import 'package:campconnect/routes/app_router.dart';
import 'package:campconnect/theme/constants.dart';
import 'package:campconnect/utils/helper_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UpdateClassScreen extends ConsumerStatefulWidget {
  final String classId;
  const UpdateClassScreen({super.key, required this.classId});

  @override
  ConsumerState<UpdateClassScreen> createState() => _UpdateClassScreenState();
}

class _UpdateClassScreenState extends ConsumerState<UpdateClassScreen> {
  final teacherController = TextEditingController();
  final subtitleController = TextEditingController();
  final descriptionController = TextEditingController();

  final FocusNode teacherFocus = FocusNode();
  final FocusNode subtitleFocus = FocusNode();
  final FocusNode descriptionFocus = FocusNode();

  List<String> subjectOptions = [];
  String selectedSubject = '';
  String classSchedule = "";

  TimeOfDay fromTime = TimeOfDay.now();
  TimeOfDay toTime = TimeOfDay.fromDateTime(
    DateTime.now().add(const Duration(hours: 1)),
  );

  bool isLoading = true;
  Class? existingClass;

  @override
  void initState() {
    super.initState();
    loadSubjects();
    fetchExistingClass();
  }

  Future<void> fetchExistingClass() async {
    try {
      Class? fetchedClass = await ref
          .read(classProviderNotifier.notifier)
          .getClassById(widget.classId);

      if (fetchedClass != null) {
        setState(() {
          existingClass = fetchedClass;

          teacherController.text =
              "${fetchedClass.teacher.firstName} ${fetchedClass.teacher.lastName}";
          selectedSubject = fetchedClass.subject;
          subtitleController.text = fetchedClass.subtitle;
          descriptionController.text = fetchedClass.description;

          fromTime = TimeOfDay(
            hour: int.parse(fetchedClass.timeFrom.split(":")[0]),
            minute: 0,
          );
          toTime = TimeOfDay(
            hour: int.parse(fetchedClass.timeTo.split(":")[0]),
            minute: 0,
          );
        });
      }
    } catch (e) {
      debugPrint("Error fetching class details: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadSubjects() async {
    try {
      final data = await DefaultAssetBundle.of(context)
          .loadString("assets/data/subjects.json");
      subjectOptions = List<String>.from(json.decode(data) as List);
      setState(() {});
    } catch (error) {
      debugPrint("Error loading subjects data: $error");
    }
  }

  void updateClass() {
    if (teacherController.text.isNotEmpty &&
        selectedSubject.isNotEmpty &&
        subtitleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        (toTime.hour > fromTime.hour ||
            (toTime.hour == fromTime.hour &&
                toTime.minute > fromTime.minute))) {
      try {
        final updatedClass = Class(
          id: widget.classId,
          teacher: existingClass!.teacher,
          description: descriptionController.text,
          subject: selectedSubject,
          subtitle: subtitleController.text,
          timeFrom: '${fromTime.hour.toString().padLeft(2, '0')}:00',
          timeTo: '${toTime.hour.toString().padLeft(2, '0')}:00',
        );

        ref.read(classProviderNotifier.notifier).updateClass(updatedClass);
        showCustomSnackBar(
            message: "Class updated successfully",
            icon: Icons.check,
            context: context);

        ref.read(showNavBarNotifierProvider.notifier).showBottomNavBar(true);
        ref.read(showNavBarNotifierProvider.notifier).setActiveBottomNavBar(1);

        context.goNamed(AppRouter.map.name);
      } catch (e) {
        showCustomSnackBar(
            message: "Failed to update class: $e",
            icon: Icons.error,
            context: context);
      }
    } else {
      String errorMessage = "Please fill all fields";
      if (toTime.hour < fromTime.hour ||
          (toTime.hour == fromTime.hour && toTime.minute <= fromTime.minute)) {
        errorMessage = "End time must be after start time.";
      }
      showCustomSnackBar(
          message: errorMessage, icon: Icons.error, context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.teal),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text("Update Class",
            style: getTextStyle("mediumBold", color: AppColors.teal)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text("Teacher",
                style: getTextStyle("small", color: AppColors.lightTeal)),
            addVerticalSpace(8),
            buildTextField(
              readOnly: true,
              controller: teacherController,
              hintText: "Teacher Name",
              prefixIcon: const Icon(Icons.person, color: Colors.grey),
              focusNode: teacherFocus,
            ),
            addVerticalSpace(16),
            buildSubjectPicker(context),
            addVerticalSpace(16),
            Text("Subtitle",
                style: getTextStyle("small", color: AppColors.lightTeal)),
            addVerticalSpace(8),
            buildTextField(
              controller: subtitleController,
              hintText: "Enter Subtitle",
              prefixIcon: const Icon(Icons.title, color: Colors.grey),
              focusNode: subtitleFocus,
            ),
            addVerticalSpace(16),
            Text("Description",
                style: getTextStyle("small", color: AppColors.lightTeal)),
            addVerticalSpace(8),
            buildTextArea(
              controller: descriptionController,
              hintText: "Enter Description",
              prefixIcon: const Icon(Icons.description, color: Colors.grey),
              focusNode: descriptionFocus,
            ),
            addVerticalSpace(16),
            buildClassSchedulePicker(),
            addVerticalSpace(24),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: updateClass,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightTeal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: Text("Update Class",
                      style: getTextStyle("smallBold", color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSubjectPicker(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Class Subject",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 14, color: AppColors.lightTeal),
            ),
          ],
        ),
        addVerticalSpace(8),
        GestureDetector(
          onTap: () => showCupertinoModalPopup(
            context: context,
            builder: (_) {
              int tempIndex = subjectOptions.indexOf(selectedSubject);
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
                          onPressed: () {
                            context.pop();
                          },
                        ),
                        CupertinoButton(
                          child: const Text("Confirm"),
                          onPressed: () {
                            setState(() {
                              selectedSubject = subjectOptions[tempIndex];
                            });
                            context.pop();
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 250,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: tempIndex >= 0 ? tempIndex : 0,
                        ),
                        itemExtent: 32,
                        onSelectedItemChanged: (index) {
                          tempIndex = index;
                        },
                        children: subjectOptions
                            .map((level) => Text(
                                  level,
                                  style: const TextStyle(fontSize: 16),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          child: buildDecoratedInput(
              selectedSubject.isEmpty ? "Select a subject" : selectedSubject,
              Icons.school),
        ),
      ],
    );
  }

  Widget buildClassSchedulePicker() {
    void showHourPicker(BuildContext context, bool isFrom) {
      showCupertinoModalPopup(
        context: context,
        builder: (_) {
          int tempHour = isFrom ? fromTime.hour : toTime.hour;
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
                      onPressed: () => context.pop(),
                    ),
                    CupertinoButton(
                      child: const Text("Confirm"),
                      onPressed: () {
                        setState(() {
                          if (isFrom) {
                            fromTime = TimeOfDay(hour: tempHour, minute: 0);

                            if (toTime.hour <= fromTime.hour) {
                              toTime = TimeOfDay(
                                hour: (fromTime.hour + 1) % 24,
                                minute: 0,
                              );
                            }
                          } else {
                            toTime = TimeOfDay(hour: tempHour, minute: 0);

                            if (toTime.hour <= fromTime.hour) {
                              toTime = TimeOfDay(
                                hour: (fromTime.hour + 1) % 24,
                                minute: 0,
                              );
                            }
                          }

                          classSchedule =
                              "${fromTime.hour.toString().padLeft(2, '0')}:00 - ${toTime.hour.toString().padLeft(2, '0')}:00";
                        });

                        context.pop();
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 250,
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: tempHour,
                    ),
                    itemExtent: 32,
                    onSelectedItemChanged: (selectedHour) {
                      tempHour = selectedHour;
                    },
                    children: List.generate(
                      24,
                      (hour) => Text("$hour:00"),
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
        const Text(
          "Class Schedule",
          style: TextStyle(fontSize: 14, color: AppColors.lightTeal),
        ),
        addVerticalSpace(8),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => showHourPicker(context, true),
                child: buildDecoratedInput(
                  "${fromTime.hour.toString().padLeft(2, '0')}:00",
                  Icons.access_time,
                ),
              ),
            ),
            addHorizontalSpace(16),
            Expanded(
              child: GestureDetector(
                onTap: () => showHourPicker(context, false),
                child: buildDecoratedInput(
                  "${toTime.hour.toString().padLeft(2, '0')}:00",
                  Icons.access_time,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
