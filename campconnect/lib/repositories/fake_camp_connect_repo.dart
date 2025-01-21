import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/camp.dart';
import '../models/class.dart';
import '../models/student.dart';
import '../models/teacher.dart';
import 'camp_connect_repo.dart';

class FakeCampConnectRepo implements CampConnectRepo {
  @override
  Future<void> updateStudent(Student student) async {}

  @override
  Future<void> updateTeacher(Teacher teacher) async {}

  @override
  Future<String> addCamp(Camp camp) {
    // TODO: implement addCamp
    throw UnimplementedError();
  }

  @override
  Future<void> addCampToTeacher(
      {required String teacherId,
      required String campId,
      required String field}) {
    // TODO: implement addCampToTeacher
    throw UnimplementedError();
  }

  @override
  Future<String> addClass(Class classData) {
    // TODO: implement addClass
    throw UnimplementedError();
  }

  @override
  Future<void> addStudent(Student student) {
    // TODO: implement addStudent
    throw UnimplementedError();
  }

  @override
  Future<void> addTeacher(Teacher teacher) {
    // TODO: implement addTeacher
    throw UnimplementedError();
  }

  @override
  // TODO: implement campsRef
  CollectionReference<Object?> get campsRef => throw UnimplementedError();

  @override
  // TODO: implement classesRef
  CollectionReference<Object?> get classesRef => throw UnimplementedError();

  @override
  Future<void> deleteCamp(Camp camp) {
    // TODO: implement deleteCamp
    throw UnimplementedError();
  }

  @override
  Future<void> deleteClass(Class classData) {
    // TODO: implement deleteClass
    throw UnimplementedError();
  }

  @override
  Future<void> deleteStudent(Student student) {
    // TODO: implement deleteStudent
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTeacher(Teacher teacher) {
    // TODO: implement deleteTeacher
    throw UnimplementedError();
  }

  @override
  Future<Camp?> getCampById(String campId) {
    // TODO: implement getCampById
    throw UnimplementedError();
  }

  @override
  Future<Class?> getClassById(String classId) {
    // TODO: implement getClassById
    throw UnimplementedError();
  }

  @override
  Future<List<Camp>> getCreatedCampsByTeacherId(String teacherId) {
    // TODO: implement getCreatedCampsByTeacherId
    throw UnimplementedError();
  }

  @override
  Future<Student?> getStudentById(String studentId) {
    // TODO: implement getStudentById
    throw UnimplementedError();
  }

  @override
  Future<Teacher?> getTeacherById(String teacherId) {
    // TODO: implement getTeacherById
    throw UnimplementedError();
  }

  @override
  Future<List<Teacher>> getTeachersByCampId(String campId) {
    // TODO: implement getTeachersByCampId
    throw UnimplementedError();
  }

  @override
  Future<List<Camp>> getTeachingCampsByTeacherId(String teacherId) {
    // TODO: implement getTeachingCampsByTeacherId
    throw UnimplementedError();
  }

  @override
  Stream<List<Camp>> observeCamps() {
    // TODO: implement observeCamps
    throw UnimplementedError();
  }

  @override
  Stream<List<Class>> observeClasses() {
    // TODO: implement observeClasses
    throw UnimplementedError();
  }

  @override
  Stream<List<Student>> observeStudents() {
    // TODO: implement observeStudents
    throw UnimplementedError();
  }

  @override
  Stream<List<Teacher>> observeTeachers() {
    // TODO: implement observeTeachers
    throw UnimplementedError();
  }

  @override
  // TODO: implement studentsRef
  CollectionReference<Object?> get studentsRef => throw UnimplementedError();

  @override
  // TODO: implement teachersRef
  CollectionReference<Object?> get teachersRef => throw UnimplementedError();

  @override
  Future<void> updateCamp(Camp camp) {
    // TODO: implement updateCamp
    throw UnimplementedError();
  }

  @override
  Future<void> updateClass(Class classData) {
    // TODO: implement updateClass
    throw UnimplementedError();
  }
  
  @override
  Stream<List<Camp>> filterCampByEducationLevel(String level) {
    // TODO: implement filterCampByEducationLevel
    throw UnimplementedError();
  }
  
  @override
  Stream<List<Camp>> filterCampByAdditionalSupport(String supports) {
    // TODO: implement filterCampByAdditionalSupport
    throw UnimplementedError();
  }
  
  @override
  Stream<List<Camp>> filterCampByLanguage(String language) {
    // TODO: implement filterCampByLanguage
    throw UnimplementedError();
  }
}
