import 'package:campconnect/models/student.dart';
import 'package:campconnect/models/teacher.dart';

class Camp {
  String? id;
  String educationLevel;
  List<String> subjects;
  bool specialNeeds;

  // List<Teacher> teachers;
  // List<Student> students;

  Camp({
    this.id,
    required this.educationLevel,
    required this.subjects,
    required this.specialNeeds,
    // required this.teachers,
    // required this.students
  });

  factory Camp.fromJson(Map<String, dynamic> json) {
    return Camp(
      id: json['id'],
      educationLevel: json['educationLevel'],
      subjects: json['subjects'],
      specialNeeds: json['specialNeeds'],
      // teachers: List<Teacher>.from(json['teachers']),
      // students: List<Student>.from(json['students'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "educationLevel": educationLevel,
      "subjects": subjects,
      "specialNeeds": specialNeeds,
      // "teachers": teachers,
      // "students": students
    };
  }
}
