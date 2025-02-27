import 'package:campconnect/models/class.dart';
import 'package:campconnect/models/student.dart';
import 'package:campconnect/models/teacher.dart';
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

  Future<void> updateCamp(Camp camp) async {
    await campsRef.doc(camp.id).update(camp.toJson());
  }

  Future<void> deleteCamp(Camp camp) => campsRef.doc(camp.id).delete();

  Future<List<Camp>> getTeachingCampsByTeacherId(String teacherId) async {
    try {
      Teacher? teacher = await getTeacherById(teacherId);

      final teachingCampIds = teacher?.teachingCamps ?? [];

      if (teachingCampIds.isEmpty) return [];

      final querySnapshot = await campsRef
          .where(FieldPath.documentId, whereIn: teachingCampIds)
          .get();

      return querySnapshot.docs
          .map((doc) => Camp.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error fetching teaching camps: $e');
    }
  }

  Future<List<Camp>> getSavedCampsByStudentId(String studentId) async {
    try {
      Student? student = await getStudentById(studentId);

      final savedCampIds = student?.savedCamps ?? [];

      if (savedCampIds.isEmpty) return [];

      final querySnapshot = await campsRef
          .where(FieldPath.documentId, whereIn: savedCampIds)
          .get();

      return querySnapshot.docs
          .map((doc) => Camp.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error fetching saved camps: $e');
    }
  }

  Stream<List<Camp>> filterCampByEducationLevel(List<String> levels) => campsRef
      .where("educationLevel", arrayContainsAny: levels)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Camp.fromJson(doc.data() as Map<String, dynamic>))
          .toList());

  // Stream<List<Camp>> filterCampByAdditionalSupport(List<String> supports) =>
  //     campsRef
  //         .where("additionalSupport", arrayContainsAny: supports)
  //         .snapshots()
  //         .map((snapshot) => snapshot.docs
  //             .map((doc) => Camp.fromJson(doc.data() as Map<String, dynamic>))
  //             .toList());

  // Stream<List<Camp>> filterCampByLanguage(List<String> languages) => campsRef
  //     .where("languages", arrayContainsAny: languages)
  //     .snapshots()
  //     .map((snapshot) => snapshot.docs
  //         .map((doc) => Camp.fromJson(doc.data() as Map<String, dynamic>))
  //         .toList());

  Future<List<Camp>> filterCampByName(String queryName) async {
    final querySnapshot = await campsRef
        .where("name", isGreaterThanOrEqualTo: queryName)
        .where("name", isLessThanOrEqualTo: '${queryName}z')
        .get();
    return querySnapshot.docs
        .map((doc) => Camp.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

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
  Future<Student?> getStudentByEmail(String email) async {
    try {
      //Isssue is here
      final querySnapshot =
          await studentsRef.where('email', isEqualTo: email).limit(1).get();
      if (querySnapshot.docs.isNotEmpty) {
        // Convert document to Student object
        return Student.fromJson(
            querySnapshot.docs.first.data() as Map<String, dynamic>);
      }
      print("No student found");
      return null;
    } catch (e) {
      print("Error fetching student: $e");
      return null;
    }
  }

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

  Future<List<Teacher>> getTeachersByCampId(String campId) async {
    try {
      final teachersSnapshot =
          await teachersRef.where('teachingCamps', arrayContains: campId).get();
      return teachersSnapshot.docs
          .map((doc) => Teacher.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error fetching teachers for campId $campId: $e');
    }
  }

  Future<List<Teacher>> getTeachersByStatus(String status) async {
    try {
      final querySnapshot = await teachersRef
          .where('verificationStatus', isEqualTo: status)
          .get();
      return querySnapshot.docs
          .map((doc) => Teacher.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error fetching teachers with status $status: $e');
    }
  }

  Future<int> getSavedStudentCountForCamp(String campId) async {
    try {
      final querySnapshot =
          await studentsRef.where("savedCamps", arrayContains: campId).get();

      return querySnapshot.size;
    } catch (e) {
      print("Error fetching saved students count: $e");
      return 0;
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

  Future<String> addClass(Class classData) async {
    final docRef = classesRef.doc(); // Generate new document ID
    classData.id = docRef.id;
    await docRef.set(classData.toJson());
    return docRef.id;
  }

  Future<void> updateClass(Class classData) =>
      classesRef.doc(classData.id).update(classData.toJson());

  Future<void> deleteClass(Class classData) =>
      classesRef.doc(classData.id).delete();

  Future<List<Class>> getClassByCampId(String campId) async {
    try {
      Camp? camp = await getCampById(campId);

      final classIds = camp?.classId ?? [];

      if (classIds.isEmpty) return [];

      final querySnapshot =
          await classesRef.where(FieldPath.documentId, whereIn: classIds).get();

      return querySnapshot.docs
          .map((doc) => Class.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error fetching Camp ID($campId) classes: $e');
    }
  }
}
