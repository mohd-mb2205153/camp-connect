class User {
  String? id;
  String firstName;
  String lastName;
  DateTime dateOfBirth;
  String nationality;
  List<String> primaryLanguages;
  String countryCode;
  String mobileNumber;
  String email;
  String role; // 'student' or 'teacher'

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.nationality,
    required this.primaryLanguages,
    required this.countryCode,
    required this.mobileNumber,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      nationality: json['nationality'],
      primaryLanguages: List<String>.from(json['primaryLanguages']),
      countryCode: json['countryCode'],
      mobileNumber: json['mobileNumber'],
      email: json['email'] ?? '',
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'nationality': nationality,
      'primaryLanguages': primaryLanguages,
      'countryCode': countryCode,
      'mobileNumber': mobileNumber,
      'email': email,
      'role': role,
    };
  }
}
