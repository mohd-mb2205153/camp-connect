class User {
  String? id;
  String firstName;
  String lastName;
  DateTime dateOfBirth;
  String nationality;
  List<String> primaryLanguages;
  String phoneCode;
  String mobileNumber;
  String email;
  String password;
  String role; // 'student' or 'teacher'

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.nationality,
    required this.primaryLanguages,
    required this.phoneCode,
    required this.mobileNumber,
    required this.email,
    this.password = '',
    required this.role,
  });

  @override
  String toString() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'nationality': nationality,
      'primaryLanguages': primaryLanguages,
      'phoneCode': phoneCode,
      'mobileNumber': mobileNumber,
      'email': email,
      'password': password,
      'role': role,
    }.toString();
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      nationality: json['nationality'],
      primaryLanguages: List<String>.from(json['primaryLanguages']),
      phoneCode: json['phoneCode'],
      mobileNumber: json['mobileNumber'],
      email: json['email'] ?? '',
      password: json['password'] ?? '', // Add password here
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
      'phoneCode': phoneCode,
      'mobileNumber': mobileNumber,
      'email': email,
      'password': password, // Include password in toJson
      'role': role,
    };
  }
}
