import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/class.dart';
import '../models/teacher.dart';
import '../models/student.dart';
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

  void addClass(Class classData) {
    _repo.addClass(classData);
  }

  void deleteClass(Class classData) {
    _repo.deleteClass(classData);
  }

  void updateClass(Class classData) {
    _repo.updateClass(classData);
  }
}

final classProviderNotifier =
    AsyncNotifierProvider<ClassProvider, List<Class>>(() => ClassProvider());
