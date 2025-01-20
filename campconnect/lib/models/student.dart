import 'package:campconnect/models/camp.dart';
import 'user.dart';

class Student extends User {
  String guardianContact; // For students under 15
  String guardianPhoneCode;
  String currentEducationLevel; // e.g., Primary, Secondary, High School
  List<String> preferredSubjects; // e.g., Math, Science
  String learningGoals; // Optional
  String specialNeeds; // Accessibility requirements (optional)
  String preferredDistanceForCamps; // e.g., "Within 5 km"
  List<String> savedCamps; // Saved camps (optional)

  Student({
    super.id,
    required super.firstName,
    required super.lastName,
    required super.dateOfBirth,
    required super.nationality,
    required super.primaryLanguages,
    required super.phoneCode,
    required super.mobileNumber,
    required super.email,
    required this.guardianContact,
    required this.guardianPhoneCode,
    required this.currentEducationLevel,
    required this.preferredSubjects,
    this.learningGoals = '',
    this.specialNeeds = '',
    required this.preferredDistanceForCamps,
    List<String>? savedCamps,
  })  : savedCamps = savedCamps ?? [],
        super(
          role: 'student',
        );

  @override
  String toString() {
    return '''
Student(
  id: $id,
  firstName: $firstName,
  lastName: $lastName,
  dateOfBirth: $dateOfBirth,
  nationality: $nationality,
  primaryLanguages: $primaryLanguages,
  phoneCode: $phoneCode,
  mobileNumber: $mobileNumber,
  email: $email,
  guardianContact: $guardianContact,
  guardianPhoneCode: $guardianPhoneCode,
  currentEducationLevel: $currentEducationLevel,
  preferredSubjects: $preferredSubjects,
  learningGoals: $learningGoals,
  specialNeeds: $specialNeeds,
  preferredDistanceForCamps: $preferredDistanceForCamps,
  savedCamps: $savedCamps,
  role: $role
)
''';
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      nationality: json['nationality'],
      primaryLanguages: List<String>.from(json['primaryLanguages']),
      phoneCode: json['phoneCode'],
      mobileNumber: json['mobileNumber'],
      email: json['email'] ?? '',
      guardianContact: json['guardianContact'],
      guardianPhoneCode: json['guardianPhoneCode'],
      currentEducationLevel: json['currentEducationLevel'],
      preferredSubjects: List<String>.from(json['preferredSubjects']),
      learningGoals: json['learningGoals'] ?? '',
      specialNeeds: json['specialNeeds'] ?? '',
      preferredDistanceForCamps: json['preferredDistanceForCamps'],
      savedCamps: json['savedCamps'] != null
          ? List<String>.from(json['savedCamps'])
          : [],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()
      ..addAll({
        'guardianContact': guardianContact,
        'guardianPhoneCode': guardianPhoneCode,
        'currentEducationLevel': currentEducationLevel,
        'preferredSubjects': preferredSubjects,
        'learningGoals': learningGoals,
        'specialNeeds': specialNeeds,
        'preferredDistanceForCamps': preferredDistanceForCamps,
        'savedCamps': savedCamps,
      });
  }

  Student copyWith({
    String? guardianContact,
    String? guardianPhoneCode,
    String? currentEducationLevel,
    List<String>? preferredSubjects,
    String? learningGoals,
    String? specialNeeds,
    String? preferredDistanceForCamps,
    List<String>? savedCamps,
  }) {
    return Student(
      id: id,
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dateOfBirth,
      nationality: nationality,
      primaryLanguages: primaryLanguages,
      phoneCode: phoneCode,
      mobileNumber: mobileNumber,
      email: email,
      guardianContact: guardianContact ?? this.guardianContact,
      guardianPhoneCode: guardianPhoneCode ?? this.guardianPhoneCode,
      currentEducationLevel:
          currentEducationLevel ?? this.currentEducationLevel,
      preferredSubjects: preferredSubjects ?? this.preferredSubjects,
      learningGoals: learningGoals ?? this.learningGoals,
      specialNeeds: specialNeeds ?? this.specialNeeds,
      preferredDistanceForCamps:
          preferredDistanceForCamps ?? this.preferredDistanceForCamps,
      savedCamps: savedCamps ?? this.savedCamps,
    );
  }
}
