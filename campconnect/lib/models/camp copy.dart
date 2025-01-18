import 'package:campconnect/models/class.dart'; // Assuming a Class model exists
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
  });

  factory Camp.fromJson(Map<String, dynamic> json) {
    return Camp(
      id: json['id'],
      name: json['name'],
      educationLevel: json['educationLevel'] != null
          ? List<String>.from(json['educationLevel'])
          : [],
      description: json['description'] ?? '',
      latitude: (json['latitude'] as num).toDouble(), // Ensure double type
      longitude: (json['longitude'] as num).toDouble(), // Ensure double type
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
    };
  }
}
