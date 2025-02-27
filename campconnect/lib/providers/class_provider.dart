import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/class.dart';
import '../repositories/camp_connect_repo.dart';
import '../providers/repo_provider.dart';

class ClassProvider extends AsyncNotifier<List<Class>> {
  late final CampConnectRepo _repo;

  @override
  Future<List<Class>> build() async {
    _repo = await ref.watch(repoProvider.future);
    initializeClasses();
    return [];
  }

  Future<void> initializeClasses() async {
    _repo.observeClasses().listen((classes) {
      state = AsyncData(classes);
    }).onError((error) => print(error));
  }

  Future<Class?> getClassById(String id) => _repo.getClassById(id);

  Future<String> addClass(Class newClass) async {
    try {
      final classId = await _repo.addClass(newClass);
      final currentClasses = state.value ?? [];
      state = AsyncValue.data([...currentClasses, newClass]);

      return classId;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  void deleteClass(Class classData) => _repo.deleteClass(classData);

  void updateClass(Class classData) => _repo.updateClass(classData);

  Future<List<Class>> getClassByCampId(String campId) =>
      _repo.getClassByCampId(campId);

  void deleteClasses(List<Class> classes) {
    for (var c in classes) {
      deleteClass(c);
    }
  }
}

final classProviderNotifier =
    AsyncNotifierProvider<ClassProvider, List<Class>>(() => ClassProvider());
