import 'package:campconnect/models/student.dart';
import 'package:campconnect/providers/loggedinuser_provider.dart';
import 'package:campconnect/providers/repo_provider.dart';
import 'package:campconnect/providers/show_nav_bar_provider.dart';
import 'package:campconnect/repositories/camp_connect_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentProvider extends AsyncNotifier<List<Student>> {
  late final CampConnectRepo _repo;

  @override
  Future<List<Student>> build() async {
    _repo = await ref.watch(repoProvider.future);
    initializeStudents();
    return [];
  }

  Future<void> initializeStudents() async {
    _repo.observeStudents().listen((students) {
      state = AsyncData(students);
    }).onError((error) => print(error));
  }

  Future<Student?> getStudentById(String id) => _repo.getStudentById(id);

  void addStudent(Student student) {
    _repo.addStudent(student);
  }

  void deleteStudent(Student student) {
    _repo.deleteStudent(student);
  }

  void updateStudent(Student student) async {
    await _repo.updateStudent(student);
    if (student.id == ref.read(loggedInUserNotifierProvider)!.id) {
      ref.read(loggedInUserNotifierProvider.notifier).setStudent(student);
    }
    state = AsyncData(List<Student>.from(state.value ?? [])
      ..removeWhere((s) => s.id == student.id)
      ..add(student));
  }

  bool isSavedCamp(Student student, String campId) {
    return student.savedCamps.contains(campId);
  }

  Future<void> removedSavedCamps(
      {required String studentId, required String campId}) async {
    Student? student = await _repo.getStudentById(studentId);
    student!.savedCamps.remove(campId);
    updateStudent(student);
  }

  Future<Student?> getStudentByEmail(String email) async {
    return await _repo.getStudentByEmail(email);
  }
}

final studentProviderNotifier =
    AsyncNotifierProvider<StudentProvider, List<Student>>(
        () => StudentProvider());
