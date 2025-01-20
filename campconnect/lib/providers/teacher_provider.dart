import 'package:campconnect/models/camp.dart';
import 'package:campconnect/models/teacher.dart';
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

  Future<List<Camp>> getCreatedCamps(String teacherId) async {
    try {
      return await _repo.getCreatedCampsByTeacherId(teacherId);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }
}

final teacherProviderNotifier =
    AsyncNotifierProvider<TeacherProvider, List<Teacher>>(
        () => TeacherProvider());

final teachersByCampIdProvider =
    FutureProvider.family<List<Teacher>, String>((ref, campId) async {
  final repo = await ref.watch(repoProvider.future);
  return repo.getTeachersByCampId(campId);
});

final createdCampsProvider =
    FutureProvider.family<List<Camp>, String>((ref, teacherId) async {
  final repo = await ref.watch(repoProvider.future);
  return repo.getCreatedCampsByTeacherId(teacherId);
});

final teachingCampsProvider =
    FutureProvider.family<List<Camp>, String>((ref, teacherId) async {
  final repo = await ref.watch(repoProvider.future);
  return repo.getTeachingCampsByTeacherId(teacherId);
});
