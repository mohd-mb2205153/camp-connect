import 'teacher.dart';

class Class {
  String id; // Unique identifier for the class
  Teacher teacher; // Teacher teaching the class
  String description; // Description of the class
  String subject; // Main subject of the class (e.g., Mathematics)
  String subtitle; // Subtitle for the class (e.g., Algebra)
  String timeFrom; // Start time of the class as a string (e.g., "12:00")
  String timeTo; // End time of the class as a string (e.g., "14:00")

  Class({
    required this.id,
    required this.teacher,
    required this.description,
    required this.subject,
    required this.subtitle,
    required this.timeFrom,
    required this.timeTo,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['id'],
      teacher: Teacher.fromJson(json['teacher']),
      description: json['description'],
      subject: json['subject'],
      subtitle: json['subtitle'],
      timeFrom: json['timeFrom'],
      timeTo: json['timeTo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teacher': teacher.toJson(),
      'description': description,
      'subject': subject,
      'subtitle': subtitle,
      'timeFrom': timeFrom,
      'timeTo': timeTo,
    };
  }
}
