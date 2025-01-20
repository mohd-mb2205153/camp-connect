import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';
import '../models/teacher.dart';
import '../models/user.dart';

class LoggedInUserNotifier extends StateNotifier<User?> {
  LoggedInUserNotifier() : super(null);

  void setStudent(Student student) {
    state = student;
  }

  void setTeacher(Teacher teacher) {
    state = teacher;
  }

  /// Clear the state and logout the user
  void clearUser() {
    state = null;
  }

  bool get isStudent => state is Student;

  bool get isTeacher => state is Teacher;

  Student? get student => state is Student ? state as Student : null;

  Teacher? get teacher => state is Teacher ? state as Teacher : null;

  bool get isLoggedIn => state != null;

  String? get userRole {
    if (state is Student) return 'student';
    if (state is Teacher) return 'teacher';
    return null;
  }
}

final loggedInUserNotifierProvider =
    StateNotifierProvider<LoggedInUserNotifier, User?>((ref) {
  return LoggedInUserNotifier();
});
