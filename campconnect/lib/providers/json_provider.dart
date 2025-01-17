import 'package:campconnect/repositories/camp_connect_json_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final languagesProvider = FutureProvider<List<String>>((ref) async {
  CampConnectJsonRepo repo = CampConnectJsonRepo();
  return await repo.fetchLanguages();
});

final educationLevelProvider = FutureProvider<List<String>>((ref) async {
  CampConnectJsonRepo repo = CampConnectJsonRepo();
  return await repo.fetchEducationLevel();
});

final subjectsProvider = FutureProvider<List<String>>((ref) async {
  CampConnectJsonRepo repo = CampConnectJsonRepo();
  return await repo.fetchSubjects();
});

final countryProvider = FutureProvider<List<String>>((ref) async {
  CampConnectJsonRepo repo = CampConnectJsonRepo();
  return await repo.fetchCountries();
});
