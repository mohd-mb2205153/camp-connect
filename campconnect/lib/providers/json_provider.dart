import 'package:campconnect/repositories/camp_connect_json_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final languagesProvider = FutureProvider<List<String>>((ref) async {
  CampConnectJsonRepo repo = CampConnectJsonRepo();
  return await repo.fetchLanguages();
});

final studentEducationLevelProvider = FutureProvider<List<String>>((ref) async {
  CampConnectJsonRepo repo = CampConnectJsonRepo();
  return await repo.fetchStudentEducationLevel();
});

final subjectsProvider = FutureProvider<List<String>>((ref) async {
  CampConnectJsonRepo repo = CampConnectJsonRepo();
  return await repo.fetchSubjects();
});

final countryProvider = FutureProvider<List<String>>((ref) async {
  CampConnectJsonRepo repo = CampConnectJsonRepo();
  return await repo.fetchCountries();
});

final teachedEducationLevelProvider = FutureProvider<List<String>>((ref) async {
  CampConnectJsonRepo repo = CampConnectJsonRepo();
  return await repo.fetchTeacherEducationLevel();
});
