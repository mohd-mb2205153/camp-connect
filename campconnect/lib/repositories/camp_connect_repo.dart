import 'package:campconnect/models/student.dart';
import 'package:campconnect/models/teacher.dart';
import 'package:campconnect/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/camp.dart';

class CampConnectRepo {
  final CollectionReference studentsRef;
  final CollectionReference teachersRef;
  final CollectionReference campsRef;
  final CollectionReference usersRef;

  CampConnectRepo(
      {required this.studentsRef,
      required this.teachersRef,
      required this.campsRef,
      required this.usersRef});
  
  // (*) Camp Repository ===================================================================
  Stream<List<Camp>> observeCamps() =>
  campsRef.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => Camp.fromJson(doc.data() as Map<String, dynamic>))
          .toList());

  Future<Camp?> getCampById(String campId) => campsRef.doc(campId).get().then(
      (snapshot) => Camp.fromJson(snapshot.data() as Map<String, dynamic>));

  Future<void> addCamp(Camp camp) async {
    final docId = campsRef.doc().id;
    camp.id = docId;
    await campsRef.doc(camp.id).set(camp.toJson());
  }

  Future<void> updateCamp(Camp camp) =>
      campsRef.doc(camp.id).update(camp.toJson());

  Future<void> deleteCamp(Camp camp) => campsRef.doc(camp.id).delete();

  // (*) Student Repository ===================================================================
  Stream<List<Student>> observeStudents() =>
  studentsRef.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => Student.fromJson(doc.data() as Map<String, dynamic>))
          .toList());

  Future<Student?> getStudentById(String studentId) => studentsRef.doc(studentId).get().then(
      (snapshot) => Student.fromJson(snapshot.data() as Map<String, dynamic>));

  Future<void> addStudent(Student student) async {
    final docId = studentsRef.doc().id;
    student.id = docId;
    await studentsRef.doc(student.id).set(student.toJson());

  Future<void> updateStudent(Student student) =>
      studentsRef.doc(student.id).update(student.toJson());

  Future<void> deleteStudent(Student student) => studentsRef.doc(student.id).delete();
  }
  // (*) Teacher Repository ===================================================================
  Stream<List<Teacher>> observeTeachers() =>
  teachersRef.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => Teacher.fromJson(doc.data() as Map<String, dynamic>))
          .toList());

  Future<Teacher?> getTeacherById(String teacherId) => teachersRef.doc(teacherId).get().then(
      (snapshot) => Teacher.fromJson(snapshot.data() as Map<String, dynamic>));

  Future<void> addTeacher(Teacher teacher) async {
    final docId = teachersRef.doc().id;
    teacher.id = docId;
    await teachersRef.doc(teacher.id).set(teacher.toJson());
  }

  Future<void> updateTeacher(Teacher teacher) =>
    teachersRef.doc(teacher.id).update(teacher.toJson());

  Future<void> deleteTeacher(Teacher teacher) => teachersRef.doc(teacher.id).delete();

  // (*) User Repository ===================================================================
  Stream<List<User>> observeUsers() =>
  usersRef.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => User.fromJson(doc.data() as Map<String, dynamic>))
          .toList());

  Future<User?> getUserById(String userId) => usersRef.doc(userId).get().then(
      (snapshot) => User.fromJson(snapshot.data() as Map<String, dynamic>));

  Future<void> addUser(User user) async {
    final docId = usersRef.doc().id;
    user.id = docId;
    await usersRef.doc(user.id).set(user.toJson());
  }

  Future<void> updateUser(User user) =>
    usersRef.doc(user.id).update(user.toJson());

  Future<void> deleteUser(User user) => usersRef.doc(user.id).delete();
}
