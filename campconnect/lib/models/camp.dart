import 'package:campconnect/models/student.dart';
import 'package:campconnect/models/teacher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Camp {
  String? id;
  String educationLevel;
  List<String> subjects;
  String description;
  bool specialNeeds;
  double latitude;
  double longitude;
  List<String>? teachers; // Store teacher IDs (Firestore references)
  List<String>? students; // Store student IDs (Firestore references)

  Camp({
    this.id,
    required this.educationLevel,
    required this.subjects,
    required this.description,
    required this.specialNeeds,
    required this.latitude,
    required this.longitude,
    this.teachers,
    this.students,
  });

  // Factory method to create a Camp from JSON (Firestore document)
  factory Camp.fromJson(Map<String, dynamic> json) {
    return Camp(
      id: json['id'],
      educationLevel: json['educationLevel'] ?? '',
      subjects: List<String>.from(json['subjects'] ?? []), // Ensure List<String>
      description: json['description'] ?? '',
      specialNeeds: json['specialNeeds'] ?? false,
      latitude: (json['latitude'] as num).toDouble(), // Ensure double type
      longitude: (json['longitude'] as num).toDouble(), // Ensure double type
      teachers: json['teachers'] != null ? List<String>.from(json['teachers']) : [],
      students: json['students'] != null ? List<String>.from(json['students']) : [],
    );
  }

  // Convert a Camp object to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      "educationLevel": educationLevel,
      "subjects": subjects,
      "description": description,
      "specialNeeds": specialNeeds,
      "longitude": longitude,
      "latitude": latitude,
      "teachers": teachers ?? [],
      "students": students ?? [],
    };
  }
}
