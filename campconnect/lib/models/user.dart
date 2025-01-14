class User {
  String firstName;
  String lastName;
  DateTime dateOfBirth;
  String gender; // Optional
  String nationality;
  List<String> primaryLanguages;
  String mobileNumber;
  String email;
  String role; // 'student' or 'teacher'

  User({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    this.gender = '',
    required this.nationality,
    required this.primaryLanguages,
    required this.mobileNumber,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'],
      lastName: json['lastName'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      gender: json['gender'] ?? '',
      nationality: json['nationality'],
      primaryLanguages: List<String>.from(json['primaryLanguages']),
      mobileNumber: json['mobileNumber'],
      email: json['email'] ?? '',
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'nationality': nationality,
      'primaryLanguages': primaryLanguages,
      'mobileNumber': mobileNumber,
      'email': email,
      'role': role,
    };
  }
}
