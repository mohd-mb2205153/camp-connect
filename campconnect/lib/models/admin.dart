import 'package:campconnect/models/user.dart';

class Admin extends User {
  Admin({
    required super.firstName,
    required super.lastName,
    required super.dateOfBirth,
    required super.nationality,
    required super.primaryLanguages,
    required super.phoneCode,
    required super.mobileNumber,
    required super.email,
  }) : super(role: 'admin');

  @override
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'nationality': nationality,
      'primaryLanguages': primaryLanguages,
      'phoneCode': phoneCode,
      'mobileNumber': mobileNumber,
      'email': email,
      'role': role,
    };
  }

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      firstName: json['firstName'],
      lastName: json['lastName'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      nationality: json['nationality'],
      primaryLanguages: List<String>.from(json['primaryLanguages']),
      phoneCode: json['phoneCode'],
      mobileNumber: json['mobileNumber'],
      email: json['email'],
    );
  }
}
