import 'package:campconnect/models/class.dart';
import 'package:campconnect/models/student.dart';
import 'package:campconnect/models/teacher.dart';
import 'package:campconnect/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/camp.dart';

class CampConnectRepo {
  final CollectionReference studentsRef;
  final CollectionReference teachersRef;
  final CollectionReference classesRef;
  final CollectionReference campsRef;

  CampConnectRepo({
    required this.studentsRef,
    required this.teachersRef,
    required this.classesRef,
    required this.campsRef,
  });

  // (*) Camp Repository ===================================================================
  Stream<List<Camp>> observeCamps() => campsRef.snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => Camp.fromJson(doc.data() as Map<String, dynamic>))
            .toList(),
      );

  Future<Camp?> getCampById(String campId) => campsRef.doc(campId).get().then(
        (snapshot) => Camp.fromJson(snapshot.data() as Map<String, dynamic>),
      );

  Future<String> addCamp(Camp camp) async {
    final docId = campsRef.doc().id;
    camp.id = docId;
    await campsRef.doc(docId).set(camp.toJson());
    return docId;
  }

  Future<void> updateCamp(Camp camp) =>
      campsRef.doc(camp.id).update(camp.toJson());

  Future<void> deleteCamp(Camp camp) => campsRef.doc(camp.id).delete();

  // (*) Student Repository ===================================================================
  Stream<List<Student>> observeStudents() => studentsRef.snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => Student.fromJson(doc.data() as Map<String, dynamic>))
            .toList(),
      );

  Future<Student?> getStudentById(String studentId) =>
      studentsRef.doc(studentId).get().then(
            (snapshot) =>
                Student.fromJson(snapshot.data() as Map<String, dynamic>),
          );

  Future<void> addStudent(Student student) async {
    final docId = studentsRef.doc().id;
    student.id = docId;
    await studentsRef.doc(student.id).set(student.toJson());
  }

  Future<void> updateStudent(Student student) =>
      studentsRef.doc(student.id).update(student.toJson());

  Future<void> deleteStudent(Student student) =>
      studentsRef.doc(student.id).delete();

  // (*) Teacher Repository ===================================================================
  Stream<List<Teacher>> observeTeachers() => teachersRef.snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => Teacher.fromJson(doc.data() as Map<String, dynamic>))
            .toList(),
      );

  Future<Teacher?> getTeacherById(String teacherId) =>
      teachersRef.doc(teacherId).get().then(
            (snapshot) =>
                Teacher.fromJson(snapshot.data() as Map<String, dynamic>),
          );

  Future<void> addCampToTeacher({
    required String teacherId,
    required String campId,
    required String field, // "createdCamps" or "teachingCamps"
  }) async {
    try {
      final teacherRef = teachersRef.doc(teacherId);
      await teacherRef.update({
        field: FieldValue.arrayUnion([campId]),
      });
    } catch (e) {
      throw Exception("Failed to update $field for teacher: $e");
    }
  }

  Future<void> addTeacher(Teacher teacher) async {
    final docId = teachersRef.doc().id;
    teacher.id = docId;
    await teachersRef.doc(teacher.id).set(teacher.toJson());
  }

  Future<void> updateTeacher(Teacher teacher) =>
      teachersRef.doc(teacher.id).update(teacher.toJson());

  Future<void> deleteTeacher(Teacher teacher) =>
      teachersRef.doc(teacher.id).delete();

  // (*) Class Repository ===================================================================
  Stream<List<Class>> observeClasses() => classesRef.snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => Class.fromJson(doc.data() as Map<String, dynamic>))
            .toList(),
      );

  Future<Class?> getClassById(String classId) =>
      classesRef.doc(classId).get().then(
            (snapshot) =>
                Class.fromJson(snapshot.data() as Map<String, dynamic>),
          );

  Future<void> addClass(Class classData) async {
    final docId = classesRef.doc().id;
    classData.id = docId;
    await classesRef.doc(classData.id).set(classData.toJson());
  }

  Future<void> updateClass(Class classData) =>
      classesRef.doc(classData.id).update(classData.toJson());

  Future<void> deleteClass(Class classData) =>
      classesRef.doc(classData.id).delete();
}
