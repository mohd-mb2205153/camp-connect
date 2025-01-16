import 'package:campconnect/models/student.dart';
import 'package:campconnect/models/teacher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/camp.dart';

class CampConnectRepo {
  final CollectionReference studentsRef;
  final CollectionReference teachersRef;
  final CollectionReference campsRef;

  CampConnectRepo(
      {required this.studentsRef,
      required this.teachersRef,
      required this.campsRef});

  Future<void> addCamp(Camp camp) async {
    final docId = campsRef.doc().id;
    camp.id = docId;
    await campsRef.doc(camp.id).set(camp.toJson());
  }

  Future<void> addStudent(Student student) async {
    final docId = studentsRef.doc().id;
    student.id = docId;
    await campsRef.doc(student.id).set(student.toJson());
  }

  Future<void> addTeacher(Teacher teacher) async {
    final docId = campsRef.doc().id;
    teacher.id = docId;
    await campsRef.doc(teacher.id).set(teacher.toJson());
  }
}
