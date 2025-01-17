import 'package:campconnect/models/camp.dart';

import 'user.dart';

class Teacher extends User {
  String highestEducationLevel; // e.g., Bachelor’s, Master’s
  List<String> certifications; // Relevant certifications or degrees
  int teachingExperience; // Number of years of experience
  List<String> areasOfExpertise; // Subjects taught
  String preferredLocation; // Automatically detected via GPS or manually set
  String willingnessToTravel; // e.g., "Within 10 km"
  String availabilitySchedule; // Days and times available
  String preferredCampDuration; // e.g., "Short-term"
  List<String> enrolledCamps;

  Teacher(
      {super.id,
      required super.firstName,
      required super.lastName,
      required super.dateOfBirth,
      required super.nationality,
      required super.primaryLanguages,
      required super.countryCode,
      required super.mobileNumber,
      super.email = '',
      required this.highestEducationLevel,
      required this.certifications,
      required this.teachingExperience,
      required this.areasOfExpertise,
      required this.preferredLocation,
      required this.willingnessToTravel,
      required this.availabilitySchedule,
      required this.preferredCampDuration,
      required this.enrolledCamps})
      : super(
          role: 'teacher',
        );

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        dateOfBirth: DateTime.parse(json['dateOfBirth']),
        nationality: json['nationality'],
        primaryLanguages: List<String>.from(json['primaryLanguages']),
        countryCode: json['countryCode'],
        mobileNumber: json['mobileNumber'],
        email: json['email'] ?? '',
        highestEducationLevel: json['highestEducationLevel'],
        certifications: List<String>.from(json['certifications']),
        teachingExperience: json['teachingExperience'],
        areasOfExpertise: List<String>.from(json['areasOfExpertise']),
        preferredLocation: json['preferredLocation'],
        willingnessToTravel: json['willingnessToTravel'],
        availabilitySchedule: json['availabilitySchedule'],
        preferredCampDuration: json['preferredCampDuration'],
        enrolledCamps: List<String>.from(json['enrolledCamps']));
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()
      ..addAll({
        'highestEducationLevel': highestEducationLevel,
        'certifications': certifications,
        'teachingExperience': teachingExperience,
        'areasOfExpertise': areasOfExpertise,
        'preferredLocation': preferredLocation,
        'willingnessToTravel': willingnessToTravel,
        'availabilitySchedule': availabilitySchedule,
        'preferredCampDuration': preferredCampDuration,
        'enrolledCamps': enrolledCamps
      });
  }
}
