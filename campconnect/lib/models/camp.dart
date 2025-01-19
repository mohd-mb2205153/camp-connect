import 'package:campconnect/models/class.dart';
import 'package:campconnect/models/teacher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Camp {
  String? id; // Unique identifier for the camp
  String name; // Name of the camp
  List<String>
      educationLevel; // List of education levels (e.g., ["Primary", "Secondary"])
  String description; // Description of the camp
  double latitude; // Latitude of the camp location
  double longitude; // Longitude of the camp location
  List<String>? teachers; // Store teacher IDs (Firestore references)
  List<Class>? classes; // List of class objects
  String statusOfResources; // Current status of camp resources
  List<String>?
      additionalSupport; // Additional support offered (e.g., trauma support, wifi, etc.)
  List<String>? languages;

  Camp({
    this.id,
    required this.name,
    required this.educationLevel,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.teachers,
    this.classes,
    required this.statusOfResources,
    this.additionalSupport,
    this.languages,
  });

  factory Camp.fromJson(Map<String, dynamic> json) {
    return Camp(
      id: json['id'],
      name: json['name'],
      educationLevel: json['educationLevel'] != null
          ? List<String>.from(json['educationLevel'])
          : [],
      description: json['description'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      teachers:
          json['teachers'] != null ? List<String>.from(json['teachers']) : [],
      classes: json['classes'] != null
          ? (json['classes'] as List)
              .map((classJson) => Class.fromJson(classJson))
              .toList()
          : [],
      statusOfResources: json['statusOfResources'] ?? '',
      additionalSupport: json['additionalSupport'] != null
          ? List<String>.from(json['additionalSupport'])
          : [],
      languages:
          json['languages'] != null ? List<String>.from(json['languages']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "educationLevel": educationLevel,
      "description": description,
      "latitude": latitude,
      "longitude": longitude,
      "teachers": teachers ?? [],
      "classes": classes?.map((classObj) => classObj.toJson()).toList() ?? [],
      "statusOfResources": statusOfResources,
      "additionalSupport": additionalSupport ?? [],
      "languages": languages,
    };
  }
}

// import 'package:campconnect/models/student.dart';
// import 'package:campconnect/models/teacher.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';

// class Camp {
//   String? id;
//   String name;
//   String educationLevel;
//   String subject;
//   String description;
//   bool specialNeeds;
//   double latitude;
//   double longitude;
//   List<String>? teachers; // Store teacher IDs (Firestore references)
//   List<String>? students; // Store student IDs (Firestore references)

//   Camp({
//     this.id,
//     required this.name,
//     required this.educationLevel,
//     required this.subject,
//     required this.description,
//     required this.specialNeeds,
//     required this.latitude,
//     required this.longitude,
//     this.teachers,
//     this.students,
//   });

//   // Factory method to create a Camp from JSON (Firestore document)
//   factory Camp.fromJson(Map<String, dynamic> json) {
//     return Camp(
//       id: json['id'],
//       name: json['name'],
//       educationLevel: json['educationLevel'] ?? '',
//       subject: json['subject'],
//       description: json['description'] ?? '',
//       specialNeeds: json['specialNeeds'] ?? false,
//       latitude: (json['latitude'] as num).toDouble(), // Ensure double type
//       longitude: (json['longitude'] as num).toDouble(), // Ensure double type
//       teachers:
//           json['teachers'] != null ? List<String>.from(json['teachers']) : [],
//       students:
//           json['students'] != null ? List<String>.from(json['students']) : [],
//     );
//   }

//   // Convert a Camp object to JSON for Firestore
//   Map<String, dynamic> toJson() {
//     return {
//       "id": id,
//       "name": name,
//       "educationLevel": educationLevel,
//       "subject": subject,
//       "description": description,
//       "specialNeeds": specialNeeds,
//       "latitude": latitude,
//       "longitude": longitude,
//       "teachers": teachers ?? [],
//       "students": students ?? [],
//     };
//   }
// }
