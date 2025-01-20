import 'package:campconnect/models/student.dart';
import 'package:campconnect/providers/repo_provider.dart';
import 'package:campconnect/repositories/camp_connect_repo.dart';
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
    state = AsyncData(List<Student>.from(state.value ?? [])
      ..removeWhere((s) => s.id == student.id)
      ..add(student));
  }
}

final studentProviderNotifier =
    AsyncNotifierProvider<StudentProvider, List<Student>>(
        () => StudentProvider());
