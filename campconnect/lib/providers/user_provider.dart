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
    //initalizeUsers();
    return [];
  }

  Future<void> initiazeUsers() async {
    
  }

}