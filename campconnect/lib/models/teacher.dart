import 'package:campconnect/models/camp.dart';
import 'user.dart';

class Teacher extends User {
  String highestEducationLevel; // e.g., Bachelor’s, Master’s
  List<String> certifications; // Relevant certifications or degrees
  int teachingExperience; // Number of years of experience
  List<String> areasOfExpertise; // Subjects taught
  String willingnessToTravel; // e.g., "Within 10 km"
  String availabilitySchedule; // Days and times available
  String preferredCampDuration; // e.g., "Short-term"
  List<String> createdCamps; // List of created camps
  List<String> teachingCamps; // List of teaching camps

  Teacher({
    super.id,
    required super.firstName,
    required super.lastName,
    required super.dateOfBirth,
    required super.nationality,
    required super.primaryLanguages,
    required super.countryCode,
    required super.phoneCode,
    required super.mobileNumber,
    super.email = '',
    required this.highestEducationLevel,
    List<String>? certifications,
    required this.teachingExperience,
    required this.areasOfExpertise,
    required this.willingnessToTravel,
    required this.availabilitySchedule,
    required this.preferredCampDuration,
    List<String>? createdCamps,
    List<String>? teachingCamps,
  })  : certifications = certifications ?? [],
        createdCamps = createdCamps ?? [],
        teachingCamps = teachingCamps ?? [],
        super(role: 'teacher');

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      nationality: json['nationality'],
      primaryLanguages: List<String>.from(json['primaryLanguages']),
      phoneCode: json['phoneCode'],
      countryCode: json['countryCode'],
      mobileNumber: json['mobileNumber'],
      email: json['email'] ?? '',
      highestEducationLevel: json['highestEducationLevel'],
      certifications: json['certifications'] != null
          ? List<String>.from(json['certifications'])
          : [],
      teachingExperience: json['teachingExperience'],
      areasOfExpertise: List<String>.from(json['areasOfExpertise']),
      willingnessToTravel: json['willingnessToTravel'],
      availabilitySchedule: json['availabilitySchedule'],
      preferredCampDuration: json['preferredCampDuration'],
      createdCamps: json['createdCamps'] != null
          ? List<String>.from(json['createdCamps'])
          : [],
      teachingCamps: json['teachingCamps'] != null
          ? List<String>.from(json['teachingCamps'])
          : [],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()
      ..addAll({
        'highestEducationLevel': highestEducationLevel,
        'certifications': certifications,
        'teachingExperience': teachingExperience,
        'areasOfExpertise': areasOfExpertise,
        'willingnessToTravel': willingnessToTravel,
        'availabilitySchedule': availabilitySchedule,
        'preferredCampDuration': preferredCampDuration,
        'createdCamps': createdCamps,
        'teachingCamps': teachingCamps,
      });
  }
}
