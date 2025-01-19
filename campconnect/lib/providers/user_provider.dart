import 'dart:async';

import 'package:campconnect/models/user.dart';
import 'package:campconnect/providers/repo_provider.dart';
import 'package:campconnect/repositories/camp_connect_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends AsyncNotifier<List<User>> {
  late final CampConnectRepo _repo;
  @override
  Future<List<User>> build() async{
    _repo = await ref.watch(repoProvider.future);
    initializeUsers();
    return [];
  }

  Future<void> initializeUsers() async {
    _repo.observeUsers().listen((user){
      state = AsyncData(user);
    }).onError((error){
      print(error);
    });
  }
  void removeUser(User user) {
    _repo.deleteUser(user);
  }

  void addUser(User user) {
    _repo.addUser(user);
  }

  void updateUser(User user){
    _repo.updateUser(user);
  }
}

final userNotifierProvider =
    AsyncNotifierProvider<UserNotifier, List<User>>(
        () => UserNotifier());