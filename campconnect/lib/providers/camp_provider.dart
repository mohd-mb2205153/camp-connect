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

  void addCamp(Camp camp) {
    _repo.addCamp(camp);
  }

  void deleteCamp(Camp camp) {
    _repo.deleteCamp(camp);
  }

  void updateCamp(Camp camp) {
    _repo.updateCamp(camp);
  }
}

final campProviderNotifier =
    AsyncNotifierProvider<CampProvider, List<Camp>>(() => CampProvider());
