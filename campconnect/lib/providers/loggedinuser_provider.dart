import 'package:campconnect/providers/show_nav_bar_provider.dart';
import 'package:campconnect/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/student.dart';
import '../models/teacher.dart';
import '../models/user.dart';

class LoggedInUserNotifier extends Notifier<User?> {
  @override
  User? build() {
    return null;
  }

  void setStudent(Student student) {
    state = student;
  }

  void setTeacher(Teacher teacher) {
    state = teacher;
  }

  void clearUser() {
    state = null;
  }

  bool get isStudent => state is Student;

  bool get isTeacher => state is Teacher;

  Student? get student => state is Student ? state as Student : null;

  Teacher? get teacher => state is Teacher ? state as Teacher : null;

  bool get isLoggedIn => state != null;

  String? get userId => state?.id;

  void handleDiscardUpdate(
      {required bool isEditing, required BuildContext context}) async {
    bool exit = false;
    if (isEditing) {
      await showDialog(
        context: context,
        builder: (context) {
          return ConfirmationDialog(
            showSnackBar: false,
            type: 'Discard',
            title: 'Discard Update?',
            content:
                'Any current changes that has been made to the profile will not be saved!',
            onConfirm: () {
              exit = true;
              ref
                  .read(showNavBarNotifierProvider.notifier)
                  .showBottomNavBar(true);
            },
          );
        },
      );
    } else {
      exit = true;
      ref.read(showNavBarNotifierProvider.notifier).showBottomNavBar(true);
    }
    exit ? context.pop() : null;
  }

  // void updateStudent(Student student) {
  //   if (student.id == null) {
  //     throw Exception("Student ID is required to update.");
  //   }
  //   ref.read(studentProviderNotifier.notifier).updateStudent(student);
  //   state = student;
  // }

  // void updateTeacher(Teacher teacher) {
  //   if (teacher.id == null) {
  //     throw Exception("Teacher ID is required to update.");
  //   }
  //   ref.read(teacherProviderNotifier.notifier).updateTeacher(teacher);
  //   state = teacher;
  // }

  String? getLoggedInUserId() {
    return userId;
  }
}

final loggedInUserNotifierProvider =
    NotifierProvider<LoggedInUserNotifier, User?>(() => LoggedInUserNotifier());
