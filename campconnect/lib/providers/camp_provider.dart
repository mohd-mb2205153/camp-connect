import 'package:campconnect/models/class.dart';
import 'package:campconnect/providers/class_provider.dart';
import 'package:campconnect/providers/repo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

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

  Future<void> removeClassFromCamp(
      {required String campId, required String classId}) async {
    Camp? camp = await getCampById(campId);
    camp!.classId!.remove(classId);
    updateCamp(camp);
  }

  void addTeacherToCamp(
      {required String teacherId, required String campId}) async {
    Camp? camp = await getCampById(campId);
    camp!.teacherId!.add(teacherId);
    updateCamp(camp);
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
    try {
      if (state.value == null || state.value!.isEmpty) {
        throw Exception("Camps not initialized. Call initializeCamps first.");
      }
      final allCamps = state.value!;

      final filteredCamps = allCamps.where((camp) {
        double distanceInMeters = Geolocator.distanceBetween(
          userLat,
          userLng,
          camp.latitude,
          camp.longitude,
        );

        double distanceInKm = distanceInMeters / 1000; // Convert to km
        return distanceInKm <= rangeInKm;
      }).toList();

      // Update state with filtered camps
      state = AsyncValue.data(filteredCamps);
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<List<Camp>> filterByName(String queryName) {
    return _repo.filterCampByName(queryName);
  }
}

final campProviderNotifier =
    AsyncNotifierProvider<CampProvider, List<Camp>>(() => CampProvider());

/*To save latitude and longitude of a selected camp after leaving search camp screen.
First index latidude, Second index longitude.
*/
final selectedCampLocationProvider =
    StateProvider<List<double>?>((ref) => null);

