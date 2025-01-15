import 'package:campconnect/models/camp.dart';

import 'user.dart';

class Student extends User {
  String guardianContact; // For students under 15
  String currentEducationLevel; // e.g., Primary, Secondary, High School
  List<String> preferredSubjects; // e.g., Math, Science
  String learningGoals; // Optional
  String specialNeeds; // Accessibility requirements (optional)
  String currentLocation; // Automatically detected via GPS
  String preferredDistanceForCamps; // e.g., "Within 5 km"
  List<String> enrolledCamps;

  Student({
    required super.firstName,
    required super.lastName,
    required super.dateOfBirth,
    super.gender,
    required super.nationality,
    required super.primaryLanguages,
    required super.mobileNumber,
    super.email = '',
    required this.guardianContact,
    required this.currentEducationLevel,
    required this.preferredSubjects,
    this.learningGoals = '',
    this.specialNeeds = '',
    required this.currentLocation,
    required this.preferredDistanceForCamps,
    required this.enrolledCamps
  }) : super(
          role: 'student',
        );

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      firstName: json['firstName'],
      lastName: json['lastName'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      gender: json['gender'] ?? '',
      nationality: json['nationality'],
      primaryLanguages: List<String>.from(json['primaryLanguages']),
      mobileNumber: json['mobileNumber'],
      email: json['email'] ?? '',
      guardianContact: json['guardianContact'],
      currentEducationLevel: json['currentEducationLevel'],
      preferredSubjects: List<String>.from(json['preferredSubjects']),
      learningGoals: json['learningGoals'] ?? '',
      specialNeeds: json['specialNeeds'] ?? '',
      currentLocation: json['currentLocation'],
      preferredDistanceForCamps: json['preferredDistanceForCamps'],
      enrolledCamps: List<String>.from(json['enrolledCamps'])
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()
      ..addAll({
        'guardianContact': guardianContact,
        'currentEducationLevel': currentEducationLevel,
        'preferredSubjects': preferredSubjects,
        'learningGoals': learningGoals,
        'specialNeeds': specialNeeds,
        'currentLocation': currentLocation,
        'preferredDistanceForCamps': preferredDistanceForCamps,
        'enrolledCamps': enrolledCamps
      });
  }
}
