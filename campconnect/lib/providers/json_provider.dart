import 'package:campconnect/repositories/camp_connect_json_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final languagesProvider = FutureProvider<List<String>>((ref) async {
  CampConnectJsonRepo repo = CampConnectJsonRepo();
  return repo.fetchLanguages();
});

final studentEducationLevelProvider = FutureProvider<List<String>>((ref) async {
  CampConnectJsonRepo repo = CampConnectJsonRepo();
  return repo.fetchStudentEducationLevel();
});

final subjectsProvider = FutureProvider<List<String>>((ref) async {
  CampConnectJsonRepo repo = CampConnectJsonRepo();
  return repo.fetchSubjects();
});

final countryProvider = FutureProvider<List<String>>((ref) async {
  CampConnectJsonRepo repo = CampConnectJsonRepo();
  return repo.fetchCountries();
});

final teachedEducationLevelProvider = FutureProvider<List<String>>((ref) async {
  CampConnectJsonRepo repo = CampConnectJsonRepo();
  return repo.fetchTeacherEducationLevel();
});

final additionalSupportProvider = FutureProvider<List<String>>((ref) async {
  CampConnectJsonRepo repo = CampConnectJsonRepo();
  return repo.fetchAdditionalSupport();
});
