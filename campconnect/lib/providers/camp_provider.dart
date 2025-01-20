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
}

final campProviderNotifier =
    AsyncNotifierProvider<CampProvider, List<Camp>>(() => CampProvider());
