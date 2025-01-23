import 'user.dart';

class Teacher extends User {
  String highestEducationLevel; // e.g., Bachelor’s, Master’s
  List<String> certifications; // Relevant certifications or degrees
  int teachingExperience; // Number of years of experience
  List<String> areasOfExpertise; // Subjects taught
  String willingnessToTravel; // e.g., "Within 10 km"
  String availabilitySchedule; // times available
  String preferredCampDuration; // e.g., "Short-term"
  List<String> teachingCamps; // List of teaching camps

  Teacher({
    super.id,
    required super.firstName,
    required super.lastName,
    required super.dateOfBirth,
    required super.nationality,
    required super.primaryLanguages,
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
        teachingCamps = teachingCamps ?? [],
        super(role: 'teacher');

  @override
  String toString() {
    return '''
Teacher(
  id: $id,
  firstName: $firstName,
  lastName: $lastName,
  dateOfBirth: $dateOfBirth,
  nationality: $nationality,
  primaryLanguages: $primaryLanguages,
  phoneCode: $phoneCode,
  mobileNumber: $mobileNumber,
  email: $email,
  highestEducationLevel: $highestEducationLevel,
  certifications: $certifications,
  teachingExperience: $teachingExperience,
  areasOfExpertise: $areasOfExpertise,
  willingnessToTravel: $willingnessToTravel,
  availabilitySchedule: $availabilitySchedule,
  preferredCampDuration: $preferredCampDuration,
  teachingCamps: $teachingCamps,
  role: $role
)
''';
  }

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      nationality: json['nationality'],
      primaryLanguages: List<String>.from(json['primaryLanguages']),
      phoneCode: json['phoneCode'],
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
        'teachingCamps': teachingCamps,
      });
  }

  Teacher copyWith({
    String? id,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? nationality,
    List<String>? primaryLanguages,
    String? phoneCode,
    String? mobileNumber,
    String? email,
    String? highestEducationLevel,
    List<String>? certifications,
    int? teachingExperience,
    List<String>? areasOfExpertise,
    String? willingnessToTravel,
    String? availabilitySchedule,
    String? preferredCampDuration,
    List<String>? teachingCamps,
  }) {
    return Teacher(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      nationality: nationality ?? this.nationality,
      primaryLanguages: primaryLanguages ?? this.primaryLanguages,
      phoneCode: phoneCode ?? this.phoneCode,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      highestEducationLevel:
          highestEducationLevel ?? this.highestEducationLevel,
      certifications: certifications ?? this.certifications,
      teachingExperience: teachingExperience ?? this.teachingExperience,
      areasOfExpertise: areasOfExpertise ?? this.areasOfExpertise,
      willingnessToTravel: willingnessToTravel ?? this.willingnessToTravel,
      availabilitySchedule: availabilitySchedule ?? this.availabilitySchedule,
      preferredCampDuration:
          preferredCampDuration ?? this.preferredCampDuration,
      teachingCamps: teachingCamps ?? this.teachingCamps,
    );
  }
}
