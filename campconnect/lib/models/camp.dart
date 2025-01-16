import 'package:campconnect/models/student.dart';
import 'package:campconnect/models/teacher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Camp {
  String? id;
  String educationLevel;
  List<String> subjects;
  String description;
  bool specialNeeds;
  double latitude;
  double longitude;

  // List<Teacher> teachers;
  // List<Student> students;

  Camp({
    this.id,
    required this.educationLevel,
    required this.subjects,
    required this.description,
    required this.specialNeeds,
    required this.latitude,
    required this.longitude,

    // required this.teachers,
    // required this.students
  });

  factory Camp.fromJson(Map<String, dynamic> json) {
    return Camp(
        id: json['id'],
        educationLevel: json['educationLevel'],
        subjects: json['subjects'],
        description: json['description'],
        specialNeeds: json['specialNeeds'],
        latitude: json['latitude'],
        longitude: json['longitude']
        // teachers: List<Teacher>.from(json['teachers']),
        // students: List<Student>.from(json['students'])
        );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "educationLevel": educationLevel,
      "subjects": subjects,
      "description": description,
      "specialNeeds": specialNeeds,
      "longitude": longitude,
      "latitude": latitude
      // "teachers": teachers,
      // "students": students
    };
  }
}
