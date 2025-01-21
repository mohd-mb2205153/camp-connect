import 'package:campconnect/repositories/camp_connect_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final repoProvider = FutureProvider<CampConnectRepo>((ref) async {
  debugPrint("Initializing repoProvider...");
  final db = FirebaseFirestore.instance;
  final studentsRef = db.collection("students");
  final teachersRef = db.collection("teachers");
  final campsRef = db.collection("camps");
  final classesRef = db.collection("classes");

  debugPrint("Collections initialized.");
  return CampConnectRepo(
    studentsRef: studentsRef,
    teachersRef: teachersRef,
    campsRef: campsRef,
    classesRef: classesRef,
  );
});
