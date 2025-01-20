import 'package:campconnect/models/teacher.dart';
import 'package:campconnect/providers/repo_provider.dart';
import 'package:campconnect/repositories/camp_connect_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeacherProvider extends AsyncNotifier<List<Teacher>> {
  late final CampConnectRepo _repo;

  @override
  Future<List<Teacher>> build() async {
    _repo = await ref.watch(repoProvider.future);
    initializeTeachers();
    return [];
  }

  Future<void> initializeTeachers() async {
    _repo.observeTeachers().listen((teachers) {
      state = AsyncData(teachers);
    }).onError((error) => print(error));
  }

  Future<Teacher?> getTeacherById(String id) => _repo.getTeacherById(id);

  void addTeacher(Teacher teacher) {
    _repo.addTeacher(teacher);
  }

  void deleteTeacher(Teacher teacher) {
    _repo.deleteTeacher(teacher);
  }

  void updateTeacher(Teacher teacher) {
    _repo.updateTeacher(teacher);
  }

  Future<void> addCreatedCamp(String teacherId, String campId) async {
    try {
      await _repo.addCampToTeacher(
        teacherId: teacherId,
        campId: campId,
        field: 'createdCamps',
      );
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> addTeachingCamp(String teacherId, String campId) async {
    try {
      await _repo.addCampToTeacher(
        teacherId: teacherId,
        campId: campId,
        field: 'teachingCamps',
      );
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final teacherProviderNotifier =
    AsyncNotifierProvider<TeacherProvider, List<Teacher>>(
        () => TeacherProvider());
