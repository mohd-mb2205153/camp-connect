import 'package:campconnect/models/camp.dart';
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
    ref.read(loggedInUserNotifierProvider.notifier).setTeacher(teacher);
    state = AsyncData(List<Teacher>.from(state.value ?? [])
      ..removeWhere((t) => t.id == teacher.id)
      ..add(teacher));
  }

  Future<void> addCampToTeacher(Teacher teacher, Camp camp) async {
    try {
      // await _repo.addCampToTeacher(
      //   teacherId: teacher.id!,
      //   campId: camp.id!,
      //   teachingCamps: 'teachingCamps',
      // );
      teacher.teachingCamps.add(camp.id!);
      updateTeacher(teacher);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  bool isTeachingCamp(Teacher teacher, String campId) {
    return teacher.teachingCamps.contains(campId);
  }

  void removeTeachingCamps(
      {required String teacherId, required String campId}) async {
    Teacher? teacher = await getTeachersById(teacherId);
    teacher!.teachingCamps.remove(campId);
    updateTeacher(teacher);
  }
}

final teacherProviderNotifier =
    AsyncNotifierProvider<TeacherProvider, List<Teacher>>(
        () => TeacherProvider());

// final teachersByCampIdProvider =
//     FutureProvider.family<List<Teacher>, String>((ref, campId) async {
//   final repo = await ref.watch(repoProvider.future);
//   return repo.getTeachersByCampId(campId);
// });

// final teachingCampsProvider =
//     FutureProvider.family<List<Camp>, String>((ref, teacherId) async {
//   final repo = await ref.watch(repoProvider.future);
//   return repo.getTeachingCampsByTeacherId(teacherId);
// });
