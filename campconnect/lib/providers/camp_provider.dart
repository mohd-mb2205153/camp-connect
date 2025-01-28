import 'package:campconnect/models/class.dart';
import 'package:campconnect/providers/class_provider.dart';
import 'package:campconnect/providers/repo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/camp.dart';
import '../repositories/camp_connect_repo.dart';

class CampProvider extends AsyncNotifier<List<Camp>> {
  late final CampConnectRepo _repo;

  @override
  Future<List<Camp>> build() async {
    _repo = await ref.watch(repoProvider.future);
    initializeCamps();
    return [];
  }

  Future<void> initializeCamps() async {
    _repo.observeCamps().listen((camp) {
      state = AsyncData(camp);
    }).onError((error) => print(error));
  }

  void showAll() => initializeCamps();

  Future<Camp?> getCampById(String id) => _repo.getCampById(id);

  Future<String> addCamp(Camp camp, String teacherId) async {
    try {
      state = AsyncValue.loading();

      camp.teacherId = (camp.teacherId ?? [])..add(teacherId);

      final campId = await _repo.addCamp(camp);

      final currentState = state.asData?.value ?? [];
      state = AsyncValue.data([...currentState, camp]);

      return campId;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  void deleteCamp(Camp camp) {
    _repo.deleteCamp(camp);
  }

  void updateCamp(Camp camp) {
    _repo.updateCamp(camp);
  }

  Future<List<Camp>> getTeachingCampsByTeacherId(String teacherId) {
    return _repo.getTeachingCampsByTeacherId(teacherId);
  }

  Future<List<Camp>> getSavedCampsByStudentId(String studentId) {
    return _repo.getSavedCampsByStudentId(studentId);
  }

  Future<void> removeCampsClass(
      {required String targetTeacherId, required String campId}) async {
    List<Class> classesByCampId = await _repo.getClassByCampId(campId);
    List<Class> classesByTeacherId =
        classesByCampId.where((c) => c.teacher.id == targetTeacherId).toList();
    List<String> classesId = classesByTeacherId.map((c) => c.id).toList();

    Camp? camp = await getCampById(campId);
    camp!.classId =
        camp.classId!.where((cid) => !classesId.contains(cid)).toList();
    camp.teacherId!.remove(targetTeacherId);

    updateCamp(camp);

    ref.read(classProviderNotifier.notifier).deleteClasses(classesByTeacherId);
  }

  filterByEducationLevel(List<String> level) {
    _repo.filterCampByEducationLevel(level).listen((camp) {
      state = AsyncData(camp);
    }).onError((error) => print(error));
  }

  filterByAdditionalSupport(List<String> supports) {
    _repo.filterCampByAdditionalSupport(supports).listen((camp) {
      state = AsyncData(camp);
    }).onError((error) => print(error));
  }

  filterByLanguages(List<String> languages) {
    _repo.filterCampByLanguage(languages).listen((camp) {
      state = AsyncData(camp);
    }).onError((error) => print(error));
  }

  filterByRange(double userLat, double userLng, double rangeInKm) {
    _repo.filterCampsByRange(userLat, userLng, rangeInKm).listen((camp) {
      state = AsyncData(camp);
    }).onError((error) => print(error));
  }

  filterByName(String queryName) {
    _repo.filterCampByName(queryName).listen((camp) {
      state = AsyncData(camp);
    }).onError((error) => print(error));
  }
}

final campProviderNotifier =
    AsyncNotifierProvider<CampProvider, List<Camp>>(() => CampProvider());
