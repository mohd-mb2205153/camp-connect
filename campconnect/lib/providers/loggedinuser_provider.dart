import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';
import '../models/teacher.dart';
import '../models/user.dart';
import '../repositories/camp_connect_repo.dart';
import 'repo_provider.dart';

class LoggedInUserNotifier extends StateNotifier<User?> {
  final CampConnectRepo _repo;

  LoggedInUserNotifier(this._repo) : super(null);

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

  Future<void> updateStudent(Student student) async {
    if (student.id == null) {
      throw Exception("Student ID is required to update.");
    }
    await _repo.updateStudent(student);
    state = student; // Update the local state
  }
}

final loggedInUserNotifierProvider =
    StateNotifierProvider<LoggedInUserNotifier, User?>((ref) {
  final asyncRepo = ref.watch(repoProvider);

  return asyncRepo.when(
    data: (repo) => LoggedInUserNotifier(repo),
    loading: () {
      // Provide a default state or null while loading
      throw Exception('Repo is still loading. Ensure this is handled.');
    },
    error: (error, stackTrace) {
      // Handle errors gracefully
      throw Exception('Error resolving CampConnectRepo: $error');
    },
  );
});
