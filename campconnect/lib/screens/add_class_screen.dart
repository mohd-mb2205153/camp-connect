import 'dart:convert';

import 'package:campconnect/providers/loggedinuser_provider.dart';
import 'package:campconnect/providers/repo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../models/class.dart';
import '../models/teacher.dart';
import '../providers/camp_provider.dart';
import '../providers/class_provider.dart';
import '../providers/show_nav_bar_provider.dart';
import '../theme/constants.dart';
import '../utils/helper_widgets.dart';

class AddClassScreen extends ConsumerStatefulWidget {
  final String campId;
  const AddClassScreen({super.key, required this.campId});

  @override
  ConsumerState<AddClassScreen> createState() => _AddClassScreenState();
}

class _AddClassScreenState extends ConsumerState<AddClassScreen> {
  final teacherController = TextEditingController();
  final subtitleController = TextEditingController();
  final descriptionController = TextEditingController();

  final FocusNode teacherFocus = FocusNode();
  final FocusNode subtitleFocus = FocusNode();
  final FocusNode descriptionFocus = FocusNode();

  List<String> subjectOptions = [];
  String selectedSubject = '';

  TimeOfDay fromTime = TimeOfDay.now();
  TimeOfDay toTime = TimeOfDay.fromDateTime(
    DateTime.now().add(const Duration(hours: 1)),
  );

  String classSchedule = "";

  @override
  void initState() {
    super.initState();
    final loggedUser = ref.read(loggedInUserNotifierProvider);
    ref.read(classProviderNotifier.notifier);
    ref.read(campProviderNotifier.notifier);

    if (loggedUser is Teacher) {
      teacherController.text = '${loggedUser.firstName} ${loggedUser.lastName}';
    }

    loadSubjects();
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

  @override
  void dispose() {
    teacherController.dispose();
    subtitleFocus.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          Navigator.of(context).pop(result);
        }
        return;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          extendBodyBehindAppBar: false,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            scrolledUnderElevation: 0,
            elevation: 0,
            title: Text("Add a Class",
                style: getTextStyle("mediumBold", color: AppColors.teal)),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                const Text(
                  "Teacher",
                  style: TextStyle(fontSize: 14, color: AppColors.lightTeal),
                ),
                addVerticalSpace(8),
                buildTextField(
                  readOnly: true,
                  controller: teacherController,
                  hintText: "Teacher Name",
                  prefixIcon: const Icon(Icons.person, color: Colors.grey),
                  focusNode: teacherFocus,
                ),
                const SizedBox(height: 16),
                buildSubjectPicker(context),
                const SizedBox(height: 16),
                const Text(
                  "Subtitle",
                  style: TextStyle(fontSize: 14, color: AppColors.lightTeal),
                ),
                addVerticalSpace(8),
                buildTextField(
                  controller: subtitleController,
                  hintText: "Enter Subtitle",
                  prefixIcon: const Icon(Icons.title, color: Colors.grey),
                  focusNode: subtitleFocus,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Description",
                  style: TextStyle(fontSize: 14, color: AppColors.lightTeal),
                ),
                addVerticalSpace(8),
                buildTextArea(
                  controller: descriptionController,
                  hintText: "Enter Description",
                  prefixIcon: const Icon(Icons.description, color: Colors.grey),
                  focusNode: descriptionFocus,
                ),
                const SizedBox(height: 16),
                buildClassSchedulePicker(),
                const SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (teacherController.text.isNotEmpty &&
                            selectedSubject.isNotEmpty &&
                            subtitleController.text.isNotEmpty &&
                            descriptionController.text.isNotEmpty &&
                            (toTime.hour > fromTime.hour ||
                                (toTime.hour == fromTime.hour &&
                                    toTime.minute > fromTime.minute))) {
                          try {
                            final loggedUser =
                                ref.read(loggedInUserNotifierProvider);
                            if (loggedUser is Teacher) {
                              final newClass = Class(
                                id: '',
                                teacher: loggedUser,
                                description: descriptionController.text,
                                subject: selectedSubject,
                                subtitle: subtitleController.text,
                                timeFrom:
                                    '${fromTime.hour.toString().padLeft(2, '0')}:00',
                                timeTo:
                                    '${toTime.hour.toString().padLeft(2, '0')}:00',
                              );

                              final classProvider =
                                  ref.read(classProviderNotifier.notifier);
                              final classId =
                                  await classProvider.addClass(newClass);

                              final campProvider =
                                  ref.read(campProviderNotifier.notifier);
                              final camp =
                                  await campProvider.getCampById(widget.campId);

                              if (camp != null) {
                                camp.addClass(classId);
                                campProvider.updateCamp(camp);
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Class Added Successfully!")),
                              );

                              context.pop();
                            }
                          } catch (error) {
                            debugPrint("Error adding class: $error");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Error adding class: $error")),
                            );
                          }
                        } else {
                          String errorMessage = "Please fill all fields";

                          if (toTime.hour < fromTime.hour ||
                              (toTime.hour == fromTime.hour &&
                                  toTime.minute <= fromTime.minute)) {
                            errorMessage = "End time must be after start time.";
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(errorMessage)),
                          );

                          showCustomSnackBar(errorMessage, icon: Icons.error);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lightTeal,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        "Add Camp",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
            const SizedBox(width: 16),
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
}
