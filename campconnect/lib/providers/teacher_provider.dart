import 'package:campconnect/models/teacher.dart';
import 'package:campconnect/providers/loggedinuser_provider.dart';
import 'package:campconnect/providers/repo_provider.dart';
import 'package:campconnect/repositories/camp_connect_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeacherProvider extends AsyncNotifier<List<Teacher>> {
  late final CampConnectRepo _repo;

  @override
  Future<List<Teacher>> build() async {
    _repo = await ref.watch(repoProvider.future);
    final initialData = await _repo.observeTeachers().first;
    observeTeachers();

    return initialData;
  }

  void observeTeachers() {
    _repo.observeTeachers().listen((teachers) {
      state = AsyncData(teachers);
    }).onError((error) => state = AsyncError(error, StackTrace.current));
  }

  Future<Teacher?> getTeachersById(String teacherId) =>
      _repo.getTeacherById(teacherId);

  Future<List<Teacher>> getTeachersByCampId(String campId) async {
    try {
      return await _repo.getTeachersByCampId(campId);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  void addTeacher(Teacher teacher) {
    _repo.addTeacher(teacher);
  }

  void deleteTeacher(Teacher teacher) {
    _repo.deleteTeacher(teacher);
  }

  void updateTeacher(Teacher teacher) async {
    await _repo.updateTeacher(teacher);
    if (teacher.id == ref.read(loggedInUserNotifierProvider)!.id) {
      ref.read(loggedInUserNotifierProvider.notifier).setTeacher(teacher);
    }
    state = AsyncData(List<Teacher>.from(state.value ?? [])
      ..removeWhere((t) => t.id == teacher.id)
      ..add(teacher));
  }

  Future<void> addCampToTeacher(
      {required String teacherId, required String campId}) async {
    try {
      Teacher? teacher = await getTeachersById(teacherId);
      teacher!.teachingCamps.add(campId);
      updateTeacher(teacher);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  bool isTeachingCamp(Teacher teacher, String campId) {
    return teacher.teachingCamps.contains(campId);
  }

  void removeTeachingCampFromTeacher(
      {required String teacherId, required String campId}) async {
    Teacher? teacher = await getTeachersById(teacherId);
    teacher!.teachingCamps.remove(campId);
    updateTeacher(teacher);
  }
}

final teacherProviderNotifier =
    AsyncNotifierProvider<TeacherProvider, List<Teacher>>(
        () => TeacherProvider());
