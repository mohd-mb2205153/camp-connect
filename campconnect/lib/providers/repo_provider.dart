import 'package:campconnect/repositories/camp_Connect_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final repoProvider = FutureProvider<CampConnectRepo>((ref) async {
  final db = FirebaseFirestore.instance;
  final studentsRef = db.collection("students");
  final teachersRef = db.collection("teachers");
  final campsRef = db.collection("camps");

  return CampConnectRepo(
      studentsRef: studentsRef, teachersRef: teachersRef, campsRef: campsRef);
});


